import 'dart:developer';
import 'package:async/async.dart';
import 'package:Mynotes/extensions/list/filter.dart';
import 'dart:js_interop';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'crud_exceptions.dart';

class NotesService {
  Database? _db;
  List<DatabaseNote> _notes = [];
  List results = [];
  Future<void> deleteNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount =
        await db.delete(noteTable, where: 'id=?', whereArgs: [id]);
    if (deletedCount == 0) {
      throw CouldNotDeleteNote();
    }
  }

  Future<int> deleteAllNotes() async {
    final db = _getDatabaseOrThrow();
    return await db.delete(noteTable);
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else
      return db;
  }

  Future<DatabaseNote>updateNotes({required DatabaseNote note,required String text})async{
    final db=_getDatabaseOrThrow();
    final updatesCount=await db.update(noteTable, {
      textColumn: text,
      isSyncedWithCloudColumn:0
    });
    if(updatesCount==0)throw CouldNotUpdateNote();
    return await getNote(id: note.id);
  }

  Future<Iterable<DatabaseNote>> getAllNotes()async{
    final db=_getDatabaseOrThrow();
    final notes=await db.query(noteTable);

   return  notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }

  Future<DatabaseNote> getNote({required int id})async{
    final db=_getDatabaseOrThrow();
    final notes=await db.query(noteTable,limit: 1,whereArgs: [id],where: 'id=?');
    if (notes.isEmpty){
      throw CouldNotFindNote();
    }else {
      return DatabaseNote.fromRow(notes.first);
    }
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    final db = _getDatabaseOrThrow();
    //make sure owner exists in the database with correct id
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) throw CouldNotFindUser();
    const text = '';
    final noteId = await db.insert(
      noteTable,
      {userIdColumn: owner.id, textColumn: text, isSyncedWithCloudColumn: 1},
    );

    final note = DatabaseNote(
        id: noteId, isSyncedWithCloud: true, text: text, userId: owner.id);
    return note;
  }

  Future<DatabaseUser> createUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    results = db.query(userTable,
        limit: 1, where: 'email=?', whereArgs: [email.toLowerCase()]) as List;
    if (results.isNotEmpty) {
      throw UserAlreadyExits();
    }
    final userid =
        await db.insert(userTable, {emailColumn: email.toLowerCase()});

    return DatabaseUser(id: userid, email: email);
  }

  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final results = db.query(userTable,
        limit: 1, where: 'email=?', whereArgs: [email.toLowerCase()]) as List;
    if (results.isEmpty) {
      throw CouldNotFindUser();
    } else {
      var first = 0;
      return DatabaseUser.fromRow(results.first);
    }
  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db
        .delete(userTable, where: 'email=?', whereArgs: [email.toLowerCase()]);
    if (deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      await db.execute(createUserTable);

      await db.execute(createNoteTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }
}

class DatabaseUser {
  final int id;
  final String email;
  const DatabaseUser({required this.id, required this.email});

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => 'Person, ID=$id,email=$email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashcode => id.hashCode;
}

class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  DatabaseNote(
      {required this.id,
      required this.isSyncedWithCloud,
      required this.text,
      required this.userId});

  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        isSyncedWithCloud =
            (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      'Note, ID=$id, userId=$userId, isSyncedWithCloud=$isSyncedWithCloud, text=$text';
  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashcode => id.hashCode;
}

const dbName = 'notes db';
const noteTable = 'note';
const userTable = 'user';
const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const textColumn = 'text';
const isSyncedWithCloudColumn = 'is_synced_with_cloud';
const createUserTable = '''CREATE TABLE IF NOT EXISTS "user"(
	"id"	INTEGER NOT NULL,
	"email"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
);''';
const createNoteTable = '''CREATE TABLE IF NOT EXISTS "note" (
	"id"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL,
	"text"	TEXT,
	"is_synced_with_cloud"	INTEGER DEFAULT 0,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "user"("id")
);''';
