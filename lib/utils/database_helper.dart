import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_cook_book/models/pictures.dart';
import 'package:flutter_cook_book/models/receipts.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._internal();
      return _databaseHelper;
    } else {
      return _databaseHelper;
    }
  }

  DatabaseHelper._internal();

  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await _initializeDatabase();
      return _database;
    } else {
      return _database;
    }
  }

  Future<Database> _initializeDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "app.db");
    print("Olusan db path:$path");

// Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "data.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
// open the database
    return await openDatabase(path, readOnly: false);
  }

  Future<List<Map<String, dynamic>>> getPicture() async {
    var db = await _getDatabase();
    var result = await db.query("pictures");
    return result;
  }

  Future<List<Picture>> getPictureList() async {
    var pictureContainingList = await getPicture();
    var pictureList = List<Picture>();
    for (Map map in pictureContainingList) {
      pictureList.add(Picture.fromMap(map));
    }
    return pictureList;
  }

  Future<int> addPicture(Picture picture) async {
    var db = await _getDatabase();
    var result = await db.insert("picture", picture.toMap());
    return result;
  }

  Future<int> updatePicture(Picture picture) async {
    var db = await _getDatabase();
    var result = await db.update("picture", picture.toMap(),
        where: 'pictureID = ?', whereArgs: [picture.pictureID]);
    return result;
  }

  Future<int> deletePicture(int pictureID) async {
    var db = await _getDatabase();
    var result = await db
        .delete("picture", where: 'pictureID = ?', whereArgs: [pictureID]);
    return result;
  }

  Future<List<Map<String, dynamic>>> getReceipts() async {
    var db = await _getDatabase();
    var result = await db.rawQuery(
        'select * from "receips" order by receiptsID Desc;');
    return result;
  }

  Future<List<Receipts>> getReceiptsList() async {
    var receiptsMapList = await getReceipts();
    var receiptsList = List<Receipts>();
    for (Map map in receiptsMapList) {
      receiptsList.add(Receipts.fromMap(map));
    }
    return receiptsList;
  }

  Future<int> addReceipt(Receipts receipts) async {
    var db = await _getDatabase();
    var result = await db.insert("receipts", receipts.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future<int> updateReceipt(Receipts receipts) async {
    var db = await _getDatabase();
    var result = await db.update("receipts", receipts.toMap(),
        where: 'receiptID = ?', whereArgs: [receipts.receiptID]);
    return result;
  }

  Future<int> deleteReceipt(int receiptID) async {
    var db = await _getDatabase();
    var result = await db
        .delete("receipts", where: 'receiptID = ?', whereArgs: [receiptID]);
    return result;
  }
}
