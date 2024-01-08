part of 'database_helper.dart';

extension TeachersTableExtension on DatabaseHelper {
  Future<int> insertTeacher(Teacher teacher) async {
    final db = await database;

    return await db.rawInsert('''
      INSERT INTO $_TEACHERS_TABLE(firstName, lastName, email, phoneNumber, password)
      VALUES ("${teacher.firstName}", "${teacher.lastName}", "${teacher.email}", "${teacher.phoneNumber}", "${teacher.password}")
    ''');
  }
}