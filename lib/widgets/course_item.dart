import 'package:db_homework/models/course.dart';
import 'package:db_homework/screens/course_details.dart';
import 'package:db_homework/screens/course_students_attendees.dart';
import 'package:flutter/material.dart';

class CourseItemWidget extends StatelessWidget {
  const CourseItemWidget({
    super.key,
    required this.course,
  });

  final Course course;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (context.mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return CourseStudentsAttendeesScreen(
                  course: course,
                );
              },
            ),
          );
        }
      },
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
