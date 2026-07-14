import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/pokemon_viewmodel.dart';

class PokemonView extends StatelessWidget {
  const PokemonView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PokemonViewModel>();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Top 10 Pokémon',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: _buildBody(viewModel),
    );
  }

  Widget _buildBody(PokemonViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.black));
    }

    if (viewModel.errorMessage != null) {
      return Center(
        child: Text(viewModel.errorMessage!, style: const TextStyle(color: Colors.red)),
      );
    }

    if (viewModel.pokemonList.isEmpty) {
      return const Center(child: Text("No se encontraron Pokémon."));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: viewModel.pokemonList.length,
      itemBuilder: (context, index) {
        final pkm = viewModel.pokemonList[index];
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('#${pkm.id}', style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
              Expanded(
                child: Image.network(
                  pkm.imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  pkm.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: pkm.types.map((t) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(t, style: TextStyle(color: Colors.blue.shade800, fontSize: 12)),
                )).toList(),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}