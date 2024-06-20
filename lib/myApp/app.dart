import 'package:first_flutter_app/myApp/screen_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'category_model.dart';


class TimeTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<CategoryModel>(context, listen: false).initialize(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ScreenManager(),
    );
  }
}