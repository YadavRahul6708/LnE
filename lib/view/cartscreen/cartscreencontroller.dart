import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import 'package:sqflite/sqflite.dart' as sql;

class CartSQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      CREATE TABLE items2(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        description TEXT,
        imagepath TEXT,
        regularprice TEXT,
        saleprice TEXT,
        favoritenumber TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'dbstech.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createItem(
      String title, String? description, String? imagePath,String regularprice,String saleprice,String favoriteNumber ) async {
    final db = await CartSQLHelper.db();
    final data = {
      'title': title,
      'description': description,
      'imagepath': imagePath,
      'regularprice':regularprice,
      'saleprice':saleprice,
      'favoritenumber':favoriteNumber
    };
    final id = await db.insert(
      'items2',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await CartSQLHelper.db();
    return db.query('items2', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await CartSQLHelper.db();
    return db.query('items2', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateItem(
      int id, String title, String? description, String? imagePath,String regularPrice,String salePrice,String favoriteNumber) async {
    final db = await CartSQLHelper.db();
    final data = {
      'title': title,
      'description': description,
      'imagepath': imagePath,
      'regularprice':regularPrice,
      'saleprice':salePrice,
      'favoritenumber':favoriteNumber,
      'createdAt': DateTime.now().toString()
    };
    final result = await db.update(
      'items2',
      data,
      where: "id = ?",
      whereArgs: [id],
    );
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await CartSQLHelper.db();
    try {
      await db.delete("items2", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static Future<String?> getImagePath() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      return pickedImage.path;
    }
    return null; // Return null if no image was picked
  }
}
