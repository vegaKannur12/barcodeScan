import 'dart:async';
import 'dart:io';

import 'package:barcodescanner/barcode_dbhelper.dart';
import 'package:barcodescanner/controller/barcodescanner_controller.dart';
import 'package:barcodescanner/db_helper.dart';
import 'package:barcodescanner/model/barcodescanner_model.dart';
import 'package:barcodescanner/screen/barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class BarcodeScannerScreen extends StatefulWidget {
  StreamController<bool>? strcontroller;
  BarcodeScannerScreen({ this.strcontroller});
  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScannerScreen> {
  // BarcodeScannerController barcodeController = BarcodeScannerController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String? formattedDate;
  DateTime? now;
  List<Data>? result;
  QRViewController? controller;
  String? _barcodeScanned = "";
  bool _scanCode = false;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 50, right: 20, left: 20),
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.04,
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Barcode  : ",
                      style:
                          TextStyle(fontSize: 20,),
                    ),
                    Container(
                      // height: size.height*0.057,
                      child: Center(
                        child: (_barcodeScanned != null)
                            ? Text(
                                _barcodeScanned.toString(),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )
                            : Text('Scan a code'),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.04,
                ),
                Container(
                  height: size.height * 0.08,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 1,
                      color: Color(0xFF424242),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      count.toString(),
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.08,
                ),
                // GestureDetector(
                //   onLongPress: () {
                //     print("pressed");
                //     _cameraUpdate(true);
                //   },
                //   onLongPressEnd: (_) {
                //     print("long press cancel");
                //     _cameraUpdate(false);
                //   },
                //   child: Container(
                //     child: ElevatedButton(
                //       style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                //       onPressed: () {},
                //       child: Icon(
                //         Icons.camera,
                //         size: 50,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _cameraUpdate(bool _scanStart) {
    if (_scanStart) {
      _scanCode = true;
    } else {
      _scanCode = false;
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      // if (_scanCode) {/
        if (_barcodeScanned == scanData.code) {
          Future.delayed(Duration(seconds: 3), () async {
            _barcodeScanned = "";
          });
        } else {
          
          setState(() {
            _barcodeScanned = scanData.code;
            count = count + 1;
          });
          await FlutterBeep.beep();
          controller.pauseCamera();
          if(_barcodeScanned != null && _barcodeScanned!.isNotEmpty){
          print("barcode----------------${_barcodeScanned}");
          now = DateTime.now();
          formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now!);
         // await BarcodeDB.instance.barcodeTimeStamtttp(_barcodeScanned, formattedDate, count);
         await BarcodeScanlogDB.instance.barcodeTimeStamp(_barcodeScanned, formattedDate, count,1);
         controller.resumeCamera();
          // await BarcodeDB.instance
          //     .queryQtyUpdate(_barcodeScanned, formattedDate, count);
          widget.strcontroller!.add(true);
         // _scanCode = false;
        }}
      // }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
