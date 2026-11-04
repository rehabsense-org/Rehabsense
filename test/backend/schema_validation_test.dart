import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Phase 1 Database & Backend Validation Tests', () {
    test('Migration SQL file exists and contains all required v2 tables and policies', () {
      final migrationFile = File('supabase/migrations/20261103000000_rehabsense_v2_core.sql');
      expect(migrationFile.existsSync(), isTrue, reason: 'Core migration SQL file must exist');

      final content = migrationFile.readAsStringSync();

      // Enums
      expect(content, contains('public.user_role as enum'));
      expect(content, contains('public.account_status as enum'));
      expect(content, contains('public.doctor_application_status as enum'));
      expect(content, contains('public.connection_status as enum'));
      expect(content, contains('public.assignment_status as enum'));

      // New Tables
      expect(content, contains('create table if not exists public.doctor_profiles'));
      expect(content, contains('create table if not exists public.doctor_applications'));
      expect(content, contains('create table if not exists public.doctor_documents'));
      expect(content, contains('create table if not exists public.patient_conditions'));
      expect(content, contains('create table if not exists public.doctor_requests'));
      expect(content, contains('create table if not exists public.doctor_patients'));
      expect(content, contains('create table if not exists public.assignments'));
      expect(content, contains('create table if not exists public.pain_logs'));
      expect(content, contains('create table if not exists public.exercise_feedback'));
      expect(content, contains('create table if not exists public.audit_log'));

      // Triggers & Functions
      expect(content, contains('create or replace function public.is_admin()'));
      expect(content, contains('create or replace function public.is_doctor()'));
      expect(content, contains('create or replace function public.handle_new_user()'));
      expect(content, contains('trg_audit_log_immutable'));

      // Strict Admin Health Privacy: Admin is blocked from patient clinical data
      expect(content, contains('not public.is_admin()'));
    });

    test('Seed SQL file exists and contains admin and exercise configs', () {
      final seedFile = File('supabase/seed.sql');
      expect(seedFile.existsSync(), isTrue, reason: 'Seed file must exist');

      final content = seedFile.readAsStringSync();
      expect(content, contains('admin@rehabsense.test'));
      expect(content, contains('sara.khan@clinic.test'));
      expect(content, contains('ex_mini_squat'));
      expect(content, contains('tracking_config'));
    });

    test('All 5 Edge Functions exist with TypeScript source', () {
      final functions = [
        'register-doctor',
        'admin-review-doctor',
        'admin-set-account-status',
        'get-document-url',
        'send-feedback-notification',
      ];

      for (final fn in functions) {
        final fnFile = File('supabase/functions/$fn/index.ts');
        expect(fnFile.existsSync(), isTrue, reason: 'Edge function $fn/index.ts must exist');
        final content = fnFile.readAsStringSync();
        expect(content, contains('serve('));
        expect(content, contains('createClient'));
      }
    });

    test('Supabase SETUP.md documentation exists', () {
      final setupFile = File('supabase/SETUP.md');
      expect(setupFile.existsSync(), isTrue, reason: 'SETUP.md must exist');
      final content = setupFile.readAsStringSync();
      expect(content, contains('supabase start'));
      expect(content, contains('doctor-documents'));
      expect(content, contains('--dart-define'));
    });
  });
}

