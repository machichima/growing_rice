import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class ConnectWeatherData {
  static final _weatherdbname = 'weathers_database.db';
  static final _weatherdbversion = 2;
  final _tableName = 'weathers';

  static final weatherId = '_id';
  static final lastUpdateTime = 'lastUpdateTime';
  static final sunRise = 'sunRise';
  static final sunSet = 'sunSet';
  static final cloudCover = 'cloudCover';
  static final maxTemp = 'maxTemp';
  static final minTemp = 'minTemp';
  static final temp = 'temp';
  static final feelTemp = 'feelTemp';
  static final windSpeed = 'windSpeed';
  static final precipprob = 'precipprob';
  static final humidity = 'humidity';

  ConnectWeatherData._privateConstructure();
  static final ConnectWeatherData instance =
      ConnectWeatherData._privateConstructure();

  static Database _weatherdata;

  Future<Database> get weatherdata async {
    //if (_weatherdata != null) return _weatherdata;

    _weatherdata = await _initWeatherData();
    return _weatherdata;
  }

  _initWeatherData() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _weatherdbname);
    print(directory.path);
    return await openDatabase(path,
        version: _weatherdbversion, onCreate: _onCreate);
  }

  Future _onCreate(Database database, int version) async {
    database.execute('''
      CREATE TABLE $_tableName(
        $weatherId INTEGER PRIMARY KEY, 
        $lastUpdateTime TEXT, 
        $sunRise TEXT,
        $sunSet TEXT,
        $cloudCover TEXT,
        $maxTemp TEXT,
        $minTemp TEXT,
        $temp TEXT,
        $feelTemp TEXT,
        $windSpeed TEXT,
        $precipprob TEXT,
        $humidity TEXT
        )
      ''');
    insertWeather({
      ConnectWeatherData.weatherId: 1,
      ConnectWeatherData.lastUpdateTime: '0000-00-00',
      ConnectWeatherData.sunRise: '[6,6]',
      ConnectWeatherData.sunSet: '[18,18]',
      ConnectWeatherData.cloudCover: '[5.0,5.0]',
      ConnectWeatherData.maxTemp: '[20.0, 20.0]',
      ConnectWeatherData.minTemp: '[10.0, 10.0]',
      ConnectWeatherData.temp: '[20.0, 20.0]',
      ConnectWeatherData.feelTemp: '[20.0, 20.0]',
      ConnectWeatherData.windSpeed: '[2.0, 2.0]',
      ConnectWeatherData.precipprob: '[30.0, 30.0]',
      ConnectWeatherData.humidity: '[2.0, 2.0]',
    });
    // await database.execute(
    //   "CREATE TABLE weathers(id INTEGER PRIMARY KEY, weatherType INTEGER, nextDate TEXT)",
    // );
  }

  Future<int> insertWeather(Map<String, dynamic> weather) async {
    Database db = await instance.weatherdata;

    return await db.insert(
      _tableName,
      weather,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    // Directory directory = await getApplicationDocumentsDirectory();
    // print(directory.path);
    // String path = join(directory.path, _weatherdbname);
    // databaseFactory.deleteDatabase(path);
    Database db = await instance.weatherdata;
    print('---------------------------');
    print(await db.query(_tableName));
    return await db.query(_tableName);
  }

  Future update(Map<String, dynamic> crop) async {
    Database db = await instance.weatherdata;
    int id = crop[weatherId];
    return await db
        .update(_tableName, crop, where: '$weatherId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.weatherdata;
    return await db
        .delete(_tableName); //, where: '$cropId = ?', whereArgs: [id]
  }

  //////////////////////////////////////

}
