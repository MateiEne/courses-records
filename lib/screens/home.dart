import 'package:db_homework/data_base/data_base_helper.dart';
import 'package:db_homework/models/category.dart';
import 'package:db_homework/models/course.dart';
import 'package:db_homework/screens/login.dart';
import 'package:db_homework/widgets/category_item.dart';
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
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return CategoryItemWidget(category: categories[index]);
        },
      ),
    );
  }
}
