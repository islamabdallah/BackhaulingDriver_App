import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'trip_db.db'),
        onCreate: _create, version: 1);
  }

 static  Future _create(Database db, int version) async {
    await  db.execute(
        'CREATE TABLE truck_trip('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'requestId INTEGER,'
            'shipmentId TEXT,'
            'truckNumber TEXT,'
            'tripStatus TEXT,'
            'dateTime TEXT,'
            'sapTruckNumber TEXT,'
            'firebaseToken TEXT, '
            'lat TEXT, '
            'long TEXT, '
            'driverId TEXT)');
    await  db.execute(
        'CREATE TABLE current_shipment('
            'shipmentId TEXT PRIMARY KEY)');
    await  db.execute(
        'CREATE TABLE current_trip('
            'shipmentID TEXT PRIMARY KEY,'
            'requestID INTEGER,'
            'customerID TEXT,'
            'customerName TEXT,'
            'srcName TEXT,'
            'srcLat TEXT,'
            'srcLong TEXT,'
            'srcAddress TEXT,'
            'srcContactName TEXT,'
            'srcContactNumber TEXT,'
            'destName TEXT,'
            'destLat TEXT,'
            'destLong TEXT,'
            'destAddress TEXT,'
            'destContactName TEXT,'
            'destContactNumber TEXT,'
            'pickupDate TEXT,'
            'deliverDate TEXT,'
            'accessories TEXT,'
            'package TEXT,'
            'capacity TEXT,'
            'comment TEXT,'
            'unitType TEXT,'
            'truckNumber TEXT,'
            'sapTruckNumber TEXT,'
            'firebaseToken TEXT,'
            'tripStatus TEXT,'
            'tripType TEXT,'
            'view INTEGER)');
    await  db.execute(
        'CREATE TABLE truck_status('
            'truckNumber TEXT PRIMARY KEY,'
            'tripBreak INTEGER DEFAULT 0,'
            'shipmentId TEXT,'
            'requestId INTEGER,'
            'tripStatus TEXT,'
            'firebaseToken TEXT,'
            'sapTruckNumber TEXT,'
            'driverId TEXT)');
    await  db.execute(
        'CREATE TABLE truck_driver('
            'firebaseToken TEXT,'
            'driverId TEXT)');

    await  db.execute(
        'CREATE TABLE truck_data('
            'truckNumber TEXT,'
            'sapTruckNumber TEXT,'
            'firebaseToken TEXT)');
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<int> deleteTrip(int requestId) async {
    final db = await DBHelper.database();
    return await db.delete("truck_trip", where: 'requestId = ?', whereArgs: [requestId]);
  }
  static Future<int> delete(String table, int requestId) async {
    final db = await DBHelper.database();
    return await db.delete(table, where: 'requestId = ?', whereArgs: [requestId]);
  }

  static Future<void> update(String table, value, key) async {
    final db = await DBHelper.database();
    return await db.rawUpdate('UPDATE $table SET $key = ?', [value]);
//    return await db.update(table, data,
//        where: '$key = ?', whereArgs: [value]);
  }
}
