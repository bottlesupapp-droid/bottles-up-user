import 'package:flutter/material.dart';

/// What is wrong with the settings a build was given, in a sentence a tester can read out, or null when they are all there. A build made without them used to throw before anything was
/// drawn, which on a phone is a white screen with no hint of why.
String? missingSettingsProblem({required String supabaseUrl, required String supabaseAnonKey}) {
  final missing = [if (supabaseUrl.trim().isEmpty) 'SUPABASE_URL', if (supabaseAnonKey.trim().isEmpty) 'SUPABASE_ANON_KEY'];
  if (missing.isEmpty) return null;
  return 'This copy of the app was built without its settings (${missing.join(' and ')}).';
}

/// The only screen the app shows when it cannot start: it says so, in words, instead of leaving a blank page. [detail] is the technical reason, for whoever reads it back to a developer.
class StartupProblemApp extends StatelessWidget {
  const StartupProblemApp({super.key, required this.detail});

  final String detail;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                key: const Key('startup-problem'),
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 16),
                  const Text('BottlesUp could not start', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  const Text('Please install the latest version from TestFlight or the store. If this keeps happening, tell BottlesUp support and send a screenshot of this page.', textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  SelectableText(detail, key: const Key('startup-problem-detail'), textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
