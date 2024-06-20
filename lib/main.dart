import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'myApp/app.dart';
import 'myApp/category_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CategoryModel()),
      ],
      child: TimeTracker(),
    ),
  );
}