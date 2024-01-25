import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../models/item.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _databaseName = 'taskmanager.db';
  static Logger logger = Logger();
  static String _tasksTableName = 'tasks';
  static String _datesTableName = 'dates';

  static Future<Database> _getDB() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, _databaseName);
    return await openDatabase(path, version: _version,
        onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE $_tasksTableName(id INTEGER PRIMARY KEY, date TEXT, type TEXT, duration REAL, priority TEXT, category TEXT, description TEXT)');
      await db.execute(
          'CREATE TABLE $_datesTableName(id INTEGER PRIMARY KEY, date TEXT)');
    });
  }

  // get all items
  static Future<List<Item>> getItems() async {
    try {
      final db = await _getDB();
      final result = await db.query(_tasksTableName);
      logger.log(Level.info, "getItems: $result");
      return result.map((e) => Item.fromJson(e)).toList();
    }
    catch (e) {
      logger.log(Level.error, e.toString());
      return [];
    }
  }

  // get all categories
  static Future<List<String>> getDates() async {
    try {
      final db = await _getDB();
      final result = await db.query(_datesTableName);
      logger.log(Level.info, "getDates: $result");
      return result.map((e) => e['date'].toString()).toList();
    }
    catch (e) {
      logger.log(Level.error, e.toString());
      return [];
    }
  }

  // get items by category
  static Future<List<Item>> getItemsByDate(String date) async {
    try {
      final db = await _getDB();
      final result =
      await db.query(_tasksTableName, where: 'date = ?', whereArgs: [date]);
      logger.log(Level.info, "getItemsByDate: $result");
      return result.map((e) => Item.fromJson(e)).toList();
    }
    catch (e) {
      logger.log(Level.error, e.toString());
      return [];
    }
  }

  // delete item
  static Future<int> deleteItem(int id) async {
    try {
      final db = await _getDB();
      final result = await db.delete(
          _tasksTableName, where: 'id = ?', whereArgs: [id]);
      logger.log(Level.info, "deleteItem: $result");
      return result;
    }
    catch (e) {
      logger.log(Level.error, e.toString());
      return 0;
    }
  }

  // add item
  static Future<Item> addItem(Item item) async {
    try {
      final db = await _getDB();
      final id = await db.insert(_tasksTableName, item.toJsonWithoutId(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      logger.log(Level.info, "addItem: $id");
      return item.copy(id: id);
    }
    catch (e) {
      logger.log(Level.error, e.toString());
      return item;
    }
  }

  // update categories in database
  static Future<void> updateDates(List<String> dates) async {
    try {
      final db = await _getDB();
      await db.delete(_datesTableName);
      for (var i = 0; i < dates.length; i++) {
        await db.insert(_datesTableName, {'date': dates[i]});
      }
      logger.log(Level.info, "updateDates: $dates");
    }
    catch (e) {
      logger.log(Level.error, e.toString());
    }
  }

  // update a category's items
  static Future<void> updateDateItems(
      String date, List<Item> items) async {
    try {
      final db = await _getDB();
      await db.delete(_tasksTableName, where: 'date = ?', whereArgs: [date]);
      for (var i = 0; i < items.length; i++) {
        await db.insert(_tasksTableName, items[i].toJsonWithoutId());
      }
      logger.log(Level.info, "updateDateItems: $date, $items");
    }
    catch (e) {
      logger.log(Level.error, e.toString());
    }
  }

  // close database
  static Future<void> close() async {
    final db = await _getDB();
    await db.close();
  }
}
