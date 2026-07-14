import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_client/viewmodels/pokemon_viewmodel.dart';
import 'viewmodels/task_view_model.dart';
import 'core/theme.dart';
import 'views/home_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  runApp(const SupervisaTaskApp());
}

class SupervisaTaskApp extends StatelessWidget {
  const SupervisaTaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TaskViewModel()..fetchTasks(),
        ),
        ChangeNotifierProvider(
          create: (_) => PokemonViewModel()..fetchPokemon(), // Inyección temprana
        ),
      ],
      child: MaterialApp(
        title: 'Supervisa Task Manager',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomeView(),
      ),
    );
  }
}