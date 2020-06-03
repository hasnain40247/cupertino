import 'dart:io';

import 'package:finalnote/table/table.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;
  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colDate = 'date';

  DatabaseHelper._createInstance();

  factory DatabaseHelper(){
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeData();
    }
    return _database;
  }

  Future<Database> initializeData() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "mynotes.db";

    var noteDatabase = await openDatabase(
        path, version: 1, onCreate: _onCreate);
    return noteDatabase;
  }

  void _onCreate(Database db, int newVersion) async
  {
    await db.execute(
        "CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colTitle TEXT,$colDescription TEXT,$colDate TEXT)");
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    var result = await db.query(noteTable);
    return result;
  }

  Future<int> insert(Note note) async{
    Database db=await this.database;
    var result=await db.insert(noteTable, note.toMap());
    return result;
  }
  Future<int> updateNote(Note note) async {
    var db = await this.database;
    var result = await db.update(noteTable, note.toMap(), where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }
  Future<int> deleteNote(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return result;
  }
  Future<List<Note>> getNoteList() async {

    var noteMapList = await getNoteMapList(); // Get 'Map List' from database
    int count = noteMapList.length;         // Count the number of map entries in db table

    List<Note> noteList = List<Note>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }

    return noteList;
  }

}