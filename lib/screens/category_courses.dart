import 'package:db_homework/database/database_helper.dart';
import 'package:db_homework/models/category.dart';
import 'package:db_homework/models/course.dart';
import 'package:flutter/material.dart';

class CategoryCourses extends StatefulWidget {
  const CategoryCourses({
    super.key,
    required this.category,
  });

  final Category category;

  @override
  State<CategoryCourses> createState() => _CategoryCoursesState();
}

class _CategoryCoursesState extends State<CategoryCourses> {
  List<Course> courses = [];

  Future<void> _getCourses() async {
    DatabaseHelper database = DatabaseHelper.instance;

    final List<Course> result = await database.getAllCourses(
      categoryId: widget.category.id,
    );

    setState(() {
      courses = result;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getCourses();
  }

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
