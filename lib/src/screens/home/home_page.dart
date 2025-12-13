import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/todo.dart';
import '../../services/firestore_service.dart';
import '../../services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService _fs = FirestoreService();

  void _showTodoDialog({Todo? todo}) {
    final _titleCtrl = TextEditingController(text: todo?.title ?? '');
    final _descCtrl = TextEditingController(text: todo?.description ?? '');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 16, right: 16, top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
              const SizedBox(height: 8),
              TextField(controller: _descCtrl, decoration: const InputDecoration(labelText: 'Description')),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  final user = Provider.of<AuthService>(context, listen: false).currentUser;
                  if (user == null) return;
                  final now = FieldValue.serverTimestamp();
                  if (todo == null) {
                    await _fs.createTodo(user.uid, {
                      'title': _titleCtrl.text.trim(),
                      'description': _descCtrl.text.trim(),
                      'completed': false,
                      'createdAt': now,
                      'updatedAt': now,
                    });
                  } else {
                    await _fs.updateTodo(user.uid, todo.id, {
                      'title': _titleCtrl.text.trim(),
                      'description': _descCtrl.text.trim(),
                      'updatedAt': now,
                    });
                  }
                  if (mounted) Navigator.pop(ctx);
                },
                child: Text(todo == null ? 'Create' : 'Update'),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final user = auth.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('No user. Please login.')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTodoDialog(),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Todo>>(
        stream: _fs.todosStream(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final todos = snapshot.data ?? [];
          if (todos.isEmpty) {
            return const Center(child: Text('No todos yet. Tap + to add.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: todos.length,
            itemBuilder: (context, i) {
              final t = todos[i];
              return Card(
                child: ListTile(
                  leading: Checkbox(
                    value: t.completed,
                    onChanged: (v) async {
                      await _fs.updateTodo(user.uid, t.id, {
                        'completed': v,
                        'updatedAt': FieldValue.serverTimestamp(),
                      });
                    },
                  ),
                  title: Text(t.title, style: TextStyle(decoration: t.completed ? TextDecoration.lineThrough : null)),
                  subtitle: Text(t.description),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'edit') _showTodoDialog(todo: t);
                      if (value == 'delete') {
                        final c = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Delete todo?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                            ],
                          ),
                        );
                        if (c == true) await _fs.deleteTodo(user.uid, t.id);
                      }
                    },
                    itemBuilder: (ctx) => [
                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                      const PopupMenuItem(value: 'delete', child: Text('Delete')),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
