import 'package:db_homework/models/course.dart';
import 'package:db_homework/screens/course_details.dart';
import 'package:db_homework/screens/course_students_attendees.dart';
import 'package:flutter/material.dart';

class CourseItemWidget extends StatelessWidget {
  const CourseItemWidget({
    super.key,
    required this.course,
    this.onTap,
  });

  final Course course;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        title: Text(course.title),
        subtitle: course.description == null
            ? const SizedBox.shrink()
            : Text(
                course.description!,
              ),
      ),
    );
  }
}
