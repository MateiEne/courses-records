import 'package:db_homework/database/database_helper.dart';
import 'package:db_homework/models/category.dart';
import 'package:db_homework/models/course.dart';
import 'package:db_homework/screens/login.dart';
import 'package:db_homework/screens/profile.dart';
import 'package:db_homework/screens/students_courses.dart';
import 'package:db_homework/widgets/category_item.dart';
import 'package:flutter/material.dart';

class HomeStudentScreen extends StatefulWidget {
  const HomeStudentScreen({
    Key? key,
    required this.studentEmail,
  }) : super(key: key);

  final String studentEmail;

  @override
  _HomeStudentScreenState createState() => _HomeStudentScreenState();
}

class _HomeStudentScreenState extends State<HomeStudentScreen> {
  final DatabaseHelper db = DatabaseHelper.instance;

  List<Category> categories = [];

  Future<void> initCategories() async {
    List<Category> result = await db.getAllCategories();

    setState(() {
      categories = result;
    });
  }

  @override
  void initState() {
    super.initState();

    initCategories();
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
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.of(context).push(
        //       MaterialPageRoute(
        //         builder: (BuildContext context) {
        //           return ProfileScreen(
        //             email: widget.studentEmail,
        //             isTeacher: false,
        //           );
        //         },
        //       ),
        //     );
        //   },
        //   icon: const Icon(Icons.person),
        // ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Course records',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                Navigator.of(context).pop();

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return ProfileScreen(
                        email: widget.studentEmail,
                        isTeacher: false,
                      );
                    },
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('My Courses'),
              onTap: () {
                Navigator.of(context).pop();

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return StudentsCoursesScreen(studentEmail: widget.studentEmail);
                    },
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const LoginScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return CategoryItemWidget(
            category: categories[index],
            studentEmail: widget.studentEmail,
          );
        },
      ),
    );
  }
}
