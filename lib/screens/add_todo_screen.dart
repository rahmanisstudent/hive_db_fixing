import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_db/models/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddTodoScreen extends StatefulWidget {
  final int? index;
  final Todo? todo;

  const AddTodoScreen({super.key, this.index, this.todo});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final titleController = TextEditingController();
  final subtitleController = TextEditingController();
  final String _draftTitle = "draft_title";
  final String _draftSubtitle = "draft_subtitle";

  bool get _isEditMode => widget.index != null && widget.todo != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      // mode edit: isi dari data todo yang ada, jangan load draft
      titleController.text = widget.todo!.title;
      subtitleController.text = widget.todo!.subtitle;
    } else {
      _loadDraft();
    }
  }

  Future<void> _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      titleController.text = prefs.getString(_draftTitle) ?? "";
      subtitleController.text = prefs.getString(_draftSubtitle) ?? "";
    });
  }

  Future<void> _saveDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_draftTitle, titleController.text);
    await prefs.setString(_draftSubtitle, subtitleController.text);
  }

  Future<void> _clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_draftTitle);
    await prefs.remove(_draftSubtitle);
  }

  @override
  void dispose() {
    titleController.dispose();
    subtitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditMode ? 'Edit Todo' : 'Add Todo',
          style: const TextStyle(fontWeight: FontWeight.bold),
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
              onChanged: (value) {
                if (!_isEditMode) _saveDraft();
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: subtitleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Subtitle',
              ),
              onChanged: (value) => _saveDraft(),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final box = Hive.box<Todo>('todos');
                final newTodo = Todo(
                  title: titleController.text,
                  subtitle: subtitleController.text,
                );
                if (_isEditMode) {
                  box.putAt(widget.index!, newTodo);
                } else {
                  box.add(newTodo);
                  await _clearDraft();
                }
                if (context.mounted) Navigator.pop(context);
              },
              child: Text(_isEditMode ? 'Save' : 'Add'),
            ),
          ],
        ),
      ),
    );
  }
}
