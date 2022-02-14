
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../dto/card_model.dart';



const String tableReminder='reminders';
const String colId='id';
const String colTitle='title';
const String colMessage='message';
const String colDataId='dataId';
const String colDateReminder='dateReminder';
const String colType='type';
class ReminderHelper{
  static Database _database;
  static ReminderHelper _reminderHelper;

  ReminderHelper._createInstance();
  factory ReminderHelper(){
    _reminderHelper ??= ReminderHelper._createInstance();
    return _reminderHelper;
  }

  Future<Database> get database async{
    _database ??= await initializeDatabase();
    return _database;
  }
  Future<Database> initializeDatabase() async{
    final dir=await getDatabasesPath();
    final path='${dir}reminder.db';
    final database=await openDatabase(path,version: 3,onCreate: (db,version){
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

  Future<void> insertRemainder(CardModel reminder) async{
    final db= await database;
    final result= await db.insert(tableReminder, {'title':reminder.title,'message':reminder.message,'dataId':reminder.id,'dateReminder': DateFormat('yyyy-MM-dd HH:mm').format(reminder.dateTime),'type':reminder.type});
    print('result $result');

  }
}