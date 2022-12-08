import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  static Future<Database> database() async {
    var dbPath = getDatabasesPath();
    debugPrint(dbPath.toString());
    return openDatabase(
      join(dbPath.toString(), 'places.db'),
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
           CREATE TABLE taskData(
            task TEXT,
            date DATETIME,
            time DATETIME,
            isAlert BOOL
           )
          ''',
        );
      },
    );
  }

  static Future<void> insert(String table, Map<String, dynamic> data) async {
    final db = await database();
    db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await database();
    return db.query(table);
  }

  static Future<int> updateTask(String table, Map<String, dynamic> row,String task) async {
    final db = await database();
    return db.update(table, row, where: 'task = ?', whereArgs: [task]);
  }

  

  static Future<int> deleteData({
    required String table,
    required String task,
  }) async {
    final db = await database();
    var data = await db.delete(table, where: 'task = ?', whereArgs: [task]);
    return data;
  }

  gitFunction(){
    //...create function...
  }

}
