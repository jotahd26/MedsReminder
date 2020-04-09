import 'dart:async';
import 'dart:io';
import 'package:myflutterproject/models/medicamento.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
  static Database _database;                // Singleton Database

  String medicamentoTable = 'medicamentos';
  String colId = 'id';
  String colNome = 'nome';
  String colTipo = 'tipo';
  String colFrequencia = 'frequencia';
  //String colDate = 'date';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {

    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {

    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'medicamentos.db';

    // Open/create the database at a given path
    var medicamentosDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return medicamentosDatabase;
  }

  void _createDb(Database db, int newVersion) async {

    await db.execute('CREATE TABLE $medicamentoTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colNome TEXT, '
        '$colTipo TEXT, $colFrequencia TEXT)');
  }

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;

		var result = await db.rawQuery('SELECT * FROM $medicamentoTable');
    //var result = await db.query(noteTable, orderBy: '$colPriority ASC');
    return result;
  }

  // Insert Operation: Insert a Note object to database
  Future<int> insertMedicamento(Medicamento medicamento) async {
    Database db = await this.database;
    var result = await db.insert(medicamentoTable, medicamento.toMap());
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updateMedicamento(Medicamento medicamento) async {
    var db = await this.database;
    var result = await db.update(medicamentoTable, medicamento.toMap(), where: '$colId = ?', whereArgs: [medicamento.id]);
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteMedicamento(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $medicamentoTable WHERE $colId = $id');
    return result;
  }

  // Get number of Note objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $medicamentoTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<Medicamento>> getNoteList() async {

    var noteMapList = await getNoteMapList(); // Get 'Map List' from database
    int count = noteMapList.length;         // Count the number of map entries in db table

    List<Medicamento> noteList = List<Medicamento>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(Medicamento.fromMapObject(noteMapList[i]));
    }

    return noteList;
  }

}