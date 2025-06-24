// main.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'inactivity_wrapper.dart';

/// ---------- SERVICIO DE LIMPIEZA ----------
final _secureStorage = FlutterSecureStorage();

Future<void> _wipeSensitiveData() async {
  await _secureStorage.deleteAll();
  debugPrint('✅ Datos sensibles eliminados');
}

/// Maneja cualquier RemoteMessage (primer/segundo plano)
Future<void> _handleSensitiveWipe(RemoteMessage message) async {
  // El payload de datos debe incluir: { "action": "wipe_data" }
  if (message.data['action'] == 'wipe_data') {
    await _wipeSensitiveData();
    // Opcional: cerrar sesión o mostrar banner.
    await FirebaseAuth.instance.signOut();
  }
}

/// ---------- HANDLER para SEGUNDO PLANO ----------
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await _handleSensitiveWipe(message);
}

/// ---------- MAIN ----------
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Registra el handler de segundo plano ANTES de runApp
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final user = FirebaseAuth.instance.currentUser;
  runApp(MyApp(startUser: user));
}

/// ---------- APP ----------
class MyApp extends StatefulWidget {
  final User? startUser;
  const MyApp({Key? key, required this.startUser}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _initialiseFCM();
  }

  Future<void> _initialiseFCM() async {
    await _fcm.requestPermission();

    // Obtiene el token FCM
    final token = await _fcm.getToken();
    debugPrint('📲 Token FCM del dispositivo: $token');

    // Escucha notificaciones en primer plano
    FirebaseMessaging.onMessage.listen(_handleSensitiveWipe);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (_) => LoginScreen(),
        '/home': (_) => HomeScreen(user: FirebaseAuth.instance.currentUser!),
      },
      home: widget.startUser == null
          ? LoginScreen()
          : InactivityWrapper(
              timeout: const Duration(seconds: 30), // ← para pruebas
              child: HomeScreen(user: widget.startUser!),
            ),
    );
  }
}
