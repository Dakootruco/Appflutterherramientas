 
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import '../widgets/menu_drawer.dart';

class PokemonView extends StatefulWidget {
  const PokemonView({super.key});

  @override
  State<PokemonView> createState() => _PokemonViewState();
}

class _PokemonViewState extends State<PokemonView> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? _pokemonData;
  bool _cargando = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> obtenerPokemon(String nombre) async {
    setState(() {
      _cargando = true;
      _pokemonData = null;
    });

    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$nombre'.toLowerCase());
    final respuesta = await http.get(url);

    if (respuesta.statusCode == 200) {
      final datos = json.decode(respuesta.body);

  
      setState(() {
        _pokemonData = datos;
        _cargando = false;
      });
    } else {
      setState(() {
        _pokemonData = null;
        _cargando = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pokémon no encontrado')),
      );
    }
  }

  Future<void> reproducirSonido(int id) async {
    final url = 'https://pokemoncries.com/cries-old/$id.mp3';
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(url));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo reproducir el sonido')),
      );
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuDrawer(),
      appBar: AppBar(title: const Text('Consulta Pokémon')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Escribe el nombre de un Pokémon:', style: TextStyle(fontSize: 16)),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Ej: pikachu'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => obtenerPokemon(_controller.text.trim().toLowerCase()),
              child: const Text('Buscar Pokémon'),
            ),
            const SizedBox(height: 20),
            if (_cargando)
              const CircularProgressIndicator()
            else if (_pokemonData != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.network(
                        _pokemonData!['sprites']['front_default'] ?? '',
                        height: 150,
                      ),
                      const SizedBox(height: 10),
                      Text('Experiencia base: ${_pokemonData!['base_experience']}',
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 10),
                      const Text('Habilidades:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ...(_pokemonData!['abilities'] as List).map((hab) {
                        return Text(
                          hab['ability']['name'],
                          style: const TextStyle(fontSize: 16),
                        );
                      }).toList(),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => reproducirSonido(_pokemonData!['id']),
                        child: const Text('Reproducir Sonido'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
