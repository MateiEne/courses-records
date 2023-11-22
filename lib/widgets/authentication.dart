import 'package:db_homework/screens/register.dart';
import 'package:flutter/material.dart';

class AuthenticationWidget extends StatelessWidget {
  const AuthenticationWidget({
    Key? key,
    required this.onLogin,
    required this.onRegister,
  }) : super(key: key);

  final void Function() onLogin;
  final void Function() onRegister;

  @override
  Widget build(BuildContext context) {
    final TextEditingController _userNameController = TextEditingController();
    final TextEditingController _userPassword = TextEditingController();

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
              controller: _userNameController,
              decoration: InputDecoration(
                hintText: 'username',
                hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                    ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              controller: _userPassword,
              decoration: InputDecoration(
                hintText: 'password',
                hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                    ),
              ),
              obscureText: true,
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: onLogin,
                  child: Text(
                    'Login',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                  ),
                ),
                TextButton(
                  onPressed: onRegister,
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
