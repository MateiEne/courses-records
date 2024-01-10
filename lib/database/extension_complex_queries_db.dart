part of 'database_helper.dart';

extension ComlexQueriesExtension on DatabaseHelper {
  Future<List<Student>> getAllStudentsEnrolledInAllCoursesFromCategory({required int categoryId}) async {
    final db = await database;

    final List<Map<String, Object?>> result = await db.rawQuery('''
      SELECT * FROM $_STUDENTS_TABLE S
      WHERE
            (SELECT COUNT(DISTINCT C.id)
            FROM $_COURSES_RECORDS_TABLE CR, $_COURSES_TABLE C
            WHERE CR.studentEmail = S.email AND C.categoryID = $categoryId AND C.id = CR.courseID)
            =
            (SELECT COUNT(DISTINCT C.id) FROM $_COURSES_TABLE C
            WHERE C.categoryID = $categoryId)
    ''');

    return result.map((res) => Student.fromMap(res)).toList();
  }

  Future<List<Student>> getNotEnrolledStudents() async {
    final db = await database;

    final List<Map<String, Object?>> result = await db.rawQuery('''
      SELECT * FROM $_STUDENTS_TABLE S
      WHERE S.email NOT IN 
            (SELECT DISTINCT S2.email
            FROM $_STUDENTS_TABLE S2, $_COURSES_RECORDS_TABLE CR
            WHERE S2.email = CR.studentEmail)
    ''');

    return result.map((res) => Student.fromMap(res)).toList();
  }

  Future<List<Student>> getStudentsWithAverageGradeHigherThanAverage() async {
    final db = await database;

    final List<Map<String, Object?>> result = await db.rawQuery('''
      SELECT * FROM $_STUDENTS_TABLE S
      WHERE
            (SELECT AVG(CR.grade) FROM $_COURSES_RECORDS_TABLE CR 
            WHERE CR.grade > 0 AND CR.studentEmail = S.email)
            >
            (SELECT AVG(CR.grade) FROM $_COURSES_RECORDS_TABLE CR 
            WHERE CR.grade > 0)
    ''');

    return result.map((res) => Student.fromMap(res)).toList();
  }
}