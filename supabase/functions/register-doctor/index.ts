// Supabase Edge Function: register-doctor
// Creates doctor user, profile, and initial application record.

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

    const { email, password, fullName, licenseNumber, degree } = await req.json();

    if (!email || !password || !fullName || !licenseNumber || !degree) {
      return new Response(
        JSON.stringify({ error: "Missing required registration fields" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // 1. Create auth user with service role
    const { data: authUser, error: authError } = await supabaseAdmin.auth.admin.createUser({
      email,
      password,
      email_confirm: false, // Requires email verification via OTP
      user_metadata: { name: fullName },
    });

    if (authError || !authUser.user) {
      return new Response(
        JSON.stringify({ error: authError?.message || "Failed to create doctor auth user" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const doctorId = authUser.user.id;

    // 2. Set profile role = 'doctor' and account_status = 'pending_verification'
    const { error: profileError } = await supabaseAdmin
      .from("profiles")
      .update({
        name: fullName,
        role: "doctor",
        account_status: "pending_verification",
      })
      .eq("id", doctorId);

    if (profileError) {
      return new Response(
        JSON.stringify({ error: profileError.message }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // 3. Initialize doctor_profile record
    await supabaseAdmin.from("doctor_profiles").insert({
      id: doctorId,
      title: "Physiotherapist",
      is_verified: false,
      is_listed: false,
    });

    // 4. Initialize application record (attempt 1)
    const { data: appData, error: appError } = await supabaseAdmin
      .from("doctor_applications")
      .insert({
        doctor_id: doctorId,
        attempt_number: 1,
        license_number: licenseNumber,
        degree: degree,
        status: "draft",
      })
      .select()
      .single();

    if (appError) {
      return new Response(
        JSON.stringify({ error: appError.message }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    return new Response(
      JSON.stringify({
        success: true,
        doctorId,
        applicationId: appData.id,
        message: "Doctor account registered. Verification OTP sent.",
      }),
      { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } catch (err) {
    return new Response(
      JSON.stringify({ error: err.message }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});

