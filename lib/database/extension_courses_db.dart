part of 'database_helper.dart';

extension CoursesTableExtension on DatabaseHelper {
  Future<int> insertCourse(Course course) async {
    final db = await database;

    return await db.rawInsert('''
      INSERT INTO $_COURSES_TABLE(title, description, date, duration, categoryID, teacherEmail)
      VALUES ("${course.title}", "${course.description}", ${course.date}, ${course.duration}, ${course.categoryId}, "${course.teacherEmail}")
    ''');
  }

  Future<int> insertOrUpdateCourse(Course course) async {
    final db = await database;

    final List<Map<String, Object?>> result = await db.rawQuery('''
      SELECT * FROM $_COURSES_TABLE
      WHERE id = ${course.id}
    ''');

    if (result.isNotEmpty) {
      await updateCourse(course);

      return course.id;
    }

    return await db.rawInsert('''
      INSERT INTO $_COURSES_TABLE(title, description, date, duration, categoryID, teacherEmail)
      VALUES ("${course.title}", "${course.description}", ${course.date}, ${course.duration}, ${course.categoryId}, "${course.teacherEmail}")
    ''');
  }

  Future<void> deleteCourse({required int id}) async {
    final db = await database;

    await db.rawDelete('''
      DELETE FROM $_COURSES_TABLE
      WHERE id = $id
    ''');

    await db.rawDelete('''
      DELETE FROM $_COURSES_RECORDS_TABLE
      WHERE courseID = $id
    ''');
  }

  Future<void> updateCourse(Course course) async {
    final db = await database;

    await db.rawUpdate('''
      UPDATE $_COURSES_TABLE
      SET title = "${course.title}", description = "${course.description}", date = ${course.date}, duration = ${course.duration}, categoryID = ${course.categoryId}, teacherEmail = "${course.teacherEmail}
      WHERE id = ${course.id}
    ''');
  }

  Future<List<Course>> getAllCourses({required int categoryId}) async {
    final db = await database;

    final List<Map<String, Object?>> result = await db.rawQuery('SELECT * FROM $_COURSES_TABLE WHERE categoryID = $categoryId');

    return result.map((res) => Course.fromMap(res)).toList();
  }

/*  Future<List<Course>> getAllCourses() async {
    final db = await database;

    List<Map<String, dynamic>> result = await db.rawQuery('SELECT * FROM $_COURSES_TABLE');

    return result.map((courseMap) => Course.fromMap(courseMap)).toList();
  }*/
}