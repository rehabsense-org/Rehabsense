// Supabase Edge Function: admin-set-account-status
// Enables admin to suspend, reactivate, or soft-delete a doctor or patient account.

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

    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return new Response(JSON.stringify({ error: "Unauthorized" }), { status: 401, headers: corsHeaders });
    }

    const token = authHeader.replace("Bearer ", "");
    const { data: { user }, error: userError } = await supabaseAdmin.auth.getUser(token);
    if (userError || !user) {
      return new Response(JSON.stringify({ error: "Invalid token" }), { status: 401, headers: corsHeaders });
    }

    const { data: callerProfile } = await supabaseAdmin
      .from("profiles")
      .select("role")
      .eq("id", user.id)
      .single();

    if (callerProfile?.role !== "admin") {
      return new Response(JSON.stringify({ error: "Forbidden: Staff access only" }), { status: 403, headers: corsHeaders });
    }

    const { targetUserId, newStatus, reason } = await req.json();

    if (!targetUserId || !newStatus || !["active", "disabled"].includes(newStatus)) {
      return new Response(
        JSON.stringify({ error: "Invalid parameters" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    if (targetUserId === user.id) {
      return new Response(
        JSON.stringify({ error: "Admins cannot change their own account status" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Update profile
    const updateData: Record<string, unknown> = {
      account_status: newStatus,
    };
    if (newStatus === "disabled") {
      updateData.archived_at = new Date().toISOString();
    } else {
      updateData.archived_at = null;
    }

    const { error: updateError } = await supabaseAdmin
      .from("profiles")
      .update(updateData)
      .eq("id", targetUserId);

    if (updateError) {
      return new Response(
        JSON.stringify({ error: updateError.message }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Ban or unban auth user
    await supabaseAdmin.auth.admin.updateUserById(targetUserId, {
      ban_duration: newStatus === "disabled" ? "876000h" : "none", // 100 years or unban
    });

    // Write audit log
    await supabaseAdmin.from("audit_log").insert({
      actor_id: user.id,
      action: newStatus === "disabled" ? "suspend_account" : "reactivate_account",
      target_type: "profile",
      target_id: targetUserId,
      details: { new_status: newStatus, reason: reason ?? "Admin initiated" },
    });

    return new Response(
      JSON.stringify({ success: true, targetUserId, newStatus }),
      { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } catch (err) {
    return new Response(
      JSON.stringify({ error: err.message }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});

