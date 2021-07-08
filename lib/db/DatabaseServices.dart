
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:TaskRemainder/db/ScheduleEntity.dart';



// database table and column names
final String tableWords = 'tasks';
final String columnId = 'id';
final String columntitle = 'title';
final String columndescription = 'description';
final String columndate = 'date';
final String columntime = 'time';
final String columnalarm_req_code = 'alarm_req_code';

class DatabaseServices {

  static final DatabaseServices _instance = DatabaseServices._internal();
  late Future<Database> database;

  factory DatabaseServices() {
    return _instance;
  }

  DatabaseServices._internal() {
    initDatabase();
  }

  initDatabase() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'taskschedule_database.db'),


      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT,description TEXT,date TEXT,time TEXT ,alarm_req_code INTEGER)",
        );
      },

      version: 1,
    );

  }


  // Database helper methods:

  Future<int> insert(ScheduleEntity scheduleEntity) async {
    print("dbinsert");
    Database db = await database;
    int id = await db.insert('tasks', scheduleEntity.toMap());
    return id;
  }

  Future<List<ScheduleEntity>> getalltasks() async {
    // Get a reference to the database.
    final Database db = await database;
    // Query the table for all The Dogs.


    final List<Map<String, dynamic>> maps = await db.query('tasks');
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return ScheduleEntity(
        // id: maps[i]['id'],
          title: maps[i]['title'],
          description: maps[i]['description'],
          date: maps[i]['date'],
          time: maps[i]['time'],
          alarm_req_code: maps[i]['alarm_req_code']
      );
    });
  }

  Future<void> updateDog(ScheduleEntity dog) async {
    final db = await database;
    // Update the given Dog.
    await db.update(
      'tasks',
      dog.toMap(),

      where: "alarm_req_code = ?",


      whereArgs: [dog.alarm_req_code],
    );
  }


  Future<void> deleteDog(ScheduleEntity dog) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'tasks',
      // Use a `where` clause to delete a specific dog.
      where: "alarm_req_code = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [dog.alarm_req_code],
    );
  }
}