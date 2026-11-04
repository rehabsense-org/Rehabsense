// Supabase Edge Function: send-feedback-notification
// Sends in-app notifications and email alerts when doctor reviews a session or pain alert triggers.

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

    const { type, recipientId, title, body, metadata } = await req.json();

    if (!recipientId || !title || !body) {
      return new Response(
        JSON.stringify({ error: "Missing required notification fields" }),
        { status: 400, headers: corsHeaders }
      );
    }

    // Insert in-app notification record
    const { data: notif, error: notifError } = await supabaseAdmin
      .from("notifications")
      .insert({
        id: crypto.randomUUID(),
        user_id: recipientId,
        type: type ?? "doctor_feedback",
        title,
        body,
        read: false,
        created_at: new Date().toISOString(),
      })
      .select()
      .single();

    if (notifError) {
      return new Response(
        JSON.stringify({ error: notifError.message }),
        { status: 500, headers: corsHeaders }
      );
    }

    return new Response(
      JSON.stringify({ success: true, notificationId: notif.id }),
      { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } catch (err) {
    return new Response(
      JSON.stringify({ error: err.message }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});

