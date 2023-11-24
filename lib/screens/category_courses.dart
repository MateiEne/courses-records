import 'package:db_homework/models/course.dart';
import 'package:flutter/material.dart';

class CategoryCourses extends StatelessWidget {
  const CategoryCourses({
    super.key,
    required this.courses,
  });

  final List<Course> courses;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
      ),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(courses[index].title),
            subtitle: courses[index].description == null
                ? const SizedBox.shrink()
                : Text(
                    courses[index].description!,
                  ),
          );
        },
      ),
    );
  }
}
