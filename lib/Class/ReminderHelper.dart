
import 'package:astrology_app/Class/Reminder.dart';
import 'package:astrology_app/dto/cardClass.dart';
import 'package:astrology_app/generated/intl/messages_all.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

final String tableReminder="reminders";
final String colId='id';
final String colTitle='title';
final String colMessage='message';
final String colDataId='dataId';
final String colDateReminder='dateReminder';
final String colType='type';
class ReminderHelper{
  static Database _database;
  static ReminderHelper _reminderHelper;

  ReminderHelper._createInstance();
  factory ReminderHelper(){
    if(_reminderHelper==null){
      _reminderHelper=ReminderHelper._createInstance();
    }
    return _reminderHelper;
  }

  Future<Database> get database async{
    if(_database==null){
      _database=await initializeDatabase();
    }
    return _database;
  }
  Future<Database> initializeDatabase() async{
    var dir=await getDatabasesPath();
    var path=dir+"reminder.db";
    var database=await openDatabase(path,version: 3,onCreate: (db,version){
      db.execute('''
      CREATE TABLE $tableReminder (
       $colId INT NOT NULL AUTO_INCREMENT , 
       $colTitle VARCHAR(255) NOT NULL ,
       $colType VARCHAR(100) NOT NULL ,
       $colMessage VARCHAR(500) NOT NULL ,
       $colDataId INT NOT NULL ,
       $colDateReminder VARCHAR(100) NOT NULL , PRIMARY KEY (`id`)
      ''');
    },);
    return database;
  }

  void insertRemainder(cardClass reminder) async{
    var db= await this.database;
    var result= await db.insert(tableReminder, {'title':reminder.title,'message':reminder.message,'dataId':reminder.id,'dateReminder': DateFormat('yyyy-MM-dd HH:mm').format(reminder.dateTime),"type":reminder.type});
    print('result $result');

  }
}