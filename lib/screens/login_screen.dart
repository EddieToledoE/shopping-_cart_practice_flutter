import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/external_auth_service.dart';
import '../models/usuario.dart';
import 'home_screen.dart';
import 'external_login_home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ExternalAuthService _externalAuthService = ExternalAuthService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Iniciar Sesión")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Login externo con API propia
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Usuario'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Contraseña'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final result = await _externalAuthService.login(
                  _emailController.text,
                  _passwordController.text,
                );

                if (result.success) {
                  final usuario = Usuario(
                    nombre: _emailController.text.split('@')[0],
                    email: _emailController.text,
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomeScreenExternal(usuario: usuario),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(result.message)));
                }
              },
              child: Text('Iniciar sesión'),
            ),

            SizedBox(height: 30),

            // Separador visual
            Row(
              children: [
                Expanded(child: Divider(thickness: 1)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text('O'),
                ),
                Expanded(child: Divider(thickness: 1)),
              ],
            ),

            SizedBox(height: 20),

            // Login con Google
            ElevatedButton.icon(
              icon: Icon(Icons.login),
              label: Text("Iniciar sesión con Google"),
              onPressed: () async {
                final user = await _authService.signInWithGoogle();
                if (user != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
