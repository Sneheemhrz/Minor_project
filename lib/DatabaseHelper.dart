import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:picture_password/files_model.dart';
import 'package:picture_password/model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE User(id INTEGER PRIMARY KEY, image TEXT, xc TEXT ,yc TEXT,pin TEXT )");
    await db.execute("CREATE TABLE Files(id INTEGER PRIMARY KEY, images TEXT)");
  }

  Future<int> saveUser(Models user) async {
    var dbClient = await db;
    int res = await dbClient.insert("User", user.toMap());
    print("User");
    print(res);
    return res;
  }

  Future<int> saveFiles(FilesModel user) async {
    var dbClient = await db;
    int res = await dbClient.insert("Files", user.toMap());
    print("Files");
    print(res);
    return res;
  }

  Future<List<Models>> getUser() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM User');
    List<Models> employees = new List();
    for (int i = 0; i < list.length; i++) {
      var user = new Models(list[i]['image'], list[i]['xc'], list[i]['yc'],list[i]['pin']);
      user.setId(list[i]["id"]);
      employees.add(user);
    }

    return employees;
  }

  Future<List<FilesModel>> getFiles() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Files');
    List<FilesModel> files = new List();
    for (int i = 0; i < list.length; i++) {
      var file = new FilesModel(list[i]['images']);
      file.setId(list[i]["id"]);
      files.add(file);
    }
    return files;
  }

  Future<bool> update(Models user) async {
    print("update");
    print(user);
    var dbClient = await db;
    int res = await dbClient.update(
      "User",
      user.toMap(),
    );
    return res > 0 ? true : false;
  }

  Future<int> deleteFiles(FilesModel filesModel) async {
    var dbClient = await db;

    int res = await dbClient
        .rawDelete('DELETE FROM Files WHERE id = ?', [filesModel.id]);
    return res;
  }
}
