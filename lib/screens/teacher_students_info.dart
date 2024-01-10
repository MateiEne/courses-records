import 'package:db_homework/database/database_helper.dart';
import 'package:db_homework/models/student.dart';
import 'package:flutter/material.dart';

class TeacherStudentsInfo extends StatefulWidget {
  const TeacherStudentsInfo({super.key});

  @override
  State<TeacherStudentsInfo> createState() => _TeacherStudentsInfoState();
}

class _TeacherStudentsInfoState extends State<TeacherStudentsInfo> {
  final DatabaseHelper db = DatabaseHelper.instance;

  List<Student> students = [];
  List<Student> notEnrolledStudents = [];
  List<Student> topStudents = [];

  Future<void> initStudents() async {
    List<Student> result = await db.getAllStudents();
    List<Student> notEnrolledStudentsResult = await db.getNotEnrolledStudents();
    List<Student> topStudentsResult = await db.getStudentsWithAverageGradeHigherThanAverage();

    setState(() {
      students = result;
      notEnrolledStudents = notEnrolledStudentsResult;
      topStudents = topStudentsResult;
    });
  }

  @override
  void initState() {
    super.initState();

    initStudents();
  }

  Widget getAllStudents(List<Student> students) {
    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text('${students[index].firstName} ${students[index].lastName}'),
          subtitle: Text(students[index].email),
          trailing: Text(students[index].phoneNumber),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Students Info'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: 'All Students'),
              Tab(text: 'Not Enrolled'),
              Tab(text: 'Top Students'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(
              child: getAllStudents(students),
            ),
            Center(
              child: getAllStudents(notEnrolledStudents),
            ),
            Center(
              child: getAllStudents(topStudents),
            ),
          ],
        ),
      ),
    );
  }
}
