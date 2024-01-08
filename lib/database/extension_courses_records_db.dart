part of 'database_helper.dart';

extension CoursesRecordsTableExtension on DatabaseHelper {

  Future<int> insertCourseRecord(CourseRecord courseRecord) async {
    final db = await database;

    return await db.rawInsert('''
      INSERT INTO $_COURSES_RECORDS_TABLE(grade, studentEmail, courseID)
      VALUES (${courseRecord.grade}, "${courseRecord.studentEmail}", ${courseRecord.courseId})
    ''');
  }

  Future<void> updateCourseRecord(CourseRecord courseRecord) async {
    final db = await database;

    await db.rawUpdate('''
      UPDATE $_COURSES_RECORDS_TABLE
      SET grade = ${courseRecord.grade}, studentEmail = "${courseRecord.studentEmail}", courseID = ${courseRecord.courseId}
      WHERE id = ${courseRecord.id}
    ''');
  }

  Future<int> insertOrUpdateCourseRecord(CourseRecord courseRecord) async {
    final db = await database;

    final List<Map<String, Object?>> result = await db.rawQuery('''
      SELECT * FROM $_COURSES_RECORDS_TABLE
      WHERE id = ${courseRecord.id}
    ''');

    if (result.isNotEmpty) {
      await updateCourseRecord(courseRecord);

      return courseRecord.id;
    }

    return await db.rawInsert('''
      INSERT INTO $_COURSES_RECORDS_TABLE(grade, studentEmail, courseID)
      VALUES (${courseRecord.grade}, "${courseRecord.studentEmail}", ${courseRecord.courseId})
    ''');
  }

  Future<List<CourseRecord>> getAllCourseRecords() async {
    final db = await database;
    final List<Map<String, Object?>> result = await db.rawQuery('SELECT * FROM $_COURSES_RECORDS_TABLE');

    return result.map((res) => CourseRecord.fromMap(res)).toList();
  }

  Future<CourseRecord> getCourseRecord({required int id}) async {
    final db = await database;
    final List<Map<String, Object?>> result = await db.rawQuery('SELECT * FROM $_COURSES_RECORDS_TABLE WHERE id = $id');

    return CourseRecord.fromMap(result.first);
  }
}