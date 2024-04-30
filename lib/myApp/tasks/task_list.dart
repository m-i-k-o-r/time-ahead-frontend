import 'package:first_flutter_app/myApp/tasks/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Task> tasks = [];

  void _deleteTask(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                tasks.removeAt(index);
              });
              Navigator.of(context).pop();
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
  }

  void _addTask(String title, String description, DateTime dueDate, TimeOfDay dueTime) {
    final dueDateTime = DateTime(dueDate.year, dueDate.month, dueDate.day, dueTime.hour, dueTime.minute);
    final newTask = Task(
      title: title,
      description: description,
      dueDateTime: dueDateTime,
      isCompleted: false,
    );
    setState(() {
      tasks.add(newTask);
      tasks.sort((a, b) => a.dueDateTime.compareTo(b.dueDateTime));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Tracker'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text(DateFormat('HH:mm dd.MM.yyyy').format(task.dueDateTime)),
            onTap: () => _showTaskDetailsDialog(task),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked, color: task.isCompleted ? Colors.deepPurple : Colors.deepPurple),
                  onPressed: () => _toggleTaskCompletion(index),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.deepPurple),
                  onPressed: () => _showEditTaskDialog(index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.deepPurple),
                  onPressed: () => _deleteTask(index),
                ),
              ],
            ),
            tileColor: task.isCompleted ? Colors.indigo[50] : null,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddTaskDialog(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showTaskDetailsDialog(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Task Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${task.title}'),
            Text('Due Date & Time: ${DateFormat('HH:mm dd.MM.yyyy').format(task.dueDateTime)}'),
            Text('Description: ${task.description}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(
        onAdd: _addTask,
      ),
    );
  }

  void _showEditTaskDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => EditTaskDialog(
        task: tasks[index],
        onUpdate: (title, description, dueDate, dueTime) {
          setState(() {
            tasks[index].title = title;
            tasks[index].description = description;
            tasks[index].dueDateTime = DateTime(dueDate.year, dueDate.month, dueDate.day, dueTime.hour, dueTime.minute);
            tasks.sort((a, b) => a.dueDateTime.compareTo(b.dueDateTime));
          });
        },
      ),
    );
  }
}