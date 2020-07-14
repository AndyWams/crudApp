import 'dart:io';
import 'package:crudApp/model/user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = 'ContactDatabase.db';
  static const _databaseVersion = 1;

  //singleton class
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(dataDirectory.path, _databaseName);
    return await openDatabase(dbPath,
        version: _databaseVersion, onCreate: _onCreateDB);
  }

  Future _onCreateDB(Database db, int version) async {
    //create tables
    await db.execute('''
      CREATE TABLE ${Contact.tblContact}(
        ${Contact.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Contact.colName} TEXT NOT NULL,
        ${Contact.colTitle} TEXT NOT NULL
      )
      ''');
  }

  //contact - insert
  Future<int> insertContact(Contact contact) async {
    Database db = await database;
    return await db.insert(Contact.tblContact, contact.toMap());
  }

//contact - update
  Future<int> updateContact(Contact contact) async {
    Database db = await database;
    return await db.update(Contact.tblContact, contact.toMap(),
        where: '${Contact.colId}=?', whereArgs: [contact.id]);
  }

//contact - delete
  Future<int> deleteContact(int id) async {
    Database db = await database;
    return await db.delete(Contact.tblContact,
        where: '${Contact.colId}=?', whereArgs: [id]);
  }

//contact - retrieve all

  Future<List<Contact>> fetchContacts() async {
    Database db = await database;
    List<Map> contacts = await db.query(Contact.tblContact);
    if (contacts.length > 0) {
      List<Contact> records = [];
      records = contacts.map((x) => Contact.fromMap(x)).toList();
      return Future.delayed(Duration(milliseconds: 1000)).then((x) => records);
    }
    return [];
  }

  Future<Contact> getContact(int id) async {
    Database db = await database;
    List<Map> contact = await db.query(Contact.tblContact,
        columns: [Contact.colId, Contact.colName, Contact.colTitle],
        where: '${Contact.colId}=?',
        whereArgs: [id]);
    if (contact.length > 0) {
      return Future.delayed(Duration(milliseconds: 600))
          .then((x) => Contact.fromMap(contact.first));
    }
    return null;
  }
}
