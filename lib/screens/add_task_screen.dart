import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

class AddTaskScreen extends StatefulWidget {
  final Function(Task) onAddTask;

  AddTaskScreen({required this.onAddTask});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _taskNameController = TextEditingController();
  DateTime? _selectedDeadline;
  String _priority = 'Low';

  // Fungsi untuk memilih tanggal deadline
  Future<void> _pickDeadline() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDeadline = pickedDate;
        _updatePriority(); // Perbarui prioritas berdasarkan deadline
      });
    }
  }

  // Fungsi untuk mengupdate prioritas berdasarkan kedekatan deadline
  void _updatePriority() {
    if (_selectedDeadline != null) {
      final now = DateTime.now();
      final difference = _selectedDeadline!.difference(now).inDays;

      if (difference <= 3) {
        _priority = 'High';
      } else if (difference <= 7) {
        _priority = 'Medium';
      } else {
        _priority = 'Low';
      }
    }
  }

  // Fungsi untuk submit tugas baru
  void _submitTask() {
    final taskName = _taskNameController.text;
    if (taskName.isEmpty || _selectedDeadline == null) return;

    final newTask =
        Task(name: taskName, priority: _priority, deadline: _selectedDeadline!);
    widget.onAddTask(newTask);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _taskNameController,
              decoration: InputDecoration(labelText: 'Task Name'),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text(_selectedDeadline == null
                  ? 'Pick a Deadline'
                  : 'Deadline: ${DateFormat('yMMMd').format(_selectedDeadline!)}'),
              trailing: Icon(Icons.calendar_today),
              onTap: _pickDeadline,
            ),
            SizedBox(height: 10),
            Text('Priority: $_priority'), // Menampilkan prioritas otomatis
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitTask,
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
