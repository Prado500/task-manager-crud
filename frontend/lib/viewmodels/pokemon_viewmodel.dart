import 'package:flutter/material.dart';
import '../models/pokemon_model.dart';
import '../abstractions/supervisa_task_api_abstraction.dart';

class PokemonViewModel extends ChangeNotifier {
  final SupervisaApiAbstraction _api;

  PokemonViewModel({SupervisaApiAbstraction? api})
      : _api = api ?? SupervisaApiAbstraction();

  List<PokemonModel> _pokemonList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<PokemonModel> get pokemonList => _pokemonList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPokemon() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _pokemonList = await _api.getTopPokemon();
    } catch (e) {
      _errorMessage = "Error al conectar con el servidor para obtener Pokémon.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}