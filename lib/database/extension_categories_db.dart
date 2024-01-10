part of 'database_helper.dart';

extension CategoriesTableExtension on DatabaseHelper {
  Future<int> insertCategory(Category category) async {
    final db = await database;

    return await db.rawInsert('''
      INSERT INTO $_CATEGORIES_TABLE(title, description, coursesNumber, maxStudentsNumber, imageUrl)
      VALUES ("${category.title}", "${category.description}", ${category.coursesNumber}, ${category.maxStudentsNumber}, "${category.imageUrl}")
    ''');
  }

  Future<void> updateCategory(Category category) async {
    final db = await database;

    await db.rawUpdate('''
      UPDATE $_CATEGORIES_TABLE
      SET title = "${category.title}", description = "${category.description}", coursesNumber = ${category.coursesNumber}, maxStudentsNumber = ${category.maxStudentsNumber}, imageUrl = "${category.imageUrl}"
      WHERE id = ${category.id}
    ''');
  }

  Future<int> insertOrUpdateCategory(Category category) async {
    final db = await database;

    final List<Map<String, Object?>> result = await db.rawQuery('''
      SELECT * FROM $_CATEGORIES_TABLE
      WHERE id = ${category.id}
    ''');

    if (result.isNotEmpty) {
      await updateCategory(category);

      return category.id;
    }

    return await db.rawInsert('''
      INSERT INTO $_CATEGORIES_TABLE(title, description, coursesNumber, maxStudentsNumber, imageUrl)
      VALUES ("${category.title}", "${category.description}", ${category.coursesNumber}, ${category.maxStudentsNumber}, "${category.imageUrl}")
    ''');
  }

  Future<Category?> getCategory({required int id}) async {
    final db = await database;
    final List<Map<String, Object?>> result = await db.rawQuery('SELECT * FROM $_CATEGORIES_TABLE WHERE id = $id');

    if (result.isEmpty) {
      return null;
    }

    return Category.fromMap(result.first);
  }

  Future<List<Category>> getAllCategories() async {
    final db = await database;
    final List<Map<String, Object?>> result = await db.rawQuery('SELECT * FROM $_CATEGORIES_TABLE');

    return result.map((res) => Category.fromMap(res)).toList();
  }
}