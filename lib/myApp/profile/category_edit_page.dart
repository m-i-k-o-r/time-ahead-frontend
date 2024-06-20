import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_colors.dart';
import '../category_model.dart';

class CategoryEditPage extends StatefulWidget {
  @override
  _CategoryEditPageState createState() => _CategoryEditPageState();
}

class _CategoryEditPageState extends State<CategoryEditPage> {
  final _newCategoryController = TextEditingController();
  final Map<int, TextEditingController> _editingControllers = {};
  final Map<int, bool> _isEditing = {};

  @override
  void dispose() {
    _newCategoryController.dispose();
    _editingControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _addCategory(String category) {
    Provider.of<CategoryModel>(context, listen: false).addCategory(category);
    _newCategoryController.clear();
  }

  void _deleteCategory(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Подтвердите удаление'),
        content: const Text('Вы действительно хотите удалить эту категорию?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<CategoryModel>(context, listen: false).removeCategory(index);
              Navigator.pop(context);

            },
            child: const Text('Удалить'),

          ),
        ],
      ),
    );
  }

  void _toggleEditCategory(int index) {
    setState(() {
      bool anyEditing = _isEditing.values.any((editing) => editing);

      if (_isEditing.containsKey(index) && _isEditing[index]!) {
        Provider.of<CategoryModel>(context, listen: false)
            .updateCategory(index, _editingControllers[index]!.text);
        _editingControllers[index]!.clear();
      } else if (!anyEditing) {
        _editingControllers[index] = TextEditingController(
            text: Provider.of<CategoryModel>(context, listen: false)
                .categories[index]);
      }

      _isEditing.updateAll((key, value) => false);
      if (!anyEditing) {
        _isEditing[index] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.blueWhite,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.only(top: 32.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: const Icon(
                        Icons.arrow_back,
                        color: AppColors.darkBlue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  const Text(
                    'Ваши категории',
                    style: TextStyle(
                      color: AppColors.darkBlue,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Consumer<CategoryModel>(
              builder: (context, categoryModel, child) {
                return Flexible(
                  child: ListView.builder(
                    itemCount: categoryModel.categories.length,
                    itemBuilder: (context, index) {
                      bool isEditing = _isEditing[index] ?? false;
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            isEditing
                                ? Expanded(
                              child: TextField(
                                controller: _editingControllers[index],
                                style: const TextStyle(
                                  color: AppColors.darkBlue,
                                ),
                                cursorColor: AppColors.darkBlue,
                              ),
                            )
                                : Text(
                              categoryModel.categories[index],
                              style: const TextStyle(
                                color: AppColors.blueWhite,
                                fontSize: 16,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: AppColors.darkBlue),
                                  onPressed: () => _toggleEditCategory(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: AppColors.orange),
                                  onPressed: () => _deleteCategory(index),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _newCategoryController,
                        decoration: const InputDecoration(
                          hintText: 'Новая категория',
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          color: AppColors.blueWhite,
                        ),
                        cursorColor: AppColors.darkBlue,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    GestureDetector(
                      onTap: () {
                        if (_newCategoryController.text.isNotEmpty) {
                          _addCategory(_newCategoryController.text);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.blueWhite,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: const Icon(
                          Icons.add,
                          color: AppColors.darkBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}