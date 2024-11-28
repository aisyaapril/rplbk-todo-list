import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;
  final Function(Task) onEditTask;

  EditTaskScreen({required this.task, required this.onEditTask});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _taskNameController;
  late DateTime _selectedDeadline;
  late String _priority;

  @override
  void initState() {
    super.initState();
    _taskNameController = TextEditingController(text: widget.task.name);
    _selectedDeadline = widget.task.deadline;
    _priority = widget.task.priority;
  }

  // Fungsi untuk memilih tanggal deadline
  Future<void> _pickDeadline() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline,
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
    final now = DateTime.now();
    final difference = _selectedDeadline.difference(now).inDays;

    if (difference <= 3) {
      _priority = 'High';
    } else if (difference <= 7) {
      _priority = 'Medium';
    } else {
      _priority = 'Low';
    }
  }

  // Fungsi untuk menyimpan perubahan
  void _saveChanges() {
    final updatedTask = Task(
      name: _taskNameController.text,
      priority: _priority,
      deadline: _selectedDeadline,
    );
    widget.onEditTask(updatedTask);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
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
              title: Text(
                // ignore: unnecessary_null_comparison
                _selectedDeadline == null
                    ? 'Pick a Deadline'
                    : 'Deadline: ${DateFormat('yMMMd').format(_selectedDeadline)}',
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: _pickDeadline,
            ),
            SizedBox(height: 10),
            Text('Priority: $_priority'), // Menampilkan prioritas otomatis
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
