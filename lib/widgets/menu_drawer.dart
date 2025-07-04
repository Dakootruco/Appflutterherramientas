import 'package:flutter/material.dart';
import '../views/home_view.dart';
import '../views/genero_view.dart';
import '../views/edad_view.dart';
import '../views/universidades_view.dart';
import '../views/clima_view.dart';
import '../views/pokemon_view.dart';
import '../views/noticias_view.dart';
import '../views/acerca_view.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.teal),
            child: Text('Caja de Herramientas', style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
          _item(context, 'Inicio', const HomeView()),
          _item(context, 'Predicción de Género', const GeneroView()),
          _item(context, 'Edad Estimada', const EdadView()),
          _item(context, 'Universidades', const UniversidadesView()),
          _item(context, 'Clima en RD', const ClimaView()),
          _item(context, 'Pokémon', const PokemonView()),
          _item(context, 'Noticias', const NoticiasRDView()),
          _item(context, 'Acerca de', const AcercaView()),
        ],
      ),
    );
  }

  ListTile _item(BuildContext context, String title, Widget page) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
      },
    );
  }
}
