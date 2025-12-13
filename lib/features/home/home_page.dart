// lib/features/home/home_page.dart
import 'package:flutter/material.dart';
import '../../core/services/todo_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TodoService _todoService = TodoService();
  final TextEditingController _controller = TextEditingController();

  void _addTodo() {
    if (_controller.text.trim().isEmpty) return;
    _todoService.addTodo(_controller.text.trim());
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Todos')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: 'New todo'),
                  ),
                ),
                IconButton(icon: const Icon(Icons.add), onPressed: _addTodo),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _todoService.getTodos(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const Center(child: Text('No todos yet'));
                }

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;

                    return ListTile(
                      title: Text(
                        data['title'],
                        style: TextStyle(
                          decoration: data['completed']
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      leading: Checkbox(
                        value: data['completed'],
                        onChanged: (value) {
                          _todoService.toggleTodo(doc.id, value!);
                        },
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _todoService.deleteTodo(doc.id);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
