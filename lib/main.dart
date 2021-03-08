import 'package:flutter/material.dart';
import 'package:scientisst_journal/homepage.dart';
import 'package:scientisst_journal/values/app_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'ScientISST Journal',
        theme: ThemeData(
          primarySwatch: AppColors.primaryColor,
        ),
        home: HomePage(),
      );
}
