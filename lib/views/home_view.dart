 import 'package:flutter/material.dart';
import '../widgets/menu_drawer.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuDrawer(),
      appBar: AppBar(title: const Text('Inicio')),
      body: Center(
        child: Image.asset('assets/caja.png', height: 250),
      ),
    );
  }
}

