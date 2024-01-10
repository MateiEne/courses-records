import 'package:db_homework/database/database_helper.dart';
import 'package:db_homework/models/category.dart';
import 'package:db_homework/models/course.dart';
import 'package:db_homework/screens/login.dart';
import 'package:db_homework/screens/profile.dart';
import 'package:db_homework/widgets/add_course.dart';
import 'package:db_homework/widgets/category_item.dart';
import 'package:db_homework/widgets/course_item.dart';
import 'package:flutter/material.dart';

class StudentsCategoriesScreen extends StatefulWidget {
  const StudentsCategoriesScreen({
    Key? key,
    required this.studentEmail,
  }) : super(key: key);

  final String studentEmail;

  @override
  _StudentsCategoriesScreenState createState() => _StudentsCategoriesScreenState();
}

class _StudentsCategoriesScreenState extends State<StudentsCategoriesScreen> {
  final DatabaseHelper db = DatabaseHelper.instance;

  List<Category> categories = [];

  Future<void> initCategories() async {
    List<Category> result = await db.getAllCategoriesForStudent(studentEmail: widget.studentEmail);

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
          'My Categories',
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await initCategories();
        },
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index) {
            return CategoryItemWidget(
              category: categories[index],
              studentEmail: widget.studentEmail,
            );
          },
        ),
      ),
    );
  }
}
