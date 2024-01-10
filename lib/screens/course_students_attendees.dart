import 'package:db_homework/database/database_helper.dart';
import 'package:db_homework/models/course.dart';
import 'package:db_homework/models/student.dart';
import 'package:db_homework/screens/course_details.dart';
import 'package:flutter/material.dart';

class CourseStudentsAttendeesScreen extends StatefulWidget {
  const CourseStudentsAttendeesScreen({
    super.key,
    required this.course,
  });

  final Course course;

  @override
  State<CourseStudentsAttendeesScreen> createState() => _CourseStudentsAttendeesScreenState();
}

class _CourseStudentsAttendeesScreenState extends State<CourseStudentsAttendeesScreen> {
  final DatabaseHelper db = DatabaseHelper.instance;

  List<Student> students = [];

  Future<void> initStudents() async {
    List<Student> result = await db.getAllStudentsFromCourse(courseId: widget.course.id);
    setState(() {
      students = result;
    });
  }

  @override
  void initState() {
    super.initState();

    initStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.course.title,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return CourseDetailsScreen(
                      course: widget.course,
                    );
                  },
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.course.description ?? 'no description for this course',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
          Container(
            height: 2,
            width: double.infinity,
            color: Colors.white,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(students[index].firstName + ' ' + students[index].lastName),
                  subtitle: Text(students[index].email),
                  trailing: Text(students[index].phoneNumber),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
