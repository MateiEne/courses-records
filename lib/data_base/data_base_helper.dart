import 'dart:async';

import 'package:db_homework/models/category.dart';
import 'package:db_homework/models/course.dart';
import 'package:db_homework/models/student.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _DATABASE_NAME = "courses_records.db";

  static const _CATGORIES_TABLE = "categories";
  static const _COURSES_TABLE = "courses";
  static const _STUDENTS_TABLE = "students";
  static const _TEACHERS_TABLE = "teachers";
  static const _REGISTRATIONS_TABLE = "registrations";
  static const _COURSES_RECORDS_TABLE = "courses_records";

  DatabaseHelper._privateConstrucor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstrucor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/$_DATABASE_NAME';

    return await openDatabase(databasePath, version: 1, onCreate: _onCreate, onConfigure: _onConfigure);
  }

  FutureOr<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create the categories table
    await db.execute('''
      CREATE TABLE $_CATGORIES_TABLE(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        coursesNumber INTEGER,
        maxStudentsNumber INTEGER,
        imageUrl TEXT NOT NULL
      )
    ''');

    // Create the teachers table
    await db.execute('''
      CREATE TABLE $_TEACHERS_TABLE(
        email TEXT NOT NULL PRIMARY KEY,
        firstName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        phoneNumber TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    // Create the courses table
    await db.execute('''
      CREATE TABLE $_COURSES_TABLE(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        date INTEGER NOT NULL,
        duration FLOAT NOT NULL,
        categoryID INTEGER NOT NULL,
        teacherEmail TEXT NOT NULL,
        FOREIGN KEY (categoryID) REFERENCES $_CATGORIES_TABLE(id),
        FOREIGN KEY (teacherEmail) REFERENCES $_TEACHERS_TABLE(email)
      )
    ''');

    // Create the students table
    await db.execute('''
      CREATE TABLE $_STUDENTS_TABLE(
        email TEXT NOT NULL PRIMARY KEY,
        firstName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        phoneNumber TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    // Create the registrations table
    await db.execute('''
      CREATE TABLE $_REGISTRATIONS_TABLE(
        id INTEGER PRIMARY KEY,
        date INTEGER NOT NULL,
        price FLOAT NOT NULL,
        studentEmail TEXT NOT NULL,
        FOREIGN KEY (studentEmail) REFERENCES $_STUDENTS_TABLE(email)
      )
    ''');

    // Create the courses_records table
    await db.execute('''
      CREATE TABLE $_COURSES_RECORDS_TABLE(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        grade FLOAT NOT NULL,
        studentEmail TEXT NOT NULL,
        courseID INTEGER NOT NULL,
        FOREIGN KEY (studentEmail) REFERENCES $_STUDENTS_TABLE(email),
        FOREIGN KEY (courseID) REFERENCES $_COURSES_TABLE(id)
      )
    ''');
  }

  Future<int> insertStudent(Student student) async {
    final db = await database;

    return await db.rawInsert('''
      INSERT INTO $_STUDENTS_TABLE(firstName, lastName, email, phoneNumber, password)
      VALUES ("${student.firstName}", "${student.lastName}", "${student.email}", "${student.phoneNumber}", "${student.password}")
    ''');
  }

  Future<int> insertCourse(Course course, int categoryID, String teacherEmail) async {
    final db = await database;

    final List<Map<String, Object?>> result = await db.rawQuery('''
      SELECT * FROM $_COURSES_TABLE
      WHERE id = ${course.id}
    ''');

    if (result.isNotEmpty) {
      // TODO: update the db with the new value
      return 0;
    }

    return await db.rawInsert('''
      INSERT INTO $_COURSES_TABLE(title, description, date, duration, categoryID, teacherEmail)
      VALUES ("${course.title}", "${course.description}", ${course.date}, ${course.duration}, $categoryID, "$teacherEmail")
    ''');
  }

  Future<Category?> getCategory({required int id}) async {
    final db = await database;
    final List<Map<String, Object?>> result = await db.rawQuery('SELECT * FROM $_CATGORIES_TABLE WHERE id = $id');

    if (result.isEmpty) {
      return null;
    }

    return Category.fromMap(result.first);
  }

  Future<List<Category>> getAllCategories() async {
    final db = await database;
    final List<Map<String, Object?>> result = await db.rawQuery('SELECT * FROM $_CATGORIES_TABLE');

    return result.map((res) => Category.fromMap(res)).toList();
  }

/*  Future<List<Course>> getAllCourses() async {
    final db = await database;

    List<Map<String, dynamic>> result = await db.rawQuery('SELECT * FROM $_COURSES_TABLE');

    return result.map((courseMap) => Course.fromMap(courseMap)).toList();
  }*/

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

  Future<List<Course>> getAllCourses({required int categoryId}) async {
    final db = await database;

    final List<Map<String, Object?>> result = await db.rawQuery('SELECT * FROM $_COURSES_TABLE WHERE categoryID = $categoryId');

    return result.map((res) => Course.fromMap(res)).toList();
  }
}
