import 'package:first_flutter_app/myApp/habits/habits_widgets.dart';
import 'package:first_flutter_app/myApp/widgets.dart';
import 'package:flutter/material.dart';
import 'package:first_flutter_app/myApp/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HabitCreationScreen extends StatefulWidget {
  final HabitData? habitData;
  final Function(HabitData)? onSave;
  final String? habitId;

  HabitCreationScreen({
    Key? key,
    this.habitData,
    this.onSave,
    this.habitId,
  }) : super(key: key);

  @override
  _HabitCreationScreenState createState() => _HabitCreationScreenState();
}

class _HabitCreationScreenState extends State<HabitCreationScreen> {
  late bool _isTimeSet;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TimeOfDay _reminderTime;
  late Set<int> _selectedDays;

  @override
  void initState() {
    super.initState();
    if (widget.habitData != null) {
      _titleController = TextEditingController(text: widget.habitData!.title);
      _descriptionController =
          TextEditingController(text: widget.habitData!.description);
      _reminderTime = widget.habitData!.reminderTime ?? TimeOfDay.now();
      _selectedDays = widget.habitData!.selectedDays;
      _isTimeSet = widget.habitData!.reminderTime != null;
    } else {
      _titleController = TextEditingController();
      _descriptionController = TextEditingController();
      _reminderTime = TimeOfDay.now();
      _selectedDays = {};
      _isTimeSet = false;
    }
  }

  final List<String> inactiveDayIcons = [
    'assets/icons/daysOfWeek/monday-non-active.svg',
    'assets/icons/daysOfWeek/tuesday-non-active.svg',
    'assets/icons/daysOfWeek/wednesday-non-active.svg',
    'assets/icons/daysOfWeek/thursday-non-active.svg',
    'assets/icons/daysOfWeek/friday-non-active.svg',
    'assets/icons/daysOfWeek/saturday-non-active.svg',
    'assets/icons/daysOfWeek/sunday-non-active.svg',
  ];

  final List<String> activeDayIcons = [
    'assets/icons/daysOfWeek/monday-active.svg',
    'assets/icons/daysOfWeek/tuesday-active.svg',
    'assets/icons/daysOfWeek/wednesday-active.svg',
    'assets/icons/daysOfWeek/thursday-active.svg',
    'assets/icons/daysOfWeek/friday-active.svg',
    'assets/icons/daysOfWeek/saturday-active.svg',
    'assets/icons/daysOfWeek/sunday-active.svg',
  ];

  void _createHabit() {
    if (_titleController.text
        .trim()
        .isEmpty) {
      _showAlertDialog(
          'Название не установлено', 'Пожалуйста, введите название привычки.');
      return;
    }

    if (!_isTimeSet) {
      _showAlertDialog('Время не установлено',
          'Пожалуйста, установите время напоминания для привычки.');
      return;
    }

    if (_selectedDays.isEmpty) {
      _showAlertDialog('Дни не выбраны',
          'Пожалуйста, выберите хотя бы один день недели для привычки.');
      return;
    }

    final habitData = HabitData(
      title: _titleController.text,
      description: _descriptionController.text,
      reminderTime: _reminderTime,
      selectedDays: _selectedDays,
    );

    Navigator.pop(context, habitData);
  }

  void _showAlertDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text('ОК'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _toggleDay(int day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  void _selectAllDays() {
    setState(() {
      if (_selectedDays.length == 7) {
        _selectedDays.clear();
      } else {
        _selectedDays.addAll(List.generate(7, (index) => index + 1));
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
            child: Container(
              height: 55.0,
              decoration: BoxDecoration(
                color: AppColors.blueWhite,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Container(
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15))
                      ),
                    ),
                  ),
                  SizedBox(width: 50,),
                  Expanded(
                    child: Text(
                      'Создание привычки',
                      style: TextStyle(
                        color: AppColors.darkBlue,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 20, 20),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                          child: Row(
                            children: [
                              const Text(
                                'введите название',
                                style: TextStyle(
                                  color: AppColors.blueWhite,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(width: 10),
                              SvgPicture.asset('assets/icons/pencil.svg')
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, top: 0),
                          child: TextFormField(
                            controller: _titleController,
                            maxLength: 75,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                            ),
                            decoration: const InputDecoration(
                                hintText: "Название привычки",
                                hintStyle: TextStyle(
                                  fontSize: 22.0,
                                  color: AppColors.blueWhite,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(bottom: 0),
                                counterText: ""
                            ),
                          ),
                        ),
                      ]
                  ),
                ),
                SvgDivider(svgPath: 'assets/icons/dividers/divider.svg', padding: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 180),
                  child: ReminderTimeButton(
                    reminderTime: _isTimeSet ? _reminderTime : null,
                    onPressed: (TimeOfDay newTime) {
                      setState(() {
                        _reminderTime = newTime;
                        _isTimeSet = true;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (int day = 1; day <= 7; day++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.85),
                        child: GestureDetector(
                          onTap: () => _toggleDay(day),
                          child: SvgPicture.asset(
                            _selectedDays.contains(day)
                                ? activeDayIcons[day - 1]
                                : inactiveDayIcons[day - 1],
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _selectAllDays,
                  child: Text('Выбрать все дни недели'),
                ),
                SvgDivider(
                    svgPath: 'assets/icons/dividers/divider.svg', padding: 10),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                          child: Row(
                            children: [
                              const Text(
                                'описание привычки',
                                style: TextStyle(
                                  color: AppColors.blueWhite,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(width: 10),
                              SvgPicture.asset('assets/icons/pencil.svg')
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, top: 0),
                          child: TextFormField(
                            controller: _descriptionController,
                            maxLength: 200,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                            ),
                            decoration: const InputDecoration(
                                hintText: "Описание (не обязательно)",
                                hintStyle: TextStyle(
                                    fontSize: 22.0,
                                    color: AppColors.blueWhite

                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(top: 0),
                                counterText: ""
                            ),
                          ),
                        ),
                      ]
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createHabit,
        child: Icon(Icons.check),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class HabitData {
  final String title;
  final String description;
  final TimeOfDay? reminderTime;
  final Set<int> selectedDays;

  HabitData({
    required this.title,
    required this.description,
    required this.reminderTime,
    required this.selectedDays,
  });
}