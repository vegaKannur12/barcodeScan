// import 'package:barcodescanner/provider/barcode_providerController.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:flutter_beep/flutter_beep.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter/material.dart';

// class Barcode extends StatefulWidget {
//   Barcode({Key? key}) : super(key: key);

//   @override
//   State<Barcode> createState() => _BarcodeState();
// }

// class _BarcodeState extends State<Barcode> {
//   // ValueNotifier<String> barcodeValue = ValueNotifier("");
//   String result = "";
  
//   Controller controller = Controller();

//   //////////////////////////////////////////////////////////
//   Future startBarcodeScanStream(BuildContext context) async {
//     try {
//       FlutterBarcodeScanner.getBarcodeStreamReceiver(
//               "#ff6666", "Cancel", true, ScanMode.BARCODE)!
//           .listen((barcode) async {
//             print("barcode--------------- ${barcode}");
//         if (barcode != "-1") {
//           await FlutterBeep.beep();

//           await Provider.of<Controller>(context, listen: false).postData(barcode);
//         } 

//        // print("barcode after scann ${barcodeValue}");
       
         
//         // await controller.postData(_scanBarcode);
//       });
//     } on FormatException{
//       setState(() {
//         result = "You pressed the back button before scanning anything";
//         print(result);
//       });
//     }
//   }

// ///////////////////////////////////////////////////////
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("sacnner"),
//         actions: [
//           IconButton(
//             onPressed: () {
//               // context.read<Controller>().newDatalist.clear();

//               Provider.of<Controller>(context, listen: false)
//                   .newDatalist
//                   .clear();
//             },
//             icon: Icon(Icons.delete),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           startBarcodeScanStream(context);
//         },
//         child: const Icon(Icons.scanner),
//       ),
//       body: Consumer<Controller>(
//         builder: (context, value, child) {
//           if (value.newDatalist == null) {
//             return const Center(
//               child: Text("No Data..........."),
//             );
//           } else {
//             print(
//                 "length list view---------------------${value.newDatalist.length}");
//                 // for(var i=0;i<value.newDatalist.length;i++){
//                 //   return Row(
//                 //     children: [
//                 //       Text(value.newDatalist[i]!.product.toString()),
//                 //       Text(value.newDatalist[i]!.barcode.toString()),
//                 //       Text(value.newDatalist[i]!.rate.toString()),
//                 //     ],
//                 //   );
//                 // }
//                 // return Container();
//             return ListView.builder(
//                 itemCount: value.newDatalist.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       children: [
//                         //SizedBox(height: size.height*0.03,),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Container(
//                               width: size.width * 0.25,
//                               child: Text(
//                                   value.newDatalist[index]!.product.toString()),
//                             ),
//                             Container(
//                               width: size.width * 0.25,
//                               child: Text(
//                                   value.newDatalist[index]!.barcode.toString()),
//                             ),
//                             Container(
//                               width: size.width * 0.25,
//                               child: Text(
//                                   value.newDatalist[index]!.rate.toString()),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   );
//                 });
//           }
//         },
//       ),
//     );
//   }
// }



