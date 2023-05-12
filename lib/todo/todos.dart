
import 'package:flutter/cupertino.dart';
import 'package:messanger/todo/todo.dart';

class TodosProvider extends ChangeNotifier {
  final List<Todo> _todos = [
    Todo(
      createdTime: DateTime.now(),
      title: 'Buy Groceries',
      description: '''- Eggs
- Milk
- Bread
- Water''', id: '',
    ),
    Todo(
      createdTime: DateTime.now(),
      title: 'Daily Study Plan',
      description: '''- Wake at 4 o`Clock
- Do warm execise''', id: '',
    ),
    Todo(
      createdTime: DateTime.now(),
      title: 'Walk the Dog 🐕', id: '',
    ),
    Todo(
      createdTime: DateTime.now(),
      title: 'Plan for Self Learning Course', id: '',
    ),
  ];

  List<Todo> get todos => _todos.where((todo) => todo.isDone == false).toList();

  List<Todo> get todosCompleted =>
      _todos.where((todo) => todo.isDone == true).toList();

  void addTodo(Todo todo) {
    _todos.add(todo);

    notifyListeners();
  }

  void removeTodo(Todo todo) {
    _todos.remove(todo);

    notifyListeners();
  }

  bool toggleTodoStatus(Todo todo) {
    todo.isDone = !todo.isDone;
    notifyListeners();

    return todo.isDone;
  }

  void updateTodo(Todo todo, String title, String description) {
    todo.title = title;
    todo.description = description;

    notifyListeners();
  }
}