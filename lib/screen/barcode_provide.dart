// import 'dart:async';

// import 'package:barcodescanner/controller/barcodescanner_controller.dart';
// import 'package:barcodescanner/db_helper.dart';
// import 'package:barcodescanner/model/barcodescanner_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:provider/provider.dart';

// class BarcodeScanner extends StatefulWidget {
//   const BarcodeScanner({Key? key}) : super(key: key);

//   @override
//   State<BarcodeScanner> createState() => _BarcodeScannerState();
// }

// class _BarcodeScannerState extends State<BarcodeScanner> {
//   var flag = 0;
//   BarcodeScannerController barcodeController = BarcodeScannerController();
//   StreamController<bool> controller = StreamController();
//   String barcode = "No Data";

//   Future<void> scanbarcode() async {
//     try {
//       final barcode = await FlutterBarcodeScanner.scanBarcode(
//           "#ff6666", "cancel", true, ScanMode.BARCODE);
//       if (!mounted) return;

//       setState(() {
//         this.barcode = barcode;
//       });
//       print("three 3");
//       barcodeController.postData(barcode);
//     } on PlatformException {
//       barcode = "failed";
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("1 first");
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Scanner"),
//           actions: [
//             IconButton(
//                 onPressed: () {
//                   controller.add(true);
//                 },
//                 icon: Icon(Icons.refresh)),
//             IconButton(
//               onPressed: () {
//                 BarcodeDB.instance.deleteAllRows();
//                 controller.add(true);
//               },
//               icon: Icon(Icons.delete),
//             ),
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             print("second------ 2");
//             scanbarcode();
//           },
//           child: Icon(Icons.scanner),
//         ),
//         body: Consumer<BarcodeScannerController>(
//           builder: (context, value, child) {
//              if (value.datalist == null) {
//             return Center(
//               child: Text("No data..........")
//             );
//           } else {
//             return ListView.builder(
//                 itemCount: value.datalist!.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(value.datalist[index]!.barcode.toString()),
//                   );
//                 });
//           }}
//         ),);
//   }
// }
