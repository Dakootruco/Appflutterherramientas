import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../widgets/menu_drawer.dart';

class UniversidadesView extends StatefulWidget {
  const UniversidadesView({super.key});

  @override
  State<UniversidadesView> createState() => _UniversidadesViewState();
}

class _UniversidadesViewState extends State<UniversidadesView> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _universidades = [];
  bool _cargando = false;

  Future<void> obtenerUniversidades(String pais) async {
    setState(() {
      _cargando = true;
      _universidades.clear();
    });

    final url = Uri.parse(
        'http://universities.hipolabs.com/search?country=${Uri.encodeComponent(pais)}');
    final respuesta = await http.get(url);

    if (respuesta.statusCode == 200) {
      final datos = json.decode(respuesta.body);
      setState(() {
        _universidades = datos;
        _cargando = false;
      });
    } else {
      setState(() {
        _cargando = false;
      });
    }
  }

  void _abrirWeb(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuDrawer(),
      appBar: AppBar(title: const Text('Universidades por País')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Escribe el nombre de un país (en inglés):',
              style: TextStyle(fontSize: 16),
            ),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Ej: Dominican Republic'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () =>
                  obtenerUniversidades(_controller.text.trim()),
              child: const Text('Buscar Universidades'),
            ),
            const SizedBox(height: 20),
            _cargando
                ? const CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _universidades.length,
                      itemBuilder: (context, index) {
                        final uni = _universidades[index];
                        return Card(
                          child: ListTile(
                            title: Text(uni['name']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Dominio: ${uni['domains'][0]}'),
                                TextButton(
                                  onPressed: () => _abrirWeb(uni['web_pages'][0]),
                                  child: const Text('Visitar página web'),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
