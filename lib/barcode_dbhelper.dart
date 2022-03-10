// ignore_for_file: unused_local_variable

import 'package:barcodescanner/model/barcodescanner_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BarcodeScanlogDB {
  static final BarcodeScanlogDB instance = BarcodeScanlogDB._init();
  static Database? _database;
  BarcodeScanlogDB._init();
  static final id = 'id';
  static final barcode = 'barcode';
  static final time = 'time';
  static final qty = 'qty';
  static final company_code = 'company_code';
  static final device_id = 'device_id';
  static final page_id = 'page_id';
  static final appType = 'appType';
  static final company_name = 'company_name';
  static final company_id = 'company_id';
  static final user_id = 'user_id';
  static final expiry_date = 'expiry_date';

  //////////////////////////////////////

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("barcodeScan.db");
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, filepath);
    return await openDatabase(path,
        version: 1, onCreate: _createDB);
  }

  // Future _upgradeDB(Database db, int oldversion, int newVwersion) async {
  //   var batch = db.batch();
  //   print("version UPGRADE-----------------${oldversion} && ${newVwersion}");
  //   if (oldversion == 1) {}
  //   batch.commit();
  // }

  Future _createDB(Database db, int version) async {
    ///////////////barcode store table ////////////////

    await db.execute('''
          CREATE TABLE tableScanLog (
            $id INTEGER PRIMARY KEY AUTOINCREMENT,
            $barcode TEXT NOT NULL,
            $time TEXT NOT NULL,
            $qty INTEGER NOT NULL,
            $page_id INTEGER NOT NULL

          )
          ''');
////////////// registration table ////////////
    await db.execute('''
          CREATE TABLE tableRegistration (
            $id INTEGER PRIMARY KEY AUTOINCREMENT,
            $company_code TEXT NOT NULL,
            $device_id TEXT NOT NULL,
            $appType TEXT NOT NULL,
            $company_id TEXT NOT NULL,
            $company_name TEXT NOT NULL,
            $user_id TEXT NOT NULL,
            $expiry_date TEXT NOT NULL
          )
          ''');
  }

  // void _updateTableRegistration(Batch batch) {
  //   batch.execute(
  //       'ALTER TABLE tableRegistration ADD company_id TEXT, company_name TEXT, user_id INTEGER, ');
  // }

  // Future insertBarcode(Data barcodeData) async {
  //   final db = await database;
  //   var query =
  //       'INSERT INTO tableBarcode(barcode, brand, model, size, description , rate, product) VALUES("${barcodeData.barcode}", "${barcodeData.brand}", "${barcodeData.model}", "${barcodeData.size}", "${barcodeData.description}", "${barcodeData.rate}", "${barcodeData.product}")';
  //   var res = await db.rawInsert(query);
  //   print(query);
  //   print(res);
  //   return res;
  // }

  ////////////////////////////////////////////////
  Future barcodeTimeStamp(
      String? barcode, String? time, int qty, int page_id) async {
    final db = await database;
    var query =
        'INSERT INTO tableScanLog(barcode, time, qty, page_id) VALUES("${barcode}", "${time}", ${qty}, ${page_id})';
    var res = await db.rawInsert(query);
    print(query);
    print(res);
    return res;
  }
  ///////////////////////////////////////////////
  Future insertRegistrationDetails(String company_code, String device_id, String appType,String company_id, String company_name, String user_id,String expiry_date) async{
    final db = await database;
    print("userId*****${user_id}");
    // print(user_id.runtimeType);
    var query =
        'INSERT INTO tableRegistration(company_code, device_id, appType, company_id, company_name, user_id, expiry_date) VALUES("${company_code}", "${device_id}", "${appType}", "${company_id}", "${company_name}", "${user_id}", "${expiry_date}")';
    var res = await db.rawInsert(query);
    print(query);
    print(res);
    return res;

  } 

  Future close() async {
    final _db = await instance.database;
    _db.close();
  }

  /////////////////////////get all rows////////////
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    var a = "";
    Database db = await instance.database;

    List<Map<String, dynamic>> list =
        await db.rawQuery('SELECT * FROM tableScanLog');
    print("all data ${list}");
    return list;
  }

//////////////////////////////////////////////
  deleteAllRows() async {
    Database db = await instance.database;
    await db.delete('tableScanLog');
  }

  //////////////////////////////////////
  Future delete(int id) async {
    Database db = await instance.database;
    print("id${id}");
    return await db.rawDelete("DELETE FROM 'tableScanLog' WHERE $id = id");
  }

  ////////////////////////////////////
  ///
  Future findCount() async {
    Database db = await instance.database;
    print(await db.rawQuery('SELECT count(*) FROM tableScanLog'));
  }
  /////////////////select company nme////////////////
   Future<List<Map<String, dynamic>>> getCompanyDetails() async {
    
    Database db = await instance.database;

    List<Map<String, dynamic>> list =
        await db.rawQuery('SELECT * FROM tableRegistration');
    print("company details-- ${list}");
    return list;
  }
  ////////////////////////////////////////////////////////
  deleteAllRowsCompany() async {
    Database db = await instance.database;
    await db.delete('tableScanLog');
  }
  /////////////////////////////////////////////////////////
  getColumnnames() async{
     Database db = await instance.database;
         var list =await db.query("SELECT barcode,time FROM 'tableScanLog' WHERE 1=0");
    return list;
  }
}
