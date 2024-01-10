import 'package:db_homework/database/database_helper.dart';
import 'package:db_homework/models/category.dart';
import 'package:db_homework/models/course.dart';
import 'package:db_homework/screens/login.dart';
import 'package:db_homework/screens/profile.dart';
import 'package:db_homework/widgets/add_course.dart';
import 'package:db_homework/widgets/category_item.dart';
import 'package:db_homework/widgets/course_item.dart';
import 'package:flutter/material.dart';

class StudentsCoursesScreen extends StatefulWidget {
  const StudentsCoursesScreen({
    Key? key,
    required this.studentEmail,
  }) : super(key: key);

  final String studentEmail;

  @override
  _StudentsCoursesScreenState createState() => _StudentsCoursesScreenState();
}

class _StudentsCoursesScreenState extends State<StudentsCoursesScreen> {
  final DatabaseHelper db = DatabaseHelper.instance;

  List<Course> courses = [];

  Future<void> initCourses() async {
    List<Course> result = await db.getAllCoursesFromStudent(studentEmail: widget.studentEmail);

    setState(() {
      courses = result;
    });
  }

  @override
  void initState() {
    super.initState();

    initCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Courses',
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await initCourses();
        },
        child: ListView.builder(
          itemCount: courses.length,
          itemBuilder: (BuildContext context, int index) {
            return CourseItemWidget(
              course: courses[index],
            );
          },
        ),
      ),
    );
  }
}
