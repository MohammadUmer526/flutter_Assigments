import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class Task {
  String description;
  bool completed;

  Task({required this.description, this.completed = false});
}

class TaskListNotifier extends ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  void addTask(String description) {
    _tasks.add(Task(description: description));
    notifyListeners();
  }

  void removeTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }

  void toggleTaskCompletion(Task task) {
    task.completed = !task.completed;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskListNotifier(),
      child: MaterialApp(
        home: TaskListScreen(),
      ),
    );
  }
}

class TaskListScreen extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Enter task',
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    final description = _textEditingController.text;
                    if (description.isNotEmpty) {
                      Provider.of<TaskListNotifier>(context, listen: false)
                          .addTask(description);
                      _textEditingController.clear();
                    }
                  },
                  child: Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<TaskListNotifier>(
              builder: (context, taskList, child) {
                return ListView.builder(
                  itemCount: taskList.tasks.length,
                  itemBuilder: (context, index) {
                    final task = taskList.tasks[index];
                    return ListTile(
                      title: Text(task.description),
                      leading: Checkbox(
                        value: task.completed,
                        onChanged: (_) {
                          Provider.of<TaskListNotifier>(context, listen: false)
                              .toggleTaskCompletion(task);
                        },
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          Provider.of<TaskListNotifier>(context, listen: false)
                              .removeTask(task);
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
