part of 'database_helper.dart';

extension ComlexQueriesExtension on DatabaseHelper {
  Future<List<Student>> getAllStudentsEnrolledInAllCoursesFromCategory({required int categoryId}) async {
    final db = await database;
    // final List<Map<String, Object?>> result = await db.rawQuery('''
    //   SELECT * FROM $_STUDENTS_TABLE
    //   WHERE email IN (
    //     SELECT studentEmail FROM $_COURSES_RECORDS_TABLE
    //     WHERE courseID IN (
    //       SELECT id FROM $_COURSES_TABLE
    //       WHERE categoryID = $categoryId
    //     )
    //   )
    // ''');

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
}