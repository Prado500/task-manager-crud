import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_client/viewmodels/task_view_model.dart';
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
        // TODO: Inject TaskViewModel here later on
         ChangeNotifierProvider(create: (_) => TaskViewModel()),
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