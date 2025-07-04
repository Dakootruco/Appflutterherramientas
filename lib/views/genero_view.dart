 import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets/menu_drawer.dart';

class GeneroView extends StatefulWidget {
  const GeneroView({super.key});

  @override
  State<GeneroView> createState() => _GeneroViewState();
}

class _GeneroViewState extends State<GeneroView> {
  final TextEditingController _controller = TextEditingController();
  String? _genero;
  Color? _colorFondo;
  bool _cargando = false;

  Future<void> obtenerGenero(String nombre) async {
    setState(() {
      _cargando = true;
      _genero = null;
    });

    final url = Uri.parse('https://api.genderize.io/?name=$nombre');
    final respuesta = await http.get(url);

    if (respuesta.statusCode == 200) {
      final datos = json.decode(respuesta.body);
      final genero = datos['gender'];

      setState(() {
        _genero = genero;
        _colorFondo = genero == 'male' ? Colors.blue[100] : Colors.pink[100];
        _cargando = false;
      });
    } else {
      setState(() {
        _genero = 'Error al obtener datos';
        _colorFondo = Colors.grey[200];
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuDrawer(),
      appBar: AppBar(title: const Text('Predicción de Género')),
      body: Container(
        color: _colorFondo ?? Colors.white,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Escribe un nombre para predecir su género:',
              style: TextStyle(fontSize: 16),
            ),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => obtenerGenero(_controller.text.trim()),
              child: const Text('Predecir Género'),
            ),
            const SizedBox(height: 20),
            if (_cargando)
              const CircularProgressIndicator()
            else if (_genero != null)
              Text(
                _genero == 'male'
                    ? 'Es un nombre masculino 👨'
                    : _genero == 'female'
                        ? 'Es un nombre femenino 👩'
                        : _genero!,
                style: const TextStyle(fontSize: 20),
              ),
          ],
        ),
      ),
    );
  }
}

