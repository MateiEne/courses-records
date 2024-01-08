import 'package:db_homework/screens/register.dart';
import 'package:flutter/material.dart';

class AuthenticationWidget extends StatefulWidget {
  const AuthenticationWidget({
    Key? key,
    required this.onLogin,
    required this.onRegister,
  }) : super(key: key);

  final void Function(String email, String password, bool isTeacher) onLogin;
  final void Function() onRegister;

  @override
  State<AuthenticationWidget> createState() => _AuthenticationWidgetState();
}

class _AuthenticationWidgetState extends State<AuthenticationWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  bool _isTeacher = false;

  final MaterialStateProperty<Icon?> _thumbIcon = MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onSurface,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
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
              onChanged: (text) {
                if (!text.contains('@')) {
                  setState(() {
                    _emailError = 'Please enter a valid email';
                  });
                } else {
                  setState(() {
                    _emailError = null;
                  });
                }
              },
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: 'password',
                hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                    ),
                errorText: _passwordError,
                errorStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.errorContainer,
                    ),
              ),
              obscureText: true,
              onChanged: (text) {
                if (text.isNotEmpty) {
                  _passwordError = null;
                }
              },
            ),
            const SizedBox(
              height: 8,
            ),
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
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    if (_emailController.text.trim().isEmpty) {
                      setState(() {
                        _emailError = 'Please enter an email!';
                      });

                      return;
                    }

                    if (_passwordController.text.trim().isEmpty) {
                      setState(() {
                        _passwordError = 'Please enter your password!';
                      });

                      return;
                    }

                    widget.onLogin(_emailController.text.trim(), _passwordController.text.trim(), _isTeacher);
                  },
                  child: Text(
                    'Login',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                  ),
                ),
                TextButton(
                  onPressed: widget.onRegister,
                  child: Text(
                    'Register',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
