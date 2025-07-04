 import 'package:flutter/material.dart';
import '../widgets/menu_drawer.dart';

class AcercaView extends StatelessWidget {
  const AcercaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuDrawer(),
      appBar: AppBar(title: const Text('Acerca de')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 70,
              backgroundImage: AssetImage('assets/fotodakoo.jpeg'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Dacarlos Lora Torres',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Matrícula: 2023-1027',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              'Correo: da@email.com',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              'Teléfono: +1 809 505 6782',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              'GitHub: https://github.com/dakootruco',
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}

