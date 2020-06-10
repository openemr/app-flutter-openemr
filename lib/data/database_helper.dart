import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:openemr/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

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
    await db.execute(
        "CREATE TABLE User(id INTEGER PRIMARY KEY, username TEXT, tokenType TEXT, accessToken TEXT, userId TEXT, baseUrl TEXT, savePassword BOOLEAN)");
    print("Created tables");
  }

  Future<int> saveUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.insert("User", user.toMap());
    return res;
  }

  Future<int> deleteUsers() async {
    var dbClient = await db;
    int res = await dbClient.delete("User");
    return res;
  }

  Future<bool> isLoggedIn() async {
    var dbClient = await db;
    var res = await dbClient.query("User");
    return res.isNotEmpty && res[0]["accessToken"] != null ;
  }

  Future<String> getBaseUrl() async {
    var dbClient = await db;
    var res = await dbClient.query("User", columns: ["baseUrl"]);
    return res.isEmpty ? null : res[0]["baseUrl"];
  }

  Future<String> getToken() async {
    var dbClient = await db;
    var res =
        await dbClient.query("User", columns: ["tokenType", "accessToken"]);
    return res.isEmpty
        ? null
        : res[0]["tokenType"] + " " + res[0]["accessToken"];
  }
}
