import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../widgets/menu_drawer.dart';

class NoticiasRDView extends StatefulWidget {
  const NoticiasRDView({super.key});

  @override
  State<NoticiasRDView> createState() => _NoticiasRDViewState();
}

class _NoticiasRDViewState extends State<NoticiasRDView> {
  List<dynamic> _noticias = [];
  bool _cargando = false;
  final String apiKey = '7e70299155374ebeb5a5039804105da7'; 

  Future<void> obtenerNoticias() async {
    setState(() {
      _cargando = true;
      _noticias.clear();
    });

    final url = Uri.parse(
      'https://api.worldnewsapi.com/top-news?source-country=do&language=es&apiKey=$apiKey',
    );

    final respuesta = await http.get(url);

    if (respuesta.statusCode == 200) {
      final datos = json.decode(respuesta.body);
      if (datos['status'] == 'ok') {
        setState(() {
          _noticias = datos['news']; 
          _cargando = false;
        });
      } else {
        setState(() {
          _cargando = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error API: ${datos['message']}')),
        );
      }
    } else {
      setState(() {
        _cargando = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error HTTP: ${respuesta.statusCode}')),
      );
    }
  }

  void _abrirEnlace(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el enlace')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    obtenerNoticias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuDrawer(),
      appBar: AppBar(title: const Text('Noticias RD')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _noticias.length,
              itemBuilder: (context, index) {
                final noticia = _noticias[index];
                final title = noticia['title'] ?? 'Sin título';
                final description = noticia['description'] ?? '';
                final url = noticia['url'] ?? '';
                final imageUrl = noticia['image_url'] ?? '';

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (imageUrl.isNotEmpty)
                        Image.network(imageUrl, fit: BoxFit.cover),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(title,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(description),
                      ),
                      ButtonBar(
                        children: [
                          TextButton(
                            onPressed: () => _abrirEnlace(url),
                            child: const Text('Leer más'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
