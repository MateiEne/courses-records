import 'package:db_homework/data_base/data_base_helper.dart';
import 'package:db_homework/models/course.dart';
import 'package:db_homework/screens/home.dart';
import 'package:db_homework/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 131, 57, 0),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DatabaseHelper db = DatabaseHelper.instance;

  Course course = Course(
    id: 0,
    title: 'title',
    description: 'description',
    date: DateTime
        .now()
        .microsecondsSinceEpoch,
    duration: 2,
  );

  await db.insertCourse(course, 0, 0);

  runApp(const App());
}

class App extends StatelessWidget {
  const App

  ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: const LoginScreen(),
    );
  }
}
