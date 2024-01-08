import 'package:db_homework/database/database_helper.dart';
import 'package:db_homework/models/category.dart';
import 'package:db_homework/models/course.dart';
import 'package:db_homework/screens/login.dart';
import 'package:db_homework/widgets/add_course.dart';
import 'package:db_homework/widgets/category_item.dart';
import 'package:db_homework/widgets/course_item.dart';
import 'package:flutter/material.dart';

class HomeTeacherScreen extends StatefulWidget {
  const HomeTeacherScreen({
    Key? key,
    required this.teacherEmail,
  }) : super(key: key);

  final String teacherEmail;

  @override
  _HomeTeacherScreenState createState() => _HomeTeacherScreenState();
}

class _HomeTeacherScreenState extends State<HomeTeacherScreen> {
  final DatabaseHelper db = DatabaseHelper.instance;

  List<Course> courses = [];

  Future<void> initCourses() async {
    List<Course> result = await db.getAllCoursesForTeacher(teacherEmail: widget.teacherEmail);

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
          'Course records',
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const LoginScreen();
                    },
                  ),
                );
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await initCourses();
        },
        child: ListView.builder(
          itemCount: courses.length,
          itemBuilder: (BuildContext context, int index) {
            return CourseItemWidget(
              title: courses[index].title,
              description: courses[index].description,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => SingleChildScrollView(
              child: AddCourseWidget(
                teacherEmail: widget.teacherEmail,
              ),
            ),
          ).then((value) {
            initCourses();
          });
        },
      ),
    );
  }
}