import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqlite_demo/model/users.dart';

class DbManager {
  late Database _database;
  static const String INTEGER = "INTEGER";
  static const String TEXT = "TEXT";

  Future initDB() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), "sqlite_demo.db"),
      version: 1,
      onCreate: (db, version) {
        db.execute('''
            CREATE TABLE ${Users.tableField} (
              ${Users.idField} $INTEGER PRIMARY KEY,
              ${Users.userNameField} $TEXT ,
              ${Users.mobileNumberField} $TEXT
            )
          ''');
      },
    );
    return _database;
  }

  Future<List<Users>> getUsers() async {
    await initDB();

    final List<Map<String, dynamic>> maps =
        await _database.query(Users.tableField);

    return maps.map((e) {
      return Users(
        id: e[Users.idField],
        userName: e[Users.userNameField],
        mobileNumber: e[Users.mobileNumberField],
      );
    }).toList();
  }

  Future<int> insertUser(Users users) async {
    await initDB();
    return await _database.insert(Users.tableField, users.toJson());
  }

  Future<int> updateUsers(Users users) async {
    await initDB();

    return await _database.update(Users.tableField, users.toJson(),
        where: "${Users.idField} = ?", whereArgs: [users.id]);
  }

  Future<int> deleteUsers(Users users) async {
    await initDB();

    return _database.delete(Users.tableField,
        where: '${Users.idField}=?', whereArgs: [users.id]);
  }
}
