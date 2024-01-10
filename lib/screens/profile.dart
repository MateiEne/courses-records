import 'package:db_homework/database/database_helper.dart';
import 'package:db_homework/models/student.dart';
import 'package:db_homework/models/teacher.dart';
import 'package:db_homework/screens/login.dart';
import 'package:db_homework/widgets/profile_details.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.email,
    required this.isTeacher,
  });

  final String email;
  final bool isTeacher;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _onUpdateButtonPressed(
      String firstName, String lastName, String email, String phoneNumber, String password, bool isTeacher) async {
    setState(() {
      _isLoading = true;
    });

    DatabaseHelper database = DatabaseHelper.instance;

    if (isTeacher) {
      await database.updateTeacher(
        Teacher(
          firstName: firstName,
          lastName: lastName,
          email: email,
          phoneNumber: phoneNumber,
          password: password,
        ),
      );
    } else {
      await database.updateStudent(
        Student(
          firstName: firstName,
          lastName: lastName,
          email: email,
          phoneNumber: phoneNumber,
          password: password,
        ),
      );
    }

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;

      _firstName = firstName;
      _lastName = lastName;
      _email = email;
      _phoneNumber = phoneNumber;
      _password = password;
    });
  }

  String? _firstName;
  String? _lastName;
  String? _email;
  String? _phoneNumber;
  String? _password;

  bool _isLoading = false;

  Future<void> _onDelete() async {
    setState(() {
      _isLoading = true;
    });

    DatabaseHelper db = DatabaseHelper.instance;

    await db.deleteStudent(email: widget.email);

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    }).then(
      (value) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return const LoginScreen();
            },
          ),
        );
      },
    );
  }

  Future<void> _getDetails() async {
    setState(() {
      _isLoading = true;
    });

    DatabaseHelper database = DatabaseHelper.instance;

    if (widget.isTeacher) {
      Teacher? teacher = await database.getTeacher(email: widget.email);

      if (teacher == null) {
        return;
      }

      setState(() {
        _firstName = teacher.firstName;
        _lastName = teacher.lastName;
        _email = teacher.email;
        _phoneNumber = teacher.phoneNumber;
        _password = teacher.password;

        _isLoading = false;
      });
    } else {
      Student? student = await database.getStudent(email: widget.email);

      if (student == null) {
        return;
      }

      setState(() {
        _firstName = student.firstName;
        _lastName = student.lastName;
        _email = student.email;
        _phoneNumber = student.phoneNumber;
        _password = student.password;

        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      body: Stack(
        children: [
          Column(
            children: [
              ProfileDetailsWidget(
                key: UniqueKey(),
                onPrimaryButtonPressed: _onUpdateButtonPressed,
                showTeacherToggle: false,
                showEmailField: false,
                primaryButtonText: 'Update',
                firstName: _firstName,
                lastName: _lastName,
                email: _email,
                phoneNumber: _phoneNumber,
                password: _password,
                isTeacher: widget.isTeacher,
              ),
              if (!widget.isTeacher)
                const SizedBox(
                  height: 32,
                ),
              if (!widget.isTeacher)
                ElevatedButton(
                  onPressed: _onDelete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                  child: Text(
                    'Delete',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                ),
            ],
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
