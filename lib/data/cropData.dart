import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Crop {
  final int id;
  final int cropType;
  final String nextDate;

  Crop({this.id, this.cropType, this.nextDate});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cropType': cropType,
      'nextDate': nextDate,
    };
  }
}

class ConnectCropData {
  static final _cropdbname = 'crops_database.db';
  static final _cropdbversion = 2;
  final _tableName = 'crops';
  static final cropId = '_id';
  static final cropType = 'cropType';
  static final nextDate = 'nextDate';

  ConnectCropData._privateConstructure();
  static final ConnectCropData instance =
      ConnectCropData._privateConstructure();

  static Database _cropdata;

  Future<Database> get cropdata async {
    //if (_cropdata != null) return _cropdata;

    _cropdata = await _initCropData();
    return _cropdata;
  }

  _initCropData() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _cropdbname);
    print(directory.path);
    return await openDatabase(path,
        version: _cropdbversion, onCreate: _onCreate);
  }

  Future _onCreate(Database database, int version) async {
    database.execute('''
      CREATE TABLE $_tableName($cropId INTEGER PRIMARY KEY, $cropType INTEGER, $nextDate TEXT)
      ''');
    insertCrop({
      ConnectCropData.cropId: 1,
      ConnectCropData.cropType: 1,
      ConnectCropData.nextDate: "0000-00-00"
    });
    // await database.execute(
    //   "CREATE TABLE crops(id INTEGER PRIMARY KEY, cropType INTEGER, nextDate TEXT)",
    // );
  }

  Future<int> insertCrop(Map<String, dynamic> crop) async {
    Database db = await instance.cropdata;

    return await db.insert(
      _tableName,
      crop,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    //Directory directory = await getApplicationDocumentsDirectory();
    //print(directory.path);
    //String path = join(directory.path, _cropdbname);
    //databaseFactory.deleteDatabase(path);
    Database db = await instance.cropdata;
    return await db.query(_tableName);
  }

  Future<List<Map<String, dynamic>>> queryNextDate(String date) async {
    //Directory directory = await getApplicationDocumentsDirectory();
    //print(directory.path);
    //String path = join(directory.path, _cropdbname);
    //databaseFactory.deleteDatabase(path);
    Database db = await instance.cropdata;
    return await db.query(_tableName, where: '$nextDate: ?', whereArgs: [date]);
  }

  Future update(Map<String, dynamic> crop) async {
    Database db = await instance.cropdata;
    int id = crop[cropId];
    return await db
        .update(_tableName, crop, where: '$cropId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.cropdata;
    return await db
        .delete(_tableName); //, where: '$cropId = ?', whereArgs: [id]
  }

  //////////////////////////////////////

}

// Future<void> insertCrop(Crop crop) async {
//     final Database db = await database;

//     await db.insert(
//       'crops',
//       crop.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
// void main() async {
//   final cropData = Crop(cropType: 1, nextDate: '2021-01-31');
//   await insertCrop(cropData);

//   Future<List<Crop>> crops() async {
//     //引用資料庫
//     final Database db = await database;

//     // 查詢狗狗資料庫語法
//     final List<Map<String, dynamic>> maps = await db.query('dogs');

// //將 List<Map<String, dynamic> 轉換成 List<Dog> 資料類型
//     return List.generate(maps.length, (i) {
//       return Crop(
//         cropType: maps[i]['cropType'],
//         nextDate: maps[i]['nextDate'],
//       );
//     });
//   }
// }
