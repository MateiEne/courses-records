import 'package:db_homework/database/database_helper.dart';
import 'package:db_homework/models/student.dart';
import 'package:db_homework/models/teacher.dart';
import 'package:flutter/material.dart';

class ProfileDetailsWidget extends StatefulWidget {
  const ProfileDetailsWidget({
    super.key,
    required this.onButtonPressed,
    this.showTeacherToggle = false,
  });

  final bool showTeacherToggle;

  final Function(
    String firstName,
    String lastName,
    String email,
    String phoneNumber,
    String password,
    bool isTeacher,
  ) onButtonPressed;

  @override
  State<ProfileDetailsWidget> createState() => _ProfileDetailsWidgetState();
}

class _ProfileDetailsWidgetState extends State<ProfileDetailsWidget> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _emailError;
  String? _confirmPasswordError;
  String? _allFieldsCompletedError;

  bool _isTeacher = false;

  final MaterialStateProperty<Icon?> _thumbIcon = MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  Future<bool> _isEmailInDatabase(String email) async {
    final DatabaseHelper database = DatabaseHelper.instance;

    if (_isTeacher) {
      Teacher? teacher = await database.getTeacher(email: email);
      debugPrint('teacher = ${teacher?.email}');

      return teacher != null;
    }

    Student? student = await database.getStudent(email: email);
    debugPrint('student = ${student?.email}');

    return student != null;
  }

  Future<void> _registerButtonPressed() async {
    if (await _isValidRegistration()) {
      widget.onButtonPressed(
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
        _emailController.text.trim(),
        _phoneNumberController.text.trim(),
        _passwordController.text.trim(),
        _isTeacher,
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  Future<bool> _isValidRegistration() async {
    if (_firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _phoneNumberController.text.trim().isEmpty ||
        _usernameController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _confirmPasswordController.text.trim().isEmpty) {
      setState(() {
        _allFieldsCompletedError = 'Please complete all the fields!';
      });

      return false;
    }

    if (_emailError != null) {
      setState(() {
        _allFieldsCompletedError = null;
      });

      return false;
    }

    bool emailExists = await _isEmailInDatabase(_emailController.text.trim());
    debugPrint('emailExits = $emailExists');
    if (emailExists) {
      setState(() {
        _emailError = 'email already exists!';
      });

      return false;
    }

    if (_confirmPasswordError != null) {
      setState(() {
        _allFieldsCompletedError = null;
      });

      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      hintText: 'First name',
                      hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).colorScheme.secondaryContainer,
                          ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: TextField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      hintText: 'Last name',
                      hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).colorScheme.secondaryContainer,
                          ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'email',
                      hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).colorScheme.secondaryContainer,
                          ),
                      errorText: _emailError,
                      errorStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).colorScheme.errorContainer,
                          ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (text) {
                      if (!text.contains('@')) {
                        setState(() {
                          _emailError = 'Please enter a valid email!';
                        });
                      } else {
                        setState(() {
                          _emailError = null;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      hintText: 'Phone number',
                      hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).colorScheme.secondaryContainer,
                          ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: 'Username',
                hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                    ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                    ),
              ),
              obscureText: true,
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                hintText: 'Confirm password',
                hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                    ),
                errorText: _confirmPasswordError,
                errorStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.errorContainer,
                    ),
              ),
              obscureText: true,
              onChanged: (text) {
                if (_confirmPasswordController.text != _passwordController.text) {
                  setState(() {
                    _confirmPasswordError = 'Passwords do not match!';
                  });
                } else {
                  setState(() {
                    _confirmPasswordError = null;
                  });
                }
              },
            ),
            const SizedBox(
              height: 8,
            ),
            if (widget.showTeacherToggle)
              Row(
                children: [
                  const Text('Teacher'),
                  const SizedBox(
                    width: 8,
                  ),
                  Switch(
                    value: _isTeacher,
                    thumbIcon: _thumbIcon,
                    onChanged: (bool value) {
                      setState(() {
                        _isTeacher = value;
                      });
                    },
                  ),
                ],
              ),
            if (widget.showTeacherToggle)
              const SizedBox(
                height: 8,
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _allFieldsCompletedError == null
                    ? const Expanded(
                        child: SizedBox.shrink(),
                      )
                    : Expanded(
                        child: Text(
                          _allFieldsCompletedError!,
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                color: Theme.of(context).colorScheme.errorContainer,
                              ),
                        ),
                      ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _registerButtonPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                    ),
                    child: Text(
                      'Register',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
