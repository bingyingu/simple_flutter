import 'package:simple_flutter/storage/db/base_db_provider.dart';
import 'package:sqflite/sqflite.dart';

class UserDbProvider extends BaseDbProvider {
  final String columnName = "name";
  final String columnMood = "mood";

  int id;
  String name;
  String mood;

  UserDbProvider();

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnName: name,
      columnMood: mood,
    };

    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  UserDbProvider.from(Map<String, dynamic> map) {
    id = map[columnId];
    name = map[columnName];
    mood = map[columnMood];
  }

  @override
  String tableName() {
    return "user";
  }

  @override
  List<String> otherColumnSqlStr() {
    return [
      "$columnName text not null",
      "$columnMood text not null",
    ];
  }

  insert(UserDbProvider user) async {
    Database db = await getDatabase();
    return await db.insert(tableName(), user.toMap());
  }

  delete(String name) async {
    Database db = await getDatabase();
    return await db.delete(
      tableName(),
      where: "$columnName = ?",
      whereArgs: [name],
    );
  }

  update(UserDbProvider user) async {
    Database db = await getDatabase();
    return await db.update(
      tableName(),
      user.toMap(),
      where: "$columnName = ?",
      whereArgs: [user.name],
    );
  }

  query(String name) async {
    Database db = await getDatabase();
    List<Map> resMaps = await db.query(
      tableName(),
      columns: [columnId,columnName, columnMood],
      where: "$columnName = ?",
      whereArgs: [name],
    );
    if (resMaps.length > 0) {
      return new UserDbProvider.from(resMaps.first);
    }
    return null;
  }
}