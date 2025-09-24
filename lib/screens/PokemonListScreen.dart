import 'package:flutter/material.dart';

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});
  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lista de Pokémons")),
      body: const Center(child: Text("Aqui vai a lista de Pokémons")),
    );
  }
}
