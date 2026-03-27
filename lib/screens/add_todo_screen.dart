import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_db/models/todo.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final titleController = TextEditingController();
  final subtitleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Todo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Title',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: subtitleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Subtitle',
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Box<Todo> box = Hive.box<Todo>('todos');
                box.add(Todo(
                    title: titleController.text,
                    subtitle: subtitleController.text));
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
