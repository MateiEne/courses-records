import 'package:flutter/material.dart';

class CourseItemWidget extends StatelessWidget {
  const CourseItemWidget({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: description == null
          ? const SizedBox.shrink()
          : Text(
              description!,
            ),
    );
  }
}
