import 'package:flutter/material.dart';
import 'views/home_view.dart';

void main() {
  runApp(const CajaHerramientasApp());
}

class CajaHerramientasApp extends StatelessWidget {
  const CajaHerramientasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caja de Herramientas',
      theme: ThemeData(primarySwatch: Colors.teal),
      debugShowCheckedModeBanner: false,
      home: const HomeView(),
    );
  }
}
