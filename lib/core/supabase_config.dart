// ---------------------------------------------------------------------------
// SUPABASE CONFIGURATION — RehabSense
// ---------------------------------------------------------------------------
import 'package:supabase_flutter/supabase_flutter.dart';

abstract final class SupabaseConfig {
  static const String url = 'https://mluhkiidlqtqfauzxtcz.supabase.co';
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1sdWhraWlkbHF0cWZhdXp4dGN6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTM0NTk0MzAsImV4cCI6MjEwOTAzNTQzMH0.mcnYE3_cf5jZLazXMQBMvy7IXLBTLf9NKVSzyMBC4x0';

  static SupabaseClient get client => Supabase.instance.client;
}
