import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../widgets.dart';
import 'package:first_flutter_app/myApp/app_colors.dart';


class ActivityList extends StatefulWidget {
  const ActivityList({super.key});

  @override
  _ActivityListState createState() => _ActivityListState();

  List<String> getCategories() {
    return _ActivityListState.categories;
  }
}

class _ActivityListState extends State<ActivityList> {
  static const String noCategory = 'Без категории';
  static List<String> categories = ['Work', 'Study', 'Sport'];

  DateTime _currentDate = DateTime.now();
  Map<DateTime, List<Activity>> activities = {};

  void _deleteActivity(DateTime date, int index) {
    setState(() {
      activities[date]!.removeAt(index);
    });
    if (activities[date]!.isEmpty) {
      activities.remove(date);
    }
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
    final allActivities = activities[_currentDate] ?? [];
    allActivities.sort((a, b) {
      int startCompare = a.startTime.compareTo(b.startTime);
      if (startCompare != 0) return startCompare;
      int endCompare = a.endTime.compareTo(b.endTime);
      if (endCompare != 0) return endCompare;
      return a.title.compareTo(b.title);
    });

    final incompleteActivities = allActivities.where((activity) => !activity.isCompleted).toList();
    final completedActivities = allActivities.where((activity) => activity.isCompleted).toList();

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 30.0),
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
                            onPressed: () {
                              setState(() {
                                _currentDate = _currentDate.subtract(const Duration(days: 1));
                              });
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.white, width: 2),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                DateFormat('d MMMM').format(_currentDate),
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkBlue,
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Image.asset(
                                'assets/icons/activity.png',
                                color: AppColors.darkBlue,
                                height: 24.0,
                                width: 24.0,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, color: AppColors.darkBlue),
                            onPressed: () {
                              setState(() {
                                _currentDate = _currentDate.add(const Duration(days: 1));
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 0.0),
              ],
            ),
          ),
          const SvgDivider(svgPath: 'assets/icons/divider.svg'),
          Expanded(
            child: ListView(
              children: [
                ...incompleteActivities.map((activity) => ActivityTile(
                  activity: activity,
                  onCompleted: () {
                    setState(() {
                      activity.isCompleted = true;
                    });
                  },
                  onEdit: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditActivityScreen(
                        activity: activity,
                        onUpdate: (updatedActivity) {
                          setState(() {
                            activities[activity.date]![activities[activity.date]!.indexOf(activity)] = updatedActivity;
                          });
                        },
                        onDelete: (date, index) {
                          _deleteActivity(date, index);
                        },
                        activities: activities,
                      ),
                    ),
                  ),
                  onDelete: () => _deleteActivity(_currentDate, allActivities.indexOf(activity)),
                  isCurrentActivity: false,
                )),
                const SizedBox(height: 0.0),
                const SvgDivider(svgPath: 'assets/icons/divider.svg'),
                const SizedBox(height: 0.0),
                ...completedActivities.map((activity) => ActivityTile(
                  activity: activity,
                  onCompleted: null,
                  onEdit: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditActivityScreen(
                        activity: activity,
                        onUpdate: (updatedActivity) {
                          setState(() {
                            activities[activity.date]![activities[activity.date]!.indexOf(activity)] = updatedActivity;
                          });
                        },
                        onDelete: (date, index) {
                          _deleteActivity(date, index);
                        },
                        activities: activities,
                      ),
                    ),
                  ),
                  onDelete: () => _deleteActivity(_currentDate, allActivities.indexOf(activity)),
                  isCurrentActivity: false,
                )),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 70,
            child: FloatingActionButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddActivityScreen(
                    onAdd: _addActivity,
                    getCategories: () => categories,
                  ),
                ),
              ),
              child: SvgPicture.asset('assets/icons/add.svg'),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}


class ActivityDetailScreen extends StatelessWidget {
  final Activity activity;
  final VoidCallback? onEdit;
  final VoidCallback onDelete;

