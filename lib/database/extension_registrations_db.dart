part of 'database_helper.dart';

extension RegistrationTableExtension on DatabaseHelper {
  Future<int> insertRegistration(Registration registration) async {
    final db = await database;

    return await db.rawInsert('''
      INSERT INTO $_REGISTRATIONS_TABLE(date, price, studentEmail)
      VALUES (${registration.date}, ${registration.price}, "${registration.studentEmail}")
    ''');
  }

  Future<void> updateRegistration(Registration registration) async {
    final db = await database;

    await db.rawUpdate('''
      UPDATE $_REGISTRATIONS_TABLE
      SET date = ${registration.date}, price = ${registration.price}, studentEmail = "${registration.studentEmail}"
      WHERE id = ${registration.id}
    ''');
  }

  Future<int> insertOrUpdateRegistration(Registration registration) async {
    final db = await database;

    final List<Map<String, Object?>> result = await db.rawQuery('''
      SELECT * FROM $_REGISTRATIONS_TABLE
      WHERE id = ${registration.id}
    ''');

    if (result.isNotEmpty) {
      await updateRegistration(registration);

      return registration.id;
    }

    return await db.rawInsert('''
      INSERT INTO $_REGISTRATIONS_TABLE(date, price, studentEmail)
      VALUES (${registration.date}, ${registration.price}, "${registration.studentEmail}")
    ''');
  }
}