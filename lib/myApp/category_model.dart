import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'activity/activities_list.dart';

class CategoryModel extends ChangeNotifier {
  List<String> _categories = ['Работа', 'Учёба', 'Спорт'];
  late BuildContext _context;

  List<String> get categories => _categories;

  void initialize(BuildContext context) {
    _context = context;
  }

  void addCategory(String category) {
    _categories.insert(0, category);
    notifyListeners();
  }

  void removeCategory(int index) {
    String removedCategory = _categories.removeAt(index);
    notifyListeners();
    Provider.of<ActivityListState>(_context, listen: false).replaceCategory(removedCategory);
  }

  void updateCategory(int index, String newCategory) {
    String oldCategory = _categories[index];
    _categories[index] = newCategory;
    notifyListeners();
    Provider.of<ActivityListState>(_context, listen: false).replaceCategory(oldCategory);
  }

  void setCategories(List<String> categories) {
    _categories = categories;
    notifyListeners();
  }
}