import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scholar_track/providers/auth_provider.dart';
import 'package:scholar_track/screens/main_screen.dart';
import 'package:scholar_track/screens/welcome_screen.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthState(),
      child: const ScholarTrackApp(),
    ),
  );
}

class ScholarTrackApp extends StatelessWidget {
  const ScholarTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ScholarTrack',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      home: Consumer<AuthState>(
        builder: (context, auth, child) =>
            auth.isAuthenticated ? const MainScreen() : const WelcomeScreen(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
