import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:poke_app/models/Pokemon.dart';
import 'package:http/http.dart' as http;

class PokemonSearchScreen extends StatefulWidget {
  const PokemonSearchScreen({super.key});
  @override
  State<PokemonSearchScreen> createState() => _PokemonSearchScreenState();
}

class _PokemonSearchScreenState extends State<PokemonSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  // Objeto com o Pokemon pesquisado
  Pokemon? _pokemon;
  // Indica que a tela estará carregando os dados
  bool _loading = false;
  // Armazena a mensagem de erro caso aconteça algum
  String? _error;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PokeApp")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Campos dos formularios
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Digite o número do Pokémon",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              // Botao para realizar a busca
              ElevatedButton(
                onPressed: _searchPokemon,
                child: const Text("Buscar"),
              ),
              const SizedBox(height: 20),
              // Animacao de carregando quando estiver pesquisando
              if (_loading) const CircularProgressIndicator(),
              // Se tiver erro exibe a mensagem
              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.red)),
              // Se recuperar o pokemon irá chamar o método para exibi-lo
              if (_pokemon != null) _buildPokemonCard(_pokemon!),
            ],
          ),
        ),
      ),
    );
  }

  //Funcao que irá realizar a busca
  Future<void> _searchPokemon() async {
    // Valida se contém um ID valido
    final id = int.tryParse(_controller.text);
    if (id == null) {
      setState(() => _error = "Digite um número válido!");
      return;
    }
    // Altera o estado
    setState(() {
      _loading = true;
      _error = null;
      _pokemon = null;
    });

    try {
      final response = await http.get(
        Uri.parse("https://pokeapi.co/api/v2/pokemon/$id"),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() => _pokemon = Pokemon.fromJson(data));
      } else {
        setState(() => _error = "Pokémon não encontrado!");
      }
    } catch (e) {
      setState(() => _error = "Erro de conexão!");
    } finally {
      setState(() => _loading = false);
    }
  }

  Widget _buildPokemonCard(Pokemon pokemon) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Exibir os dados do Pokemon Pesquisado
            if (pokemon.mainSprite != null)
              Image.network(pokemon.mainSprite!, height: 300),
            Text(
              pokemon.name.toUpperCase(),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: pokemon.types
                  .map(
                    (type) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Chip(label: Text(type)),
                    ),
                  )
                  .toList(),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // duas imagens por linha
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: pokemon.sprites.allImages.length,
              itemBuilder: (context, index) {
                final url = pokemon.sprites.allImages[index];
                return Image.network(url, fit: BoxFit.contain);
              },
            ),
          ],
        ),
      ),
    );
  }
}
