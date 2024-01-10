part of 'database_helper.dart';

extension CoursesRecordsTableExtension on DatabaseHelper {
  Future<int> insertCourseRecord({
    required double grade,
    required int date,
    required String studentEmail,
    required int courseId,
  }) async {
    final db = await database;

    return await db.rawInsert('''
      INSERT INTO $_COURSES_RECORDS_TABLE(grade, date, studentEmail, courseID)
      VALUES ($grade, $date, "$studentEmail", $courseId)
    ''');
  }

  Future<void> updateCourseRecord(CourseRecord courseRecord) async {
    final db = await database;

    await db.rawUpdate('''
      UPDATE $_COURSES_RECORDS_TABLE
      SET grade = ${courseRecord.grade}, date = ${courseRecord.date}, studentEmail = "${courseRecord.studentEmail}", courseID = ${courseRecord.courseId}
      WHERE id = ${courseRecord.id}
    ''');
  }

  Future<int> insertOrUpdateCourseRecord({
    required double grade,
    required int date,
    required String studentEmail,
    required int courseId,
  }) async {
    final db = await database;

    final List<Map<String, Object?>> result = await db.rawQuery('''
      SELECT * FROM $_COURSES_RECORDS_TABLE
      WHERE studentEmail = "$studentEmail" AND courseID = $courseId
    ''');

    if (result.isNotEmpty) {
      final courseRecord = result.map((res) => CourseRecord.fromMap(res)).first;
      await updateCourseRecord(
        CourseRecord(
          id: courseRecord.id,
          grade: grade,
          date: date,
          studentEmail: studentEmail,
          courseId: courseId,
        ),
      );

      return courseRecord.id;
    }

    return await db.rawInsert('''
      INSERT INTO $_COURSES_RECORDS_TABLE(grade, date, studentEmail, courseID)
      VALUES ($grade, $date, "$studentEmail", $courseId)
    ''');
  }

  Future<List<CourseRecord>> getAllCourseRecords() async {
    final db = await database;
    final List<Map<String, Object?>> result = await db.rawQuery('SELECT * FROM $_COURSES_RECORDS_TABLE');

    return result.map((res) => CourseRecord.fromMap(res)).toList();
  }

  Future<List<CourseRecord>> getAllCourseRecordsForStudent(String studentEmail) async {
    final db = await database;
    final List<Map<String, Object?>> result = await db.rawQuery('SELECT * FROM $_COURSES_RECORDS_TABLE WHERE studentEmail = "$studentEmail"');

    return result.map((res) => CourseRecord.fromMap(res)).toList();
  }

  Future<CourseRecord> getCourseRecord({required int id}) async {
    final db = await database;
    final List<Map<String, Object?>> result = await db.rawQuery('SELECT * FROM $_COURSES_RECORDS_TABLE WHERE id = $id');

    return CourseRecord.fromMap(result.first);
  }

  Future<bool> isStudentEnrolled({required String studentEmail, required int courseId}) async {
    final db = await database;

    final List<Map<String, Object?>> result = await db.rawQuery('''
      SELECT * FROM $_COURSES_RECORDS_TABLE
      WHERE studentEmail = "$studentEmail" AND courseID = $courseId
    ''');

    return result.isNotEmpty;
  }

  Future<void> deleteCourseRecord({required String studentEmail, required int courseId}) async {
    final db = await database;

    await db.rawDelete('''
      DELETE FROM $_COURSES_RECORDS_TABLE
      WHERE studentEmail = "$studentEmail" AND courseID = $courseId
    ''');
  }
}
