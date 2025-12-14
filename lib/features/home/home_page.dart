// lib/features/home/home_page.dart
import 'package:flutter/material.dart';
import '../../core/services/todo_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TodoService todoService = TodoService();
    final TextEditingController controller = TextEditingController();

    void addTodo() {
      final text = controller.text.trim();
      if (text.isEmpty) return;
      todoService.addTodo(text);
      controller.clear();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Todos'), centerTitle: true),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: 'Add a new task...',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => addTodo(),
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.add), onPressed: addTodo),
                ],
              ),
            ),
          ),
        ),
      ),

      body: StreamBuilder(
        stream: todoService.getTodos(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text('No todos yet'));
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(16),
                  child: ListTile(
                    leading: Checkbox(
                      value: data['completed'],
                      onChanged: (value) {
                        todoService.toggleTodo(doc.id, value!);
                      },
                    ),
                    title: Text(
                      data['title'],
                      style: TextStyle(
                        decoration: data['completed']
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        todoService.deleteTodo(doc.id);
                      },
                    ),
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
