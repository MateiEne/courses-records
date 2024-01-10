part of 'database_helper.dart';

extension SimpleQueriesExtension on DatabaseHelper {
  Future<List<Student>> getAllStudentsFromCourse({required int courseId}) async {
    final db = await database;

    final List<Student> students = await db.rawQuery('''
      SELECT S.email, S.firstName, S.lastName, S.phoneNumber FROM $_STUDENTS_TABLE S
      INNER JOIN $_COURSES_RECORDS_TABLE CR ON S.email = CR.studentEmail
      WHERE CR.courseID = $courseId
    ''').then((value) => value.map((e) => Student.fromMap(e)).toList());

    return students;
  }

  Future<List<Course>> getAllCoursesFromStudent({required String studentEmail}) async {
    final db = await database;

    final List<Course> courses = await db.rawQuery('''
      SELECT C.id, C.title, C.description, C.date, C.duration, C.price, C.categoryID, C.teacherEmail FROM $_COURSES_TABLE C
      INNER JOIN $_COURSES_RECORDS_TABLE CR ON C.id = CR.courseID
      WHERE CR.studentEmail = "$studentEmail"
    ''').then((value) => value.map((e) => Course.fromMap(e)).toList());

    return courses;
  }

  Future<double> getTotalDuration({required String studentEmail}) async {
    final db = await database;

    final List<Map<String, Object?>> result = await db.rawQuery('''
      SELECT SUM(C.duration) as totalDuration FROM $_COURSES_TABLE C
      INNER JOIN $_COURSES_RECORDS_TABLE CR ON C.id = CR.courseID
      WHERE CR.studentEmail = "$studentEmail"
    ''');

    return result.first['totalDuration'] as double;
  }

  Future<double> getTotalPrice({required String studentEmail}) async {
    final db = await database;

    final List<Map<String, Object?>> result = await db.rawQuery('''
      SELECT SUM(C.price) as totalPrice FROM $_COURSES_TABLE C
      INNER JOIN $_COURSES_RECORDS_TABLE CR ON C.id = CR.courseID
      WHERE CR.studentEmail = "$studentEmail"
    ''');

    return result.first['totalPrice'] as double;
  }

  Future<List<Teacher>> getAllTeachersFromCategory({required int categoryId}) async {
    final db = await database;

    final List<Teacher> teachers = await db.rawQuery('''
      SELECT T.email, T.firstName, T.lastName, T.phoneNumber FROM $_TEACHERS_TABLE T
      INNER JOIN $_COURSES_TABLE C ON T.email = C.teacherEmail
      WHERE C.categoryID = $categoryId
    ''').then((value) => value.map((e) => Teacher.fromMap(e)).toList());

    return teachers;
  }

  Future<Teacher> getTeacherForCourse({required int courseId}) async {
    final db = await database;

    final List<Teacher> teachers = await db.rawQuery('''
      SELECT T.email, T.firstName, T.lastName, T.phoneNumber FROM $_TEACHERS_TABLE T
      INNER JOIN $_COURSES_TABLE C ON T.email = C.teacherEmail
      WHERE C.id = $courseId
    ''').then((value) => value.map((e) => Teacher.fromMap(e)).toList());

    return teachers.first;
  }
}