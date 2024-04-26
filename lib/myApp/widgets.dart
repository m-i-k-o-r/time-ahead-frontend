import 'package:first_flutter_app/myApp/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBar();

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(50); // Размер AppBar
}

class _CustomAppBarState extends State<CustomAppBar> {
  // Устанавливаем начальное значение на одно из существующих значений
  String _selectedDay = 'Сегодня';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        child: AppBar(
          backgroundColor: AppColors.blueWhite,
          elevation: 0,
          actions: [
            DropdownButtonHideUnderline(
              child: Center(
                child: DropdownButton<String>(
                  value: _selectedDay, // Начальное значение
                  icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                  dropdownColor: Colors.indigo,
                  style: TextStyle(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedDay = newValue!;
                    });
                  },
                  items: ['Сегодня', 'Вчера', 'Последние 7 дней']
                      .map((value) => DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex; // Передается из родительского виджета
  final Function(int) onItemTapped; // Функция обратного вызова

  CustomNavigationBar({
    required this.selectedIndex, // Получаем текущий индекс
    required this.onItemTapped, // Получаем функцию обратного вызова
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(15) // Скругление верхнего правого угла
        ),
        child: NavigationBar(
          backgroundColor: AppColors.darkBlue,
          selectedIndex: selectedIndex, // Используем для выделения активного элемента
          onDestinationSelected: onItemTapped, // Привязка к функции обратного вызова
          destinations: [
            NavigationDestination(
              label: 'Активность',
              icon: Image.asset('assets/icons/activity.png'), // Пример иконки
            ),
            NavigationDestination(
              label: 'Задачи',
              icon: Image.asset('assets/icons/to-do.png'), // Пример иконки
            ),
            NavigationDestination(
              label: 'Привычки',
              icon: Image.asset('assets/icons/habit.png'),
            ),
            NavigationDestination(
              label: 'Профиль',
              icon: Image.asset('assets/icons/profile.png'),
            )
          ],
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))
          ),
        ),
      ),
    );
  }
}

class DaySlider extends StatefulWidget {
  @override
  _DaySliderState createState() => _DaySliderState();
}

class _DaySliderState extends State<DaySlider> {
  final List<String> daysOfWeek = [
    'Все',
    'Понедельник',
    'Вторник',
    'Среда',
    'Четверг',
    'Пятница',
    'Суббота',
    'Воскресенье'
  ];

  int _selectedIndex = 0; // Индекс выбранного дня недели

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: daysOfWeek.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedIndex = index; // Обновляем выбранный индекс
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedIndex == index
                    ? AppColors.darkBlue
                    : AppColors.white, // Изменяем цвет в зависимости от выбранного индекса
              ),
              child: Text(
                daysOfWeek[index],
                style: TextStyle(
                  color: _selectedIndex == index
                      ? Colors.white
                      : AppColors.blueWhite,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


/*class FloatingActionButtonContainer extends StatelessWidget {
  final Widget child;

  FloatingActionButtonContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      alignment: Alignment.topCenter,
      child: child,
    );
  }
}*/

class SvgDivider extends StatelessWidget {
  final String svgPath = "assets/icons/divider.svg";
  final double padding; // Параметр отступа вокруг разделителя

  SvgDivider({required svgPath, this.padding = 16.0}); // Конструктор

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: padding), // Отступы сверху и снизу
      child: Center(
        child: SvgPicture.asset(
          svgPath, // Путь к вашей SVG-иконке
          width: 24, // Ширина иконки
          height: 24, // Высота иконки
          colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn), // Цвет иконки
        ),
      ),
    );
  }
}

class Activity {
  String title;
  String category;
  String description;
  DateTime startTime;
  DateTime endTime;
  DateTime date;
  bool isCompleted;

  Activity({
    required this.title,
    required this.category,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.date,
    this.isCompleted = false,
  });
}

class ActivityTile extends StatelessWidget {
  final Activity activity;
  final VoidCallback onCompleted;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ActivityTile({
    required this.activity,
    required this.onCompleted,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = activity.isCompleted;

    return ListTile(
      title: Text(
        activity.title,
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${DateFormat('HH:mm').format(activity.startTime)} - ${DateFormat('HH:mm').format(activity.endTime)}'),
          if (activity.category.isNotEmpty) Text(activity.category),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isCompleted ? Colors.deepPurple : Colors.deepPurple,
            ),
            onPressed: onCompleted,
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            color: Colors.deepPurple,
            onPressed: onEdit,
          ),

          IconButton(
            icon: const Icon(Icons.delete),
            color: Colors.deepPurple,
            onPressed: onDelete,
          ),
        ],
      ),
      tileColor: isCompleted ? Colors.indigo[50] : null,
    );
  }
}

class AddActivityDialog extends StatefulWidget {
  final Function(String title, String category, String description, DateTime startTime, DateTime endTime) onAdd;
  final List<String> Function() getCategories; // Добавляем новый параметр - функцию

  const AddActivityDialog({
    required this.onAdd,
    required this.getCategories, // Не забываем инициализировать его в конструкторе
  });

  @override
  _AddActivityDialogState createState() => _AddActivityDialogState();
}

class _AddActivityDialogState extends State<AddActivityDialog> {
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
    return AlertDialog(
      title: const Text('Add Activity'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Category',
              ),
              value: _categoryController.text.isEmpty ? null : _categoryController.text,
              onChanged: (value) {
                setState(() {
                  _categoryController.text = value ?? '';
                });
              },
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('No category'),
                ),
                ...widget.getCategories().map((category) { // Используем функцию для получения категорий
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }),
              ],
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(DateFormat('HH:mm').format(_startTime)),
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
                          initialTime: TimeOfDay.fromDateTime(_endTime),
                        );
                        if (newTime != null) {
                          setState(() {
                            _endTime = DateTime(_endTime.year, _endTime.month,
                                _endTime.day, newTime.hour, newTime.minute);
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(DateFormat('HH:mm').format(_endTime)),
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
              final title = _titleController.text;
              final category = _categoryController.text;
              final description = _descriptionController.text;
              widget.onAdd(title, category, description, _startTime, _endTime);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
