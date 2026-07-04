import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/task_view_model.dart';
import 'core/theme.dart';
import 'views/home_view.dart';

void main() {
  runApp(const SupervisaTaskApp());
}

class SupervisaTaskApp extends StatelessWidget {
  const SupervisaTaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          // La sintaxis '..' (cascade operator) permite instanciar y llamar al método inmediatamente
          create: (_) => TaskViewModel()..fetchTasks(),
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