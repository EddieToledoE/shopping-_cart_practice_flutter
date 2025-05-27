import 'package:flutter/material.dart';
import '../models/usuario.dart';
import 'product_list_screen.dart';

class HomeScreenExternal extends StatelessWidget {
  final Usuario usuario;

  const HomeScreenExternal({required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hola ${usuario.nombre}')),
      body: ProductListScreen(),
    );
  }
}
