import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets/menu_drawer.dart';

class EdadView extends StatefulWidget {
  const EdadView({super.key});

  @override
  State<EdadView> createState() => _EdadViewState();
}

class _EdadViewState extends State<EdadView> {
  final TextEditingController _controller = TextEditingController();
  int? _edad;
  String? _categoria;
  String? _imagen;
  bool _cargando = false;

  Future<void> obtenerEdad(String nombre) async {
    setState(() {
      _cargando = true;
      _edad = null;
      _categoria = null;
    });

    final url = Uri.parse('https://api.agify.io/?name=$nombre');
    final respuesta = await http.get(url);

    if (respuesta.statusCode == 200) {
      final datos = json.decode(respuesta.body);
      final edad = datos['age'];

      String categoria;
      String imagen;

      if (edad < 18) {
        categoria = 'Joven';
        imagen = 'assets/joven.png';
      } else if (edad <= 60) {
        categoria = 'Adulto';
        imagen = 'assets/adulto.png';
      } else {
        categoria = 'Anciano';
        imagen = 'assets/anciano.png';
      }

      setState(() {
        _edad = edad;
        _categoria = categoria;
        _imagen = imagen;
        _cargando = false;
      });
    } else {
      setState(() {
        _categoria = 'Error al obtener edad';
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuDrawer(),
      appBar: AppBar(title: const Text('Estimación de Edad')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Escribe un nombre para estimar la edad:',
                style: TextStyle(fontSize: 16)),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => obtenerEdad(_controller.text.trim()),
              child: const Text('Estimar Edad'),
            ),
            const SizedBox(height: 20),
            if (_cargando)
              const CircularProgressIndicator()
            else if (_edad != null)
              Column(
                children: [
                  Text(
                    'Edad estimada: $_edad años',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Categoría: $_categoria',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  if (_imagen != null)
                    Image.asset(_imagen!, height: 150),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
