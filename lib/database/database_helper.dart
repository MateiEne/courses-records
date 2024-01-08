import 'dart:async';

import 'package:db_homework/models/category.dart';
import 'package:db_homework/models/course.dart';
import 'package:db_homework/models/course_record.dart';
import 'package:db_homework/models/student.dart';
import 'package:db_homework/models/teacher.dart';
import 'package:sqflite/sqflite.dart';

part 'extension_courses_db.dart';

part 'extension_categories_db.dart';

part 'extension_teachers_db.dart';

part 'extension_students_db.dart';

part 'extension_courses_records_db.dart';

const _DATABASE_NAME = "courses_records.db";

const _CATGORIES_TABLE = "categories";
const _COURSES_TABLE = "courses";
const _STUDENTS_TABLE = "students";
const _TEACHERS_TABLE = "teachers";
const _REGISTRATIONS_TABLE = "registrations";
const _COURSES_RECORDS_TABLE = "courses_records";

class DatabaseHelper {
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

    return await openDatabase(
      databasePath,
      version: 2,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
      onUpgrade: _onUpgrade,
    );
  }

  FutureOr<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion == 1 && newVersion == 2) {
      return await _onUpgradeV1ToV2(db);
    }
  }

  Future<void> _onUpgradeV1ToV2(Database db) async {
    await db.execute('''
      ALTER TABLE $_COURSES_TABLE
      ADD COLUMN price FLOAT NOT NULL DEFAULT 0
    ''');

    await db.execute('''
      ALTER TABLE $_COURSES_RECORDS_TABLE
      ADD COLUMN date INTEGER NOT NULL DEFAULT ${DateTime.now().millisecondsSinceEpoch}
    ''');

    await db.execute('''
      DROP TABLE $_REGISTRATIONS_TABLE
    ''');
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
        price FLOAT NOT NULL,
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

    // Create the courses_records table
    await db.execute('''
      CREATE TABLE $_COURSES_RECORDS_TABLE(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        grade FLOAT NOT NULL,
        date INTEGER NOT NULL,
        studentEmail TEXT NOT NULL,
        courseID INTEGER NOT NULL,
        FOREIGN KEY (studentEmail) REFERENCES $_STUDENTS_TABLE(email),
        FOREIGN KEY (courseID) REFERENCES $_COURSES_TABLE(id)
      )
    ''');
  }
}
