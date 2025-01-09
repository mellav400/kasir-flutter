import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const String supabaseUrl = 'https://fskjujschwinwwfptgoh.supabase.co';
  static const String supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZza2p1anNjaHdpbnd3ZnB0Z29oIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzYyOTM3MzIsImV4cCI6MjA1MTg2OTczMn0.YgPBDyHWuUD1aAj3b17KF6-KHxfHsMmfA5IItqsBZoY';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
  }
}
