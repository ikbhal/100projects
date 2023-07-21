// TODO Implement this library.

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'contact_model.dart';

class ContactProvider {
  static Database? _database = null;
  static const String _tableName = 'contacts';

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'contacts.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            mobileNumber TEXT,
            notes TEXT
          )
        ''');
      },
    );
  }

  Future<List<Contact>> getContacts() async {
    final db = await database;
    final contactsData = await db?.query(_tableName);
    if (contactsData != null)
      return contactsData.map((contact) => Contact.fromMap(contact)).toList();
    else
      return [];
  }

  Future<void> addContact(Contact contact) async {
    final db = await database;
    await db?.insert(_tableName, contact.toMap());
  }
}
