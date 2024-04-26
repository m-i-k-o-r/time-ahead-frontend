import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();

  List<String> getCategories() {
    return _MyHomePageState.categories;
  }
}

class _MyHomePageState extends State<MyHomePage> {
  static const List<String> categories = ['Work', 'Study', 'Sport'];

  DateTime _currentDate = DateTime.now();
  Map<DateTime, List<Activity>> activities = {};

  void _deleteActivity(DateTime date, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this activity?'),
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
                  activities[date]!.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _toggleActivityCompletion(DateTime date, int index) {
    setState(() {
      activities[date]![index].isCompleted = !activities[date]![index].isCompleted;
    });
  }

  void _addActivity(String title, String category, String description, DateTime startTime, DateTime endTime) {
    final currentDate = _currentDate;

    final newActivity = Activity(
      title: title,
      category: category,
      description: description,
      startTime: startTime,
      endTime: endTime,
      date: currentDate,
      isCompleted: false,
    );

    setState(() {
      final currentActivities = activities[currentDate] ?? [];
      currentActivities.add(newActivity);
      activities[currentDate] = currentActivities;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentActivities = activities[_currentDate] ?? [];
    currentActivities.sort((a, b) {
      int startCompare = a.startTime.compareTo(b.startTime);
      if (startCompare != 0) return startCompare;
      int endCompare = a.endTime.compareTo(b.endTime);
      if (endCompare != 0) return endCompare;
      return a.title.compareTo(b.title);
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Tracker'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    setState(() {
                      _currentDate = _currentDate.subtract(const Duration(days: 1));
                    });
                  },
                ),
                Text(
                  DateFormat('EEEE, d MMMM').format(_currentDate),
                  style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    setState(() {
                      _currentDate = _currentDate.add(const Duration(days: 1));
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: currentActivities.length,
              itemBuilder: (context, index) {
                final activity = currentActivities[index];
                return GestureDetector(
                  onTap: () => _showActivityDetailsDialog(activity),
                  child: ActivityTile(
                    activity: activity,
                    onCompleted: () => _toggleActivityCompletion(_currentDate, index),
                    onEdit: () => _showEditActivityDialog(context, activity, () {
                      setState(() {});
                    }),
                    onDelete: () => _deleteActivity(_currentDate, index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AddActivityDialog(
            onAdd: _addActivity,
            getCategories: () => categories, // Передаем функцию, которая возвращает список категорий
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showActivityDetailsDialog(Activity activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Activity Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${activity.title}'),
            Text('Start Time: ${DateFormat('HH:mm').format(activity.startTime)}'),
            Text('End Time: ${DateFormat('HH:mm').format(activity.endTime)}'),
            Text('Category: ${activity.category}'),
            Text('Description: ${activity.description}'),
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

  void _showEditActivityDialog(BuildContext context, Activity activity, Function() onEdit) {
    TextEditingController titleController = TextEditingController(text: activity.title);
    TextEditingController descriptionController = TextEditingController(text: activity.description);

    DateTime startTime = activity.startTime;
    DateTime endTime = activity.endTime;
    String? selectedCategory = activity.category.isNotEmpty ? activity.category : null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Activity'),
        content: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              DropdownButtonFormField<String?>(
                value: selectedCategory,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('No category'),
                  ),
                  ...categories.map((category) {
                    return DropdownMenuItem<String?>(
                      value: category,
                      child: Text(category),
                    );
                  }),
                ],
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              TextFormField(
                controller: descriptionController,
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
                        'Start Time',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () async {
                          final newTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(startTime),
                            builder: (BuildContext context, Widget? child) {
                              return MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(alwaysUse24HourFormat: true),
                                child: child!,
                              );
                            },
                          );
                          if (newTime != null) {
                            startTime = DateTime(startTime.year,
                                startTime.month, startTime.day, newTime.hour, newTime.minute);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(DateFormat('HH:mm').format(startTime)),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'End Time',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () async {
                          final newTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(endTime),
                          );
                          if (newTime != null) {
                            endTime = DateTime(endTime.year, endTime.month,
                                endTime.day, newTime.hour, newTime.minute);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(DateFormat('HH:mm').format(endTime)),
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
              activity.title = titleController.text;
              activity.category = selectedCategory ?? '';
              activity.description = descriptionController.text;
              activity.startTime = startTime;
              activity.endTime = endTime;
              onEdit();
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}