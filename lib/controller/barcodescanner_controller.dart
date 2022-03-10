// import 'dart:convert';

// import 'package:barcodescanner/db_helper.dart';
// import 'package:barcodescanner/model/barcodescanner_model.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:qr_code_scanner/qr_code_scanner.dart';

// class BarcodeScannerController {
//   late Data dataDetails;
//   ///////////////////////////////////
//   Future postData(String barcode, BuildContext context) async {
   
//       try {
//         Uri url = Uri.parse("https://aiwasilks.in/reports/check_barcode.php");
//         Map<String, dynamic> body = {'barcode': barcode};

//         http.Response response = await http.post(
//           url,
//           body: body,
//         );
//         var map = jsonDecode(response.body);
//         print("from post data ${map}");
//         BarcodeScannerModel barcodeModel = BarcodeScannerModel.fromJson(map);
//         for (var item in barcodeModel.data!) {
          
//           dataDetails = Data(
//               barcode: item.barcode,
//               brand: item.brand,
//               model: item.model,
//               size: item.size,
//               description: item.description,
//               rate: item.rate,
//               product: item.product);
//           var res = await BarcodeDB.instance.insertBarcode(dataDetails);
//         }
//         return barcodeModel.data;
//       } catch (e) {
//         print(e);
//         return null;
//       }
    
//   }
// }
