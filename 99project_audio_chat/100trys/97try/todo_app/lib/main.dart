import 'package:flutter/material.dart';

void main() {
  runApp(TodoApp());
}

class Todo {
  String title;
  bool isCompleted;

  Todo({
    required this.title,
    this.isCompleted = false,
  });
}

class TodoApp extends StatefulWidget {
  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  List<Todo> todos = [];
  TextEditingController _todoTextController = TextEditingController();

    void addTodo() {
      String todoText = _todoTextController.text.trim();
      if (todoText.isNotEmpty) {
        setState(() {
          todos.add(Todo(title: todoText));
          _todoTextController.clear();
        });
      }
    }

    void deleteTodo(int index) {
      setState(() {
        todos.removeAt(index);
      });
    }

  void markComplete(int index) {
    setState(() {
      todos[index].isCompleted = !todos[index].isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Todo App'),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _todoTextController,
                      decoration: InputDecoration(
                        hintText: 'Enter todo',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: addTodo,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (BuildContext context, int index) {
                  final todo = todos[index];
                  return ListTile(
                    title: Text(todo.title),
                    trailing: Checkbox(
                      value: todo.isCompleted,
                      onChanged: (_) => markComplete(index),
                    ),
                    onLongPress: () => deleteTodo(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
