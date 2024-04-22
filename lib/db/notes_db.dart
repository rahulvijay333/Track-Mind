import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:track_mind/model/note.dart';

class NoteDatabase {
  static final NoteDatabase instance = NoteDatabase._init();

  NoteDatabase._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filepath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const textType = 'TEXT NOT NULL';

    await db.execute('''CREATE TABLE $tableNotes(${NoteFields.id} $idType,
    ${NoteFields.isImportant} $boolType,
    ${NoteFields.number} $integerType,
    ${NoteFields.title} $textType,
    ${NoteFields.description} $textType,
    ${NoteFields.time} $textType)''');
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;

    final id = await db.insert(tableNotes, note.toJson());
    
    return note.copy(id: id);
  }

  Future<Note?> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(tableNotes,
        columns: NoteFields.values,
        where: '${NoteFields.id} = ?',
        whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;

    final json = await db.query(tableNotes, orderBy: '${NoteFields.time} ASC');

    return json.map((note) => Note.fromJson(note)).toList();
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return db
        .delete(tableNotes, where: '${NoteFields.id} = ?', whereArgs: [id]);
  }

  Future<int> update(Note note) async {
    final db = await instance.database;
   

    return db.update(tableNotes, note.toJson(),
        where: '${NoteFields.id} = ?', whereArgs: [note.id]);
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
