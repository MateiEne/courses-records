import 'package:db_homework/database/database_helper.dart';
import 'package:db_homework/models/student.dart';
import 'package:db_homework/models/teacher.dart';
import 'package:db_homework/screens/home_student.dart';
import 'package:db_homework/screens/home_teacher.dart';
import 'package:db_homework/screens/register.dart';
import 'package:db_homework/widgets/authentication.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<void> _loginTeacher(String email, String password) async {
    final DatabaseHelper database = DatabaseHelper.instance;
    Teacher? teacher = await database.getTeacher(email: email);

    if (!context.mounted) {
      return;
    }

    if (teacher == null) {
      ScaffoldMessenger.of(context).clearSnackBars();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'User not found!',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
        ),
      );

      return;
    }

    if (teacher.password != password) {
      ScaffoldMessenger.of(context).clearSnackBars();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Invalid password!',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
        ),
      );

      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return HomeTeacherScreen(teacherEmail: teacher.email);
        },
      ),
    );
  }

  Future<void> _loginStudent(String email, String password) async {
    final DatabaseHelper database = DatabaseHelper.instance;
    Student? student = await database.getStudent(email: email);

    if (!context.mounted) {
      return;
    }

    if (student == null) {
      ScaffoldMessenger.of(context).clearSnackBars();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'User not found!',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
        ),
      );

      return;
    }

    if (student.password != password) {
      ScaffoldMessenger.of(context).clearSnackBars();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Invalid password!',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
        ),
      );

      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const HomeStudentScreen();
        },
      ),
    );
  }

  void _onLogin(String email, String password, bool isTeacher) async {
    if (isTeacher) {
      await _loginTeacher(email, password);
    } else {
      await _loginStudent(email, password);
    }
  }

  void _onRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const RegisterScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tema Baze de date',
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            textAlign: TextAlign.center,
            'Welcome to our app! Please login!',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
          Text(
            'If you do not have an account, please register!',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 50,
          ),
          AuthenticationWidget(
            onLogin: _onLogin,
            onRegister: _onRegister,
          ),
        ],
      ),
    );
  }
}
