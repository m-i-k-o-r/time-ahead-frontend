import 'package:first_flutter_app/myApp/habits/habits_list.dart';
import 'package:flutter/material.dart';
import 'package:first_flutter_app/myApp/app_colors.dart';

class HabitCreationScreen extends StatefulWidget {

  @override
  _HabitCreationScreenState createState() => _HabitCreationScreenState();
}

class _HabitCreationScreenState extends State<HabitCreationScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TimeOfDay _reminderTime = TimeOfDay.now();
  final Set<int> _selectedDays = {};


  void _createHabit() {
    final habitData = HabitData(
      title: _titleController.text,
      description: _descriptionController.text,
      reminderTime: _reminderTime,
      selectedDays: _selectedDays,
    );

    Navigator.pop(context, habitData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(55.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
            child: AppBar(
              backgroundColor: AppColors.blueWhite,
              title: Text('Создание привычки'),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15),
                ),
              ),
            ),
          ),
        ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Название задачи',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            Text(
              _reminderTime.format(context),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () => _selectTime(context),
                    child: MediaQuery(
                      data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                      child: Text(_reminderTime.format(context)),
                    )
                ),
                Text('Время напоминания')
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Описание (не обязательно)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                for (int day = 1; day <= 7; day++)
                  ChoiceChip(
                    label: Text(_getDayName(day)),
                    selected: _selectedDays.contains(day),
                    onSelected: (bool selected) {
                      _toggleDay(day, selected);
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createHabit,
        child: Icon(Icons.check),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _selectTime(BuildContext context) async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (newTime != null) {
      setState(() {
        _reminderTime = newTime;
      });
    }
  }

  void _toggleDay(int day, bool selected) {
    setState(() {
      if (selected) {
        _selectedDays.add(day);
      } else {
        _selectedDays.remove(day);
      }
    });
  }

  String _getDayName(int day) {
    switch (day) {
      case 1:
        return 'Пн';
      case 2:
        return 'Вт';
      case 3:
        return 'Ср';
      case 4:
        return 'Чт';
      case 5:
        return 'Пт';
      case 6:
        return 'Сб';
      case 7:
        return 'Вс';
      default:
        return '';
    }
  }
}
