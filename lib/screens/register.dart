import 'package:db_homework/database/database_helper.dart';
import 'package:db_homework/models/student.dart';
import 'package:db_homework/models/teacher.dart';
import 'package:db_homework/screens/home_student.dart';
import 'package:db_homework/screens/home_teacher.dart';
import 'package:db_homework/screens/profile.dart';
import 'package:db_homework/widgets/profile_details.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    Key? key,
  }) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Future<void> _insertUser(
    String firstName,
    String lastName,
    String email,
    String phoneNumber,
    String password,
    bool isTeacher,
  ) async {
    DatabaseHelper database = DatabaseHelper.instance;

    if (isTeacher) {
      await database.insertTeacher(
        Teacher(
          firstName: firstName,
          lastName: lastName,
          email: email,
          phoneNumber: phoneNumber,
          password: password,
        ),
      );

      return;
    }

    await database.insertStudent(
      Student(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
      ),
    );
  }

  Future<void> _registerButtonPressed(
    String firstName,
    String lastName,
    String email,
    String phoneNumber,
    String password,
    bool isTeacher,
  ) async {
    await _insertUser(firstName, lastName, email, phoneNumber, password, isTeacher);

    if (context.mounted) {
      Navigator.of(context).pop();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) {
            if (isTeacher) {
              return HomeTeacherScreen(
                teacherEmail: email,
              );
            }

            return const HomeStudentScreen();
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      body: ProfileDetailsWidget(
        onButtonPressed: _registerButtonPressed,
        showTeacherToggle: true,
      ),
    );
  }
}
