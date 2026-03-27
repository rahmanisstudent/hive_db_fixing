import 'package:flutter/material.dart';
import 'package:hive_db/models/todo.dart';
import 'package:hive_db/screens/add_todo_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todo List App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ValueListenableBuilder(
          valueListenable: Hive.box<Todo>('todos').listenable(),
          builder: (context, box, child) {
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                final todo = box.getAt(index);
                if (todo == null) return const SizedBox.shrink();
                return Card(
                  color: Colors.white,
                  shadowColor: Colors.black,
                  elevation: 4,
                  child: ListTile(
                    title: Text(todo.title),
                    subtitle: Text(todo.subtitle),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTodoScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    Hive.box('todos').close();
    super.dispose();
  }
}
