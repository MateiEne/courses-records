part of 'database_helper.dart';

extension TeachersTableExtension on DatabaseHelper {
  Future<int> insertTeacher(Teacher teacher) async {
    final db = await database;

    return await db.rawInsert('''
      INSERT INTO $_TEACHERS_TABLE(firstName, lastName, email, phoneNumber, password)
      VALUES ("${teacher.firstName}", "${teacher.lastName}", "${teacher.email}", "${teacher.phoneNumber}", "${teacher.password}")
    ''');
  }

  Future<Teacher?> getTeacher({required String email}) async {
    final db = await database;
    final List<Map<String, Object?>> result =
        await db.rawQuery('SELECT * FROM $_TEACHERS_TABLE WHERE email = "$email"');

    if (result.isEmpty) {
      return null;
    }

    return Teacher.fromMap(result.first);
  }

  Future<void> updateTeacher(Teacher teacher) async {
    final db = await database;

    await db.rawUpdate('''
      UPDATE $_TEACHERS_TABLE
      SET firstName = "${teacher.firstName}", lastName = "${teacher.lastName}", phoneNumber = "${teacher.phoneNumber}", password = "${teacher.password}"
      WHERE email = "${teacher.email}"
    ''');
  }
}
