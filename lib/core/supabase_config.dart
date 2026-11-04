// ---------------------------------------------------------------------------
// SUPABASE CONFIGURATION — RehabSense
// Single source of truth for Supabase URL and keys using --dart-define
// ---------------------------------------------------------------------------
import 'package:supabase_flutter/supabase_flutter.dart';

abstract final class SupabaseConfig {
  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://mluhkiidlqtqfauzxtcz.supabase.co',
  );

  static const String anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1sdWhraWlkbHF0cWZhdXp4dGN6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTM0NTk0MzAsImV4cCI6MjEwOTAzNTQzMH0.mcnYE3_cf5jZLazXMQBMvy7IXLBTLf9NKVSzyMBC4x0',
  );

  static SupabaseClient get client => Supabase.instance.client;
}
