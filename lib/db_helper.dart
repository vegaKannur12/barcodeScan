// // ignore_for_file: unused_local_variable

// import 'package:barcodescanner/model/barcodescanner_model.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class BarcodeDB {
//   static final BarcodeDB instance = BarcodeDB._init();
//   static Database? _database;
//   BarcodeDB._init();
//   static final id = 'id';
//   static final barcode = 'barcode';
//   static final brand = 'brand';
//   static final model = 'model';
//   static final size = 'size';
//   static final description = 'description';
//   static final rate = 'rate';
//   static final product = 'product';
//   static final time = 'time';
//   static final qty = 'qty';
//   // static final description = 'description';

//   int DB_VERSION = 11;

//   Future<Database> get database async {
//     print("INSIDE BARCODE DATABASE");
//     if (_database != null) return _database!;
//     _database = await _initDB("barcode_db.db");
//     return _database!;
//   }

//   Future<Database> _initDB(String filepath) async {
//     print("INSIDE _initDB");
//     final dbpath = await getDatabasesPath();
//     final path = join(dbpath, filepath);
//     return await openDatabase(path,
//         version: DB_VERSION, onCreate: _createDB, onUpgrade: _upgradeDB);
//   }

//   Future _upgradeDB(Database db, int oldversion, int newVwersion) async {
//     var batch = db.batch();
//     print("version UPGRADE-----------------${oldversion} && ${newVwersion}");
//     if (oldversion == 3) {
//       createTableSCAN1(batch);
//       createTableSCAN2(batch);
//     } else if (oldversion == 4) {
//       createTableSCAN3(batch);
//     } else if (oldversion == 6) {
//       _updateTableScanlog3(batch);
//     } else if (oldversion == 7) {
//       _dropTableScanlog3(batch);
//     } else if (oldversion == 8) {
//       _dropTableScanlog3(batch);
//     } else if (oldversion == 9) {
//       createTableBarcode(batch);
//     } else if (oldversion == 10) {
//       updateTableBarcode(batch);
//     }
//     batch.commit();
//   }

//   createTableSCAN1(Batch batch) {
//     batch.execute('''
//           CREATE TABLE tableScanlog1 (
//             $id INTEGER PRIMARY KEY AUTOINCREMENT,
//             $barcode TEXT NOT NULL,
//             $time TEXT NOT NULL
//           )
//           ''');
//   }

//   createTableSCAN2(Batch batch) {
//     batch.execute('''
//           CREATE TABLE tableScanlog2 (
//             $id INTEGER PRIMARY KEY AUTOINCREMENT,
//             $barcode TEXT NOT NULL,
//             $time TEXT NOT NULL
//           )
//           ''');
//   }

//   createTableSCAN3(Batch batch) {
//     batch.execute('''
//           CREATE TABLE tableScanlog3 (
//             $id INTEGER PRIMARY KEY AUTOINCREMENT,
//             $barcode TEXT NOT NULL,
//             $time TEXT NOT NULL
//           )
//           ''');
//   }

//   createTableBarcode(Batch batch) {
//     batch.execute('''
//           CREATE TABLE tableBarcode (
//             $id INTEGER PRIMARY KEY AUTOINCREMENT,
//             $barcode TEXT NOT NULL,
//             $time TEXT NOT NULL,
//             $qty INTEGER NOT NULL,
//           )
//           ''');
//   }

//   /////////////////////////////////////
//   void _updateTableScanlog3(Batch batch) {
//     batch.execute('ALTER TABLE tableScanlog3 ADD description TEXT');
//   }

//   void updateTableBarcode(Batch batch) {
//     batch.execute('ALTER TABLE tableBarcode ADD qty INTEGER');
//   }

//   ///////////////////////////////////

//   void _dropTableScanlog3(Batch batch) {
//     batch.execute('DROP TABLE tableScanlog3');
//   }

//   ////////////////////////////////////
//   Future _createDB(Database db, int version) async {
//     var batch = db.batch();
//     print("version on create -----------------${version}");
//     batch.execute('''
//           CREATE TABLE tableBarcode1 (
//             $id INTEGER PRIMARY KEY AUTOINCREMENT,
//             $barcode TEXT NOT NULL,
//             $time TEXT NOT NULL
//           )
//           ''');
//     batch.commit();
//   }

//   Future insertBarcode(Data barcodeData) async {
//     final db = await database;
//     var query =
//         'INSERT INTO tableBarcode1(barcode, brand, model, size, description , rate, product) VALUES("${barcodeData.barcode}", "${barcodeData.brand}", "${barcodeData.model}", "${barcodeData.size}", "${barcodeData.description}", "${barcodeData.rate}", "${barcodeData.product}")';
//     var res = await db.rawInsert(query);
//     print(query);
//     print(res);
//     return res;
//   }

//   Future barcodeTimeStamtttp(String? barcode, String? time, int qty) async {
//     print("INSIDE BARCODE TIME STAMP");
//     final db = await database;
//     var query =
//         'INSERT INTO tableBarcode(barcode, time, qty) VALUES("${barcode}", "${time}", ${qty})';
//     var res = await db.rawInsert(query);
//     print(query);
//     print(res);
//     return res;
//   }

//   ////////////////////////////////////////////////
//   Future barcodeTimeStamp(
//       String? barcode, String time, String description) async {
//     print("INSIDE BARCODE TIME STAMP");
//     _database = null;
//     final db = await database;
//     var query =
//         'INSERT INTO tableScanlog3(barcode, time, description) VALUES("${barcode}", "${time}", "${description}")';
//     var res = await db.rawInsert(query);
//     print(query);
//     print(res);
//     return res;
//   }

//   Future close() async {
//     final _db = await instance.database;
//     _db.close();
//   }

//   /////////////////////////get all rows////////////
//   Future<List<Map<String, dynamic>>> queryAllRows() async {
//     var a = "";
//     Database db = await instance.database;

//     List<Map<String, dynamic>> list =
//         await db.rawQuery('SELECT * FROM tableBarcode');
//     print("all data ${list}");
//     return list;
//   }

// /////////////////////////////////////////////////
//   Future<List<Map<String, dynamic>>> queryQtyUpdate(
//       String? barcode, String? time, int? qty) async {
//     Database db = await instance.database;
//     List<Map<String, Object?>> map = await db
//         .rawQuery('SELECT * FROM tableBarcode WHERE barcode="${barcode}"');
//     print("mappppppppppppp----------${map}");
//     if (map.isEmpty) {
//       var query =
//           'INSERT INTO tableBarcode(barcode, time, qty) VALUES("${barcode}", "${time}", ${qty})';
//       var res = await db.rawInsert(query);
//     } else {
//       var quantity = map[0]["qty"];
//       var id = map[0]["id"];
//       print("qty---------------------------${quantity}");
//       var updatedQty = int.parse(quantity.toString()) + 1;
//       var query =
//           'UPDATE tableBarcode SET qty=${updatedQty} WHERE id=${id} ';
//       var res = await db.rawInsert(query);
//     }
//     return map;
//   }

// //////////////////////////////////////////////
//   deleteAllRows() async {
//     Database db = await instance.database;
//     await db.delete('tableBarcode');
//   }

// ////////////////////////////////////////////////
//   Future delete(int id) async {
//     Database db = await instance.database;
//     print("id${id}");
//     return await db.rawDelete("DELETE FROM 'tableBarcode' WHERE $id = id");
//   }
// }
