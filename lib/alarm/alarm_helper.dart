import 'alarm_look.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

final String Tablealarm = 'alarm';
final String ColumnId  ='id';
final String ColumnDatetime  ='alarm_time';
final String ColumnSunday  ='Sunday';
final String ColumnMonday  ='Monday';
final String ColumnTuesday  ='Tuesday';
final String ColumnWednesday  ='Wednesday';
final String ColumnThursday  ='Thursday';
final String ColumnFriday  ='Friday';
final String ColumnSaturday  ='Saturday';
final String ColumnTask  ='enable_task';
final String ColumnActive  ='isactive';
final String ColumnSound  ='sound';



class AlarmHelper{
  static Database _database;
  static AlarmHelper _alarmHelper;

  AlarmHelper._createInstance();
  factory AlarmHelper() {
    if (_alarmHelper == null) {
      _alarmHelper = AlarmHelper._createInstance();
    }
    return _alarmHelper;
  }

  Future<Database> get database async {
    if (_database == null){
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = dir + "alarm.db";
    var database= await openDatabase(
      path,
      version: 1,
      onCreate: (db,version){
        db.execute('''
          create table $Tablealarm(
          $ColumnId integer primary key autoincrement,
          $ColumnDatetime text not null,
          $ColumnSound text not null,
          $ColumnSunday integer,
          $ColumnMonday integer,
          $ColumnTuesday integer,
          $ColumnWednesday integer,
          $ColumnThursday integer,
          $ColumnFriday integer,
          $ColumnSaturday integer,
          $ColumnTask integer,
          $ColumnActive integer)          
        ''');
      },
    );
    return database;
  }

  void insertAlarm(Alarm_look alarm_look) async {
    var db = await this.database;
    var result = await db.insert(Tablealarm, alarm_look.toMap(),conflictAlgorithm: ConflictAlgorithm.replace,);

    print('result : $result');
  }


  Future<List<Alarm_look>> getAlarms() async {
    List<Alarm_look> _alarms = [];
    var db = await this.database;
    var result = await db.query(Tablealarm);
    result.forEach((element) {
      var alarmInfo = Alarm_look.fromJson(element);
      _alarms.add(alarmInfo);
    });
    return _alarms;
  }

  Future<int> delete(int id) async {
    var db = await this.database;
    return await db.delete(Tablealarm, where: '$ColumnId = ?', whereArgs: [id]);
  }

  void deleteAll() async{
    var dir = await getDatabasesPath();
    var path = dir + "alarm.db";
    await deleteDatabase(path);
  }


}