  const ActivityDetailScreen({
    super.key,
    required this.activity,
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
                        'Название активности',
                        style: TextStyle(
                          color: AppColors.blueWhite,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        activity.title,
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
                              'Время начала',
                              style: TextStyle(
                                color: AppColors.blueWhite,
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              DateFormat('HH:mm').format(activity.startTime),
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
                    const SizedBox(width: 16.0),
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
                              'Время конца',
                              style: TextStyle(
                                color: AppColors.blueWhite,
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              DateFormat('HH:mm').format(activity.endTime),
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
                const SizedBox(height: 0.0),
                const SvgDivider(svgPath: 'assets/icons/divider.svg'),
                const SizedBox(height: 0.0),
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
                        'Тип активности',
                        style: TextStyle(
                          color: AppColors.blueWhite,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        activity.category.isEmpty
                            ? _ActivityListState.noCategory
                            : activity.category,
                        style: const TextStyle(
                          color: AppColors.darkBlue,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 0.0),
                const SvgDivider(svgPath: 'assets/icons/divider.svg'),
                const SizedBox(height: 0.0),
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
                        'Описание активности',
                        style: TextStyle(
                          color: AppColors.blueWhite,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        activity.description,
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

class EditActivityScreen extends StatefulWidget {
  final Activity activity;
  final Function(Activity) onUpdate;
  final Function(DateTime, int) onDelete;
  final Map<DateTime, List<Activity>> activities;

  const EditActivityScreen({super.key,
    required this.activity,
    required this.onUpdate,
    required this.onDelete,
    required this.activities,
  });

  @override
  _EditActivityScreenState createState() => _EditActivityScreenState();
}

class _EditActivityScreenState extends State<EditActivityScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _startTime;
  late DateTime _endTime;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.activity.title);
    _descriptionController = TextEditingController(text: widget.activity.description);
    _startTime = widget.activity.startTime;
    _endTime = widget.activity.endTime;
    _selectedCategory = widget.activity.category.isEmpty ? null : widget.activity.category;
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтвердите удаление'),
          content: const Text('Вы действительно хотите удалить эту активность?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onDelete(widget.activity.date, widget.activities[widget.activity.date]!.indexOf(widget.activity));
                Navigator.of(context).pop();
                Navigator.of(context).pop();
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
                      'Название активности',
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
                            'Время начала',
                            style: TextStyle(
                              color: AppColors.blueWhite,
                              fontSize: 16.0,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          InkWell(
                            onTap: () async {
                              final newTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(_startTime),
                              );
                              if (newTime != null) {
                                setState(() {
                                  _startTime = DateTime(
                                    _startTime.year,
                                    _startTime.month,
                                    _startTime.day,
                                    newTime.hour,
                                    newTime.minute,
                                  );
                                });
                              }
                            },
                            child: Text(
                              DateFormat('HH:mm').format(_startTime),
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
                  const SizedBox(width: 16.0),
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
                            'Время конца',
                            style: TextStyle(
                              color: AppColors.blueWhite,
                              fontSize: 16.0,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          InkWell(
                            onTap: () async {
                              final newTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(_endTime),
                              );
                              if (newTime != null) {
                                setState(() {
                                  _endTime = DateTime(
                                    _endTime.year,
                                    _endTime.month,
                                    _endTime.day,
                                    newTime.hour,
                                    newTime.minute,
                                  );
                                });
                              }
                            },
                            child: Text(
                              DateFormat('HH:mm').format(_endTime),
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
                      'Тип активности',
                      style: TextStyle(
                        color: AppColors.blueWhite,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    DropdownButtonFormField<String?>(
                      value: _selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                      items: [null, ..._ActivityListState.categories].map((category) {
                        return DropdownMenuItem<String?>(
                          value: category,
                          child: Text(
                            category ?? _ActivityListState.noCategory,
                            style: const TextStyle(
                              color: AppColors.darkBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
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
                      'Описание активности',
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
                    final updatedActivity = Activity(
                      title: _titleController.text,
                      category: _selectedCategory ?? '',
                      description: _descriptionController.text,
                      startTime: _startTime,
                      endTime: _endTime,
                      date: widget.activity.date,
                      isCompleted: widget.activity.isCompleted,
                    );
                    widget.onUpdate(updatedActivity);
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

class AddActivityScreen extends StatefulWidget {
  final Function(String title, String category, String description, DateTime startTime, DateTime endTime) onAdd;
  final List<String> Function() getCategories;

  const AddActivityScreen({super.key,
    required this.onAdd,
    required this.getCategories,
  });

  @override
  _AddActivityScreenState createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  late DateTime _startTime;
  late DateTime _endTime;

  @override
  void initState() {
    super.initState();
    _categoryController.text = '';
    _startTime = DateTime.now();
    _endTime = DateTime.now().add(const Duration(hours: 1));
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
                          'Название активности',
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
                              return 'Название активности не может быть пустым!';
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
                                'Время начала',
                                style: TextStyle(
                                  color: AppColors.blueWhite,
                                  fontSize: 16.0,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              InkWell(
                                onTap: () async {
                                  final newTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(_startTime),
                                    builder: (BuildContext context, Widget? child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context)
                                            .copyWith(alwaysUse24HourFormat: true),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (newTime != null) {
                                    setState(() {
                                      _startTime = DateTime(_startTime.year,
                                          _startTime.month, _startTime.day, newTime.hour, newTime.minute);
                                    });
                                  }
                                },
                                child: Text(
                                  DateFormat('HH:mm').format(_startTime),
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
                      const SizedBox(width: 16.0),
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
                                'Время конца',
                                style: TextStyle(
                                  color: AppColors.blueWhite,
                                  fontSize: 16.0,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              InkWell(
                                onTap: () async {
                                  final newTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(_endTime),
                                  );
                                  if (newTime != null) {
                                    setState(() {
                                      _endTime = DateTime(_endTime.year, _endTime.month,
                                          _endTime.day, newTime.hour, newTime.minute);
                                    });
                                  }
                                },
                                child: Text(
                                  DateFormat('HH:mm').format(_endTime),
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
                          'Тип активности',
                          style: TextStyle(
                            color: AppColors.blueWhite,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        DropdownButtonFormField<String>(
                          value: _categoryController.text.isEmpty ? null : _categoryController.text,
                          onChanged: (value) {
                            setState(() {
                              _categoryController.text = value ?? '';
                            });
                          },
                          items: [_ActivityListState.noCategory, ..._ActivityListState.categories].map((category) {
                            return DropdownMenuItem<String>(
                              value: category == _ActivityListState.noCategory ? null : category,
                              child: Text(
                                category,
                                style: const TextStyle(
                                  color: AppColors.darkBlue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
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
                          'Описание',
                          style: TextStyle(
                            color: AppColors.blueWhite,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: null,
                          style: const TextStyle(
                            color: AppColors.darkBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
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
                    _categoryController.text.isEmpty ? '' : _categoryController.text,
                    _descriptionController.text,
                    _startTime,
                    _endTime,
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