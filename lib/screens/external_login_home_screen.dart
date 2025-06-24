import 'package:flutter/material.dart';
import '../models/usuario.dart';
import 'product_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'cart_screen.dart';

class HomeScreenExternal extends StatelessWidget {
  final Usuario usuario;
  final AuthService authService = AuthService();
  HomeScreenExternal({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hola ${usuario.nombre}'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CartScreen(),
                ), // Asegúrate de importar CartScreen
              );
            },
          ),
        ],
      ),
      body: ProductListScreen(),
    );
  }
}
