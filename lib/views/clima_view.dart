import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets/menu_drawer.dart';

class ClimaView extends StatefulWidget {
  const ClimaView({super.key});

  @override
  State<ClimaView> createState() => _ClimaViewState();
}

class _ClimaViewState extends State<ClimaView> {
  bool _cargando = false;
  Map<String, dynamic>? _clima;

  Future<void> obtenerClima() async {
    setState(() {
      _cargando = true;
      _clima = null;
    });

    final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=18.7357&longitude=-70.1627&current_weather=true');
    final respuesta = await http.get(url);

    if (respuesta.statusCode == 200) {
      final datos = json.decode(respuesta.body);
      setState(() {
        _clima = datos['current_weather'];
        _cargando = false;
      });
    } else {
      setState(() {
        _cargando = false;
      });
    }
  }

  String _descripcionClima(int code) {
    
    switch (code) {
      case 0:
        return 'Despejado';
      case 1:
      case 2:
      case 3:
        return 'Parcialmente nublado';
      case 45:
      case 48:
        return 'Neblina';
      case 51:
      case 53:
      case 55:
        return 'Llovizna ligera';
      case 61:
      case 63:
      case 65:
        return 'Lluvia';
      case 71:
      case 73:
      case 75:
        return 'Nieve';
      case 95:
        return 'Tormenta eléctrica';
      default:
        return 'Clima variable';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuDrawer(),
      appBar: AppBar(title: const Text('Clima en República Dominicana')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: obtenerClima,
              child: const Text('Obtener clima actual'),
            ),
            const SizedBox(height: 20),
            if (_cargando) const CircularProgressIndicator(),
            if (_clima != null)
              Column(
                children: [
                  Text(
                    'Temperatura: ${_clima!['temperature']}°C',
                    style: const TextStyle(fontSize: 22),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Velocidad del viento: ${_clima!['windspeed']} km/h',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Descripción: ${_descripcionClima(_clima!['weathercode'])}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
