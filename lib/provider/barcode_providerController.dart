// import 'dart:convert';

// import 'package:barcodescanner/provider/barcode_providerModel.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;

// class Controller extends ChangeNotifier {
//   List<Data?> datalist = [];
//   List<Data?> newDatalist = [];
//   /////////////////////////////////////////
//    postData(String barcode) async {
  
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
//         datalist = barcodeModel.data!;
//         //print(datalist.length);

//         datalist.map((e) {
//           newDatalist.add(e);
          
//           // print("item ${e!.product}");
//         },).toList();
//         print(newDatalist.length);
        
//         newDatalist.map((e) {
//           print("product name-----------${e!.product}");
//         }).toList();
//         // datalist.clear();
//         //print("new datalist-------${newDatalist}");
//         notifyListeners();
//       } catch (e) {
//         print(e);
//         return null;
//       }
    
//   }
//   ////////////////////////////////////////
// }
