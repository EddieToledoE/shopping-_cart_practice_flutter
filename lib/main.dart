import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:no_screenshot/no_screenshot.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔐 Inicializar Firebase
  await Firebase.initializeApp();

  // 🔒 Prevenir capturas desde el inicio
  final _noScreenshot = NoScreenshot.instance;
  await _noScreenshot.screenshotOff(); // Bloquea capturas

  final user = FirebaseAuth.instance.currentUser;

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: user == null ? LoginScreen() : HomeScreen(user: user),
    ),
  );
}
