import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart' as sql;

class ProfileSQLHelper{

  static Future<void>creatTables(sql.Database database)async {
    await database.execute("""CREATE TABLE items(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    name TEXT,
    email TEXT,
    mobilenumber TEXT,
    imagepath TEXT,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
     )""");
  }

  static Future<sql.Database> db() async{
    return sql.openDatabase(
        'dbtech.db',
        version: 1,
        onCreate: (sql.Database database,int version) async{
          await creatTables(database);
        }

    );

  }

  static Future<int> createItem(String name, String? email,String number,String? imagePath) async{
    final db =await ProfileSQLHelper.db();
    final data={'name':name,'email':email,'mobilenumber':number,'imagepath':imagePath};
    final id =await db.insert('items', data,conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String,dynamic>>> getItems() async{
    final db =await ProfileSQLHelper.db();
    return db.query('items',orderBy: "id");
  }

  static Future<List<Map<String,dynamic>>>getItem(int id) async{
    final db= await ProfileSQLHelper.db();
    return db.query('items',where:"id= ?",whereArgs:[id],limit:1);
  }

  static Future<int>updateItem(
      int id, String name, String? email,String number,String? imagePath) async{
    final db=await ProfileSQLHelper.db();
    final data={
      'name':name,
      'email':email,
      'number':number,
      'imagepath':imagePath,
      'createdAt':DateTime.now().toString()
    };
    final result= await db.update('items', data,where: "id = ?",whereArgs: [id]);
    return result;
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