import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sumenep_tourism/config/table.definitions.dart';
import 'package:sumenep_tourism/constant/env.dart';

class SqliteDbService {
  Database db;
  String _path;

  Future<void> initDatabase() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, Env.DB_NAME);
    this._path = path;

    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      for (int i = 0; i < tableDefinitions.length; i++) {
        await db.execute(tableDefinitions.values.toList()[i]);
      }
    });
  }

  String get dbPathName => this._path;

  Future<int> count({@required String tableName}) async {
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM $tableName"));
  }

  Future<Map> getById({@required String tableName, @required int id}) async {
    List<Map> result = await db.query(tableName, where: "id", whereArgs: [id]);
    return result.length > 0
        ? result.first
        : throw Exception("Element $id in $tableName not exist !!!");
  }

  Future<List<Map>> findAll({@required String tableName}) async {
    return await db.query(tableName);
  }

  Future<void> batch({@required Function(Batch) operations}) async {
    Batch batch = db.batch();
    operations(batch);
    await batch.commit(noResult: true);
  }

  Future<void> insertBatch({
    @required String tableName,
    @required List<Map<String, dynamic>> inserts,
  }) async {
    await batch(operations: (Batch batch) {
      inserts.forEach((mapValue) => batch.insert(tableName, mapValue));
    });
  }

  Future<int> update({
    @required String tableName,
    @required int id,
    @required Map<String, dynamic> model,
    String columnId = 'key',
  }) async {
    return await db
        .update(tableName, model, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete({
    @required String tableName,
    @required int id,
    String columnId = 'key',
  }) async {
    return await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> create({
    @required String tableName,
    @required Map<String, dynamic> item,
  }) async {
    return await db.insert(tableName, item);
  }
}
