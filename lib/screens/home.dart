import 'package:db_homework/data_base/data_base_helper.dart';
import 'package:db_homework/models/course.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper db = DatabaseHelper.instance;

  List<Course> courses = [];

  Future<void> initCourses() async {
    List<Course> result = await db.getAllCourses();

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
          'Tema Baze de date',
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(courses[index].title),
            subtitle: Text(
              courses[index].description ?? '',
            ),
          );
        },
      ),
    );
  }
}
