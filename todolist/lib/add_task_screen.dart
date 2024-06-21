import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _taskNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  TimeOfDay? _selectedTime;
  DateTime? _selectedDate;
  bool _isSubmitting = false;

  void _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _addTask(Task task) async {
    setState(() {
      _isSubmitting = true;
    });
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/tasks'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'taskName': task.taskName,
          'description': task.description,
          'time': task.time,
          'date': task.date,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        task.id = responseBody['id']; // Update ID task dengan ID dari server
        Navigator.pop(context, task); // Pass task ke layar sebelumnya
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task added successfully')),
        );
      } else {
        throw Exception('Failed to add task to database');
      }
    } catch (e) {
      print('Error adding task: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add task, please try again')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _taskNameController,
                decoration: InputDecoration(labelText: 'Task Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter task name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              ListTile(
                title: Text(_selectedTime == null
                    ? 'Pick Time'
                    : 'Time: ${_selectedTime!.format(context)}'),
                trailing: Icon(Icons.access_time),
                onTap: _pickTime,
              ),
              ListTile(
                title: Text(_selectedDate == null
                    ? 'Pick Date'
                    : 'Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}'),
                trailing: Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              SizedBox(height: 20),
              _isSubmitting
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (_selectedTime == null || _selectedDate == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Please pick time and date')),
                            );
                            return;
                          }
                          final newTask = Task(
                            id: 0, // placeholder, will be set by server
                            taskName: _taskNameController.text,
                            description: _descriptionController.text,
                            time: _selectedTime!.format(context),
                            date: _selectedDate!
                                .toLocal()
                                .toString()
                                .split(' ')[0],
                          );

                          await _addTask(newTask);
                        }
                      },
                      child: Text('Add Task'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
