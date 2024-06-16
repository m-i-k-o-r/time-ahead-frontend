import 'package:first_flutter_app/myApp/activity/activities_list.dart';
import 'package:first_flutter_app/myApp/app_colors.dart';
import 'package:first_flutter_app/myApp/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
          const SvgDivider(svgPath: 'assets/icons/dividers/divider.svg'),
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
                  const SvgDivider(svgPath: 'assets/icons/dividers/divider.svg'),
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
                  const SvgDivider(svgPath: 'assets/icons/dividers/divider.svg'),
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
                          items: [ActivityListState.noCategory, ...ActivityListState.categories].map((category) {
                            return DropdownMenuItem<String>(
                              value: category == ActivityListState.noCategory ? null : category,
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
                  const SvgDivider(svgPath: 'assets/icons/dividers/divider.svg'),
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