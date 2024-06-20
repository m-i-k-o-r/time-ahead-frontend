import 'package:first_flutter_app/myApp/tasks/task_creating.dart';
import 'package:first_flutter_app/myApp/tasks/task_editing.dart';
import 'package:first_flutter_app/myApp/tasks/task_viewing.dart';
import 'package:first_flutter_app/myApp/tasks/tasks_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../app_colors.dart';
import '../widgets.dart';

class Task {
  String title;
  String description;
  DateTime dueDateTime;
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.dueDateTime,
    required this.isCompleted,
  });
}

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  TaskListState createState() => TaskListState();
}

class TaskListState extends State<TaskList> {
  List<Task> tasks = [];
  bool isAscending = true;
  bool completedTasksVisible = false;

  void _editTask(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditTaskScreen(
              task: task,
              onUpdate: (updatedTask) {
                setState(() {
                  tasks[tasks.indexOf(task)] = updatedTask;
                });
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              onDelete: () {
                setState(() {
                  tasks.remove(task);
                });
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
      ),
    );
  }

  void _addNewTask() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddTaskScreen(
              onAdd: (title, description, dueDateTime) {
                final newTask = Task(
                  title: title,
                  description: description,
                  dueDateTime: dueDateTime,
                  isCompleted: false,
                );
                setState(() {
                  tasks.add(newTask);
                });
              },
            ),
      ),
    );
  }

  void _viewTask(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TaskDetailScreen(
              task: task,
              onEdit: () => _editTask(task),
              onDelete: () {
                setState(() {
                  tasks.remove(task);
                });
              },
            ),
      ),
    );
  }

  void _deleteTask(int index) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('Удалить задачу'),
            content: const Text('Вы уверены, что хотите удалить эту задачу?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Отмена'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    tasks.removeAt(index);
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Подтвердить'),
              ),
            ],
          ),
    );
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
      tasks = List.from(tasks);
    });
  }

  void _sortTasks() {
    setState(() {
      tasks = [...tasks]
        ..sort((a, b) =>
        isAscending
            ? a.dueDateTime.compareTo(b.dueDateTime)
            : b.dueDateTime.compareTo(a.dueDateTime));
    });
  }

  @override
  Widget build(BuildContext context) {
    final incompleteTasks = tasks.where((task) => !task.isCompleted).toList();
    final completedTasks = tasks.where((task) => task.isCompleted).toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.blueWhite,
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Сортировать по',
                      style: TextStyle(
                          color: AppColors.darkBlue, fontWeight: FontWeight
                          .bold)),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isAscending = !isAscending;
                        _sortTasks();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        isAscending ? 'возр. времени' : 'убыв. времени',
                        style: const TextStyle(color: AppColors.blueWhite),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SvgDivider(svgPath: 'assets/icons/dividers/divider.svg'),
            Expanded(
              child: ListView(
                children: [
                  ...incompleteTasks
                      .asMap()
                      .entries
                      .map((entry) =>
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: TaskTile(
                            task: entry.value,
                            onDelete: _deleteTask,
                            onToggleCompletion: _toggleTaskCompletion,
                            taskIndex: tasks.indexOf(entry.value),
                            onViewTask: () => _viewTask(entry.value),
                          ),
                        ),
                      )),
                  const SvgDivider(
                      svgPath: 'assets/icons/dividers/divider.svg'),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.darkBlue,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: IntrinsicWidth(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                completedTasksVisible = !completedTasksVisible;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Text(
                                completedTasksVisible
                                    ? 'Скрыть выполненные'
                                    : 'Выполненные задачи',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (completedTasksVisible)
                    ...completedTasks
                        .asMap()
                        .entries
                        .map((entry) =>
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: TaskTile(
                              task: entry.value,
                              onDelete: _deleteTask,
                              onToggleCompletion: _toggleTaskCompletion,
                              taskIndex: tasks.indexOf(entry.value),
                              onViewTask: () => _viewTask(entry.value),
                            ),
                          ),
                        )),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 70,
            child: FloatingActionButton(
              onPressed: () => _addNewTask(),
              child: SvgPicture.asset('assets/icons/add.svg'),
            ),
          ),
        ),
      ),
    );
  }
}




