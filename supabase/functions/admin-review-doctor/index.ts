// Supabase Edge Function: admin-review-doctor
// Approves or rejects doctor application, un-bans user, writes audit log.

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const supabaseAdmin = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? ""
    );

    // Verify caller authorization
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return new Response(JSON.stringify({ error: "Unauthorized" }), { status: 401, headers: corsHeaders });
    }

    const token = authHeader.replace("Bearer ", "");
    const { data: { user }, error: userError } = await supabaseAdmin.auth.getUser(token);
    if (userError || !user) {
      return new Response(JSON.stringify({ error: "Invalid token" }), { status: 401, headers: corsHeaders });
    }

    // Check caller is admin
    const { data: callerProfile } = await supabaseAdmin
      .from("profiles")
      .select("role")
      .eq("id", user.id)
      .single();

    if (callerProfile?.role !== "admin") {
      return new Response(JSON.stringify({ error: "Forbidden: Staff access only" }), { status: 403, headers: corsHeaders });
    }

    const { applicationId, decision, reason, notes } = await req.json();

    if (!applicationId || !decision || !["approved", "rejected"].includes(decision)) {
      return new Response(
        JSON.stringify({ error: "Invalid review parameters" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Fetch existing application
    const { data: application, error: appFetchError } = await supabaseAdmin
      .from("doctor_applications")
      .select("*, doctor:profiles!doctor_id(id, email, name)")
      .eq("id", applicationId)
      .single();

    if (appFetchError || !application) {
      return new Response(
        JSON.stringify({ error: "Application not found" }),
        { status: 404, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const doctorId = application.doctor_id;

    if (decision === "approved") {
      // 1. Update application record
      await supabaseAdmin
        .from("doctor_applications")
        .update({
          status: "approved",
          reviewed_by: user.id,
          reviewed_at: new Date().toISOString(),
        })
        .eq("id", applicationId);

      // 2. Mark doctor profile verified
      await supabaseAdmin
        .from("doctor_profiles")
        .update({ is_verified: true })
        .eq("id", doctorId);

      // 3. Mark account active
      await supabaseAdmin
        .from("profiles")
        .update({ account_status: "active" })
        .eq("id", doctorId);

      // 4. Audit log
      await supabaseAdmin.from("audit_log").insert({
        actor_id: user.id,
        action: "approve_doctor",
        target_type: "doctor_application",
        target_id: applicationId,
        details: { doctor_id: doctorId, doctor_name: application.doctor?.name },
      });
    } else {
      // Rejected
      const newStatus = application.attempt_number >= 3 ? "permanently_rejected" : "rejected";

      await supabaseAdmin
        .from("doctor_applications")
        .update({
          status: newStatus,
          reject_reason: reason,
          reject_notes: notes,
          reviewed_by: user.id,
          reviewed_at: new Date().toISOString(),
        })
        .eq("id", applicationId);

      // Audit log
      await supabaseAdmin.from("audit_log").insert({
        actor_id: user.id,
        action: "reject_doctor",
        target_type: "doctor_application",
        target_id: applicationId,
        details: { doctor_id: doctorId, reason, notes, attempts_used: application.attempt_number },
      });
    }

    return new Response(
      JSON.stringify({ success: true, decision, applicationId }),
      { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } catch (err) {
    return new Response(
      JSON.stringify({ error: err.message }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});

