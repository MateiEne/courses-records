import 'package:db_homework/database/database_helper.dart';
import 'package:db_homework/models/category.dart';
import 'package:db_homework/models/course.dart';
import 'package:db_homework/models/course_record.dart';
import 'package:db_homework/models/teacher.dart';
import 'package:flutter/material.dart';

class CategoryCourses extends StatefulWidget {
  const CategoryCourses({
    super.key,
    required this.category,
    required this.studentEmail,
  });

  final Category category;
  final String studentEmail;

  @override
  State<CategoryCourses> createState() => _CategoryCoursesState();
}

class _CategoryCoursesState extends State<CategoryCourses> {
  List<Course> courses = [];
  List<Teacher> teachers = [];
  List<CourseRecord> enrolledCourses = [];

  double totalHours = 0;

  Future<void> _getCoursesAndTeachers() async {
    DatabaseHelper database = DatabaseHelper.instance;

    final List<Course> result = await database.getAllCourses(
      categoryId: widget.category.id,
    );

    List<Teacher> teachers = [];

    for (Course course in result) {
      final Teacher teacher = await database.getTeacherForCourse(courseId: course.id);

      teachers.add(teacher);
    }

    setState(() {
      courses = result;

      this.teachers = teachers;
    });
  }

  Future<void> _getEnrolledCourses() async {
    DatabaseHelper database = DatabaseHelper.instance;

    final List<CourseRecord> result = await database.getAllCourseRecordsForStudent(
      widget.studentEmail,
    );

    setState(() {
      enrolledCourses = result;
    });
  }

  Future<void> _getTotalHours() async {
    DatabaseHelper database = DatabaseHelper.instance;

    final double result = await database.getTotalDuration(
      studentEmail: widget.studentEmail,
    );

    setState(() {
      totalHours = result;
    });
  }

  Future<void> _enrollStudent(int courseId) async {
    DatabaseHelper database = DatabaseHelper.instance;

    await database.insertOrUpdateCourseRecord(
      grade: 0,
      date: DateTime.now().millisecondsSinceEpoch,
      studentEmail: widget.studentEmail,
      courseId: courseId,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enrolled successfully'),
        ),
      );
    }

    await _getEnrolledCourses();
    await _getTotalHours();
  }

  bool _isEnrolled(int courseId) {
    return enrolledCourses.any((element) => element.courseId == courseId);
  }

  Future<void> _leaveCourse(int courseId) async {
    DatabaseHelper database = DatabaseHelper.instance;

    await database.deleteCourseRecord(
      studentEmail: widget.studentEmail,
      courseId: courseId,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Left successfully'),
        ),
      );
    }

    await _getEnrolledCourses();
    await _getTotalHours();
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getCoursesAndTeachers();
    _getEnrolledCourses();
    _getTotalHours();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
      ),
      body: Column(
        children: [
          Text(
            "Total hours: $totalHours",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 2,
            width: double.infinity,
            color: Colors.white,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: courses.length,
              itemBuilder: (BuildContext context, int index) {
                bool isEnrolled = _isEnrolled(courses[index].id);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(courses[index].title),
                      subtitle: courses[index].description == null
                          ? const SizedBox.shrink()
                          : Text(
                              courses[index].description!,
                            ),
                      trailing: isEnrolled
                          ? ElevatedButton(
                              onPressed: () async {
                                await _leaveCourse(courses[index].id);
                              },
                              child: const Text('Leave'),
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                await _enrollStudent(courses[index].id);
                              },
                              child: const Text('Enroll'),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Text(
                        "Professor: ${teachers[index].firstName} ${teachers[index].lastName}",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 2,
                      width: double.infinity,
                      color: Colors.black,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
