import 'package:bottles_up_user/core/services/payment_service.dart';
import 'package:bottles_up_user/features/auth/services/deep_link_listener.dart';
import 'package:bottles_up_user/routing/app_router.dart';
import 'package:bottles_up_user/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://hwmynlghrmtoufyrcihp.supabase.co',
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.implicit,
    ),
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh3bXlubGdocm10b3VmeXJjaWhwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE2Mzc3ODAsImV4cCI6MjA2NzIxMzc4MH0.1VpevdV-ReX7w3QCoM0xaPjSywusUtrbrtFk9AsWNAw',
  );

  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    // Initialize deep link listener
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await DeepLinkListener().initialize(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}
