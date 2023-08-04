
import 'package:sqflite/sqflite.dart' as sql;

class LoginSQLHelper{

  static Future<void>creatTables(sql.Database database)async {
    await database.execute("""CREATE TABLE items3(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    mobilenumber TEXT,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
     )""");
  }

  static Future<sql.Database> db() async{
    return sql.openDatabase(
        'dbsstech.db',
        version: 1,
        onCreate: (sql.Database database,int version) async{
          await creatTables(database);
        }

    );

  }

  static Future<int> createItem(String number) async{
    final db =await LoginSQLHelper.db();
    final data={'mobilenumber':number,};
    final id =await db.insert('items3', data,conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String,dynamic>>> getItems() async{
    final db =await LoginSQLHelper.db();
    return db.query('items3',orderBy: "id");
  }

  static Future<List<Map<String,dynamic>>>getItem(int id) async{
    final db= await LoginSQLHelper.db();
    return db.query('items3',where:"id= ?",whereArgs:[id],limit:1);
  }







}