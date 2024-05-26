import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../app_colors.dart';
import '../widgets.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Task> tasks = [];
  bool isAscending = true;
  bool completedTasksVisible = false;

  void _editTask(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(
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
        builder: (context) => AddTaskScreen(
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
        builder: (context) => TaskDetailScreen(
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
      tasks = List.from(tasks);
    });
  }

  void _sortTasks() {
    setState(() {
      tasks = [...tasks]
        ..sort((a, b) => isAscending
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
                          color: AppColors.darkBlue, fontWeight: FontWeight.bold)),
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
            const SvgDivider(svgPath: 'assets/icons/divider.svg'),
            Expanded(
              child: ListView(
                children: [
                  ...incompleteTasks.asMap().entries.map((entry) => Padding(
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
                  const SvgDivider(svgPath: 'assets/icons/divider.svg'),
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
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Text(
                                completedTasksVisible ? 'Скрыть выполненные' : 'Выполненные задачи',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (completedTasksVisible)
                    ...completedTasks.asMap().entries.map((entry) => Padding(
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
              onPressed: () => _showAddTaskDialog(),
              child: SvgPicture.asset('assets/icons/add.svg'),
            ),
          ),
        ),
      ),
    );
  }

  void _showAddTaskDialog() {
    _addNewTask();
  }
}

class TaskTile extends StatelessWidget {
  final Task task;
  final Function(int) onDelete;
  final Function(int) onToggleCompletion;
  final int taskIndex;
  final Function() onViewTask;

  const TaskTile({super.key,
    required this.task,
    required this.onDelete,
    required this.onToggleCompletion,
    required this.taskIndex,
    required this.onViewTask,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onViewTask,
      child: Container(
        color: AppColors.white,
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: AppColors.darkBlue,
                  ),
                  onPressed: () => onToggleCompletion(taskIndex),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        color: task.isCompleted ? AppColors.blueWhite :Colors.black,
                        decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                        fontWeight: task.isCompleted ? FontWeight.normal : FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      DateFormat('HH:mm dd.MM.yyyy').format(task.dueDateTime),
                      style: const TextStyle(color: AppColors.blueWhite),
                    ),
                  ],
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}

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

class AddTaskDialog extends StatefulWidget {
  final Function(String, String, DateTime, TimeOfDay) onAdd;

  const AddTaskDialog({super.key, required this.onAdd});

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Task'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
              ),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Due Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(DateFormat('dd.MM.yyyy').format(_selectedDate)),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Due Time',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () => _selectTime(context),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(_selectedTime.format(context)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onAdd(_titleController.text, _descriptionController.text, _selectedDate, _selectedTime);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }
}

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  final VoidCallback? onEdit;
  final VoidCallback onDelete;

  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 38.0, 16, 16),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.blueWhite,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: AppColors.darkBlue),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: AppColors.darkBlue),
                        onPressed: onEdit,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Название задачи',
                        style: TextStyle(
                          color: AppColors.blueWhite,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        task.title,
                        style: const TextStyle(
                          color: AppColors.darkBlue,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
                const SvgDivider(svgPath: 'assets/icons/divider.svg', padding: 4.0),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Время выполнения',
                              style: TextStyle(
                                color: AppColors.blueWhite,
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              DateFormat('HH:mm dd.MM.yyyy').format(task.dueDateTime),
                              style: const TextStyle(
                                color: AppColors.darkBlue,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                const SvgDivider(svgPath: 'assets/icons/divider.svg'),
                const SizedBox(height: 8.0),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Описание задачи',
                        style: TextStyle(
                          color: AppColors.blueWhite,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        task.description,
                        style: const TextStyle(
                          color: AppColors.darkBlue,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EditTaskScreen extends StatefulWidget {
  final Task task;
  final Function(Task) onUpdate;
  final Function() onDelete;

  const EditTaskScreen({super.key, required this.task, required this.onUpdate, required this.onDelete});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _dueDateTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _dueDateTime = widget.task.dueDateTime;
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтвердите удаление'),
          content: const Text('Вы действительно хотите удалить эту задачу?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onDelete();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 38.0, 16.0, 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.blueWhite,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: AppColors.darkBlue),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: AppColors.darkBlue),
                          onPressed: _confirmDelete,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Название задачи',
                      style: TextStyle(
                        color: AppColors.blueWhite,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      controller: _titleController,
                      style: const TextStyle(
                        color: AppColors.darkBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              const SvgDivider(svgPath: 'assets/icons/divider.svg'),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Время выполнения',
                            style: TextStyle(
                              color: AppColors.blueWhite,
                              fontSize: 16.0,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          InkWell(
                            onTap: () async {
                              final newDate = await showDatePicker(
                                context: context,
                                initialDate: _dueDateTime,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              if (newDate != null) {
                                final newTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(_dueDateTime),
                                );
                                if (newTime != null) {
                                  setState(() {
                                    _dueDateTime = DateTime(
                                      newDate.year,
                                      newDate.month,
                                      newDate.day,
                                      newTime.hour,
                                      newTime.minute,
                                    );
                                  });
                                }
                              }
                            },
                            child: Text(
                              DateFormat('HH:mm dd.MM.yyyy').format(_dueDateTime),
                              style: const TextStyle(
                                color: AppColors.darkBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              const SvgDivider(svgPath: 'assets/icons/divider.svg'),
              const SizedBox(height: 8.0),

              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Описание задачи',
                      style: TextStyle(
                        color: AppColors.blueWhite,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      controller: _descriptionController,
                      style: const TextStyle(
                        color: AppColors.darkBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    final updatedTask = Task(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      dueDateTime: _dueDateTime,
                      isCompleted: widget.task.isCompleted,
                    );
                    widget.onUpdate(updatedTask);
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text('Сохранить'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddTaskScreen extends StatefulWidget {
  final Function(String title, String description, DateTime dueDateTime) onAdd;

  const AddTaskScreen({super.key, required this.onAdd});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late DateTime _dueDateTime;

  @override
  void initState() {
    super.initState();
    _dueDateTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 38.0, 8.0, 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.blueWhite,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: AppColors.darkBlue),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SvgDivider(svgPath: 'assets/icons/divider.svg'),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Название задачи',
                          style: TextStyle(
                            color: AppColors.blueWhite,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        TextFormField(
                          controller: _titleController,
                          style: const TextStyle(
                            color: AppColors.darkBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '',
                            errorStyle: TextStyle(color: AppColors.darkBlue),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Название задачи не может быть пустым!';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const SvgDivider(svgPath: 'assets/icons/divider.svg'),
                  const SizedBox(height: 8.0),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Время выполнения',
                          style: TextStyle(
                            color: AppColors.blueWhite,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        InkWell(
                          onTap: () async {
                            final newDate = await showDatePicker(
                              context: context,
                              initialDate: _dueDateTime,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (newDate != null) {
                              final newTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(_dueDateTime),
                              );
                              if (newTime != null) {
                                setState(() {
                                  _dueDateTime = DateTime(
                                    newDate.year,
                                    newDate.month,
                                    newDate.day,
                                    newTime.hour,
                                    newTime.minute,
                                  );
                                });
                              }
                            }
                          },
                          child: Text(
                            DateFormat('HH:mm dd.MM.yyyy').format(_dueDateTime),
                            style: const TextStyle(
                              color: AppColors.darkBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const SvgDivider(svgPath: 'assets/icons/divider.svg'),
                  const SizedBox(height: 8.0),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Описание задачи',
                          style: TextStyle(
                            color: AppColors.blueWhite,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        TextFormField(
                          controller: _descriptionController,
                          style: const TextStyle(
                            color: AppColors.darkBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onAdd(
                    _titleController.text,
                    _descriptionController.text,
                    _dueDateTime,
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Добавить'),
            ),
          ),
        ],
      ),
    );
  }
}