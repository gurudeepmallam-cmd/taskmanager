// lib/main.dart

import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'config/back4app_config.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Initialize Parse SDK (Back4App) ──────────────────────────
  await Parse().initialize(
    Back4AppConfig.applicationId,
    Back4AppConfig.parseServerUrl,
    clientKey: Back4AppConfig.clientKey,
    autoSendSessionId: true,  // keeps user logged in across app restarts
    debug: true,              // set to false before releasing to production
  );

  runApp(const TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager – Back4App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const SplashScreen(),
    );
  }
}
