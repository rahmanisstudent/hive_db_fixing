import 'package:flutter/material.dart';
import 'package:hive_db/models/todo.dart';
import 'package:hive_db/screens/home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  await Hive.openBox<Todo>('todos');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  // static const String title = 'Todo List App';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}
