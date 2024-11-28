import 'package:flutter/material.dart';
import '../controllers/todo_list.dart';
// ignore: unused_import
import '../models/task.dart';
import '../strategy/sort_by_priority.dart';
import '../controllers/observer.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ToDoListWithStrategy toDoList = ToDoListWithStrategy();

  get tasks => null;

  @override
  void initState() {
    super.initState();
    toDoList.addObserver(TaskObserver());
    toDoList.setSortingStrategy(SortByPriority());
    _sortTasksByPriority();
  }

  void _navigateToAddTaskScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(
          onAddTask: (newTask) {
            setState(() {
              toDoList.addTask(newTask);
            });
          },
        ),
      ),
    );
  }

  void _removeTask(String name) {
    setState(() {
      toDoList.removeTask(name);
    });
  }

  // Fungsi untuk mengurutkan tasks berdasarkan prioritas dari tinggi ke rendah
  void _sortTasksByPriority() {
    tasks.sort((a, b) {
      final priorityOrder = {
        'High': 1,
        'Medium': 2,
        'Low': 3
      }; // Urutan prioritas
      return priorityOrder[a.priority]!.compareTo(priorityOrder[b.priority]!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To-Do List"),
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              setState(() {
                _sortTasksByPriority(); // Urutkan ulang ketika ikon ditekan
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: toDoList.getSortedTasks().length,
        itemBuilder: (context, index) {
          final task = toDoList.getSortedTasks()[index];
          return ListTile(
            title: Text(task.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Priority: ${task.priority}"),
                Text("Deadline: ${DateFormat('yMMMd').format(task.deadline)}"),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditTaskScreen(
                    task: task,
                    onEditTask: (updatedTask) {
                      setState(() {
                        toDoList.editTask(
                            task.name, updatedTask.name, updatedTask.priority);
                      });
                    },
                  ),
                ),
              );
            },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _removeTask(task.name),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTaskScreen,
        child: Icon(Icons.add),
      ),
    );
  }
}
