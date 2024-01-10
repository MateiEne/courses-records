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
}