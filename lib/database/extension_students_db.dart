part of 'database_helper.dart';

extension StudentsTableExtension on DatabaseHelper {
  Future<int> insertStudent(Student student) async {
    final db = await database;

    return await db.rawInsert('''
      INSERT INTO $_STUDENTS_TABLE(firstName, lastName, email, phoneNumber, password)
      VALUES ("${student.firstName}", "${student.lastName}", "${student.email}", "${student.phoneNumber}", "${student.password}")
    ''');
  }

  Future<void> deleteStudent({required String email}) async {
    final db = await database;

    await db.rawDelete('''
      DELETE FROM $_STUDENTS_TABLE
      WHERE email = "$email"
    ''');

    await db.rawDelete('''
      DELETE FROM $_COURSES_RECORDS_TABLE
      WHERE studentEmail = "$email"
    ''');
  }

  Future<Student?> getStudent({required String email}) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.rawQuery('SELECT * FROM $_STUDENTS_TABLE WHERE email = "$email"');

    if (result.isEmpty) {
      return null;
    }

    return Student.fromMap(result.first);
  }

  Future<List<Student>> getAllStudents() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.rawQuery('SELECT * FROM $_STUDENTS_TABLE');

    return result.map((res) => Student.fromMap(res)).toList();
  }

  Future<void> updateStudent(Student student) async {
    final db = await database;

    await db.rawUpdate('''
      UPDATE $_STUDENTS_TABLE
      SET firstName = "${student.firstName}", lastName = "${student.lastName}", phoneNumber = "${student.phoneNumber}", password = "${student.password}"
      WHERE email = "${student.email}"
    ''');
  }
}