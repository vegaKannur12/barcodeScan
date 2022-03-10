import 'dart:async';
import 'dart:io';

import 'package:barcodescanner/barcode_dbhelper.dart';
import 'package:barcodescanner/screen/barcode_scan_scree.dart';
import 'package:barcodescanner/screen/createDir.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';

class BarcodeScanner extends StatefulWidget {
  // String? companyName;
  // BarcodeScanner({ this.companyName});
  @override
  State<BarcodeScanner> createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner> {
  // List columnNames=[];
  late String attachment;
  late String appDocumentsPath;
  List<Map<String, dynamic>> data = [];
  late List<List<dynamic>> scan1;
  late List<List<dynamic>> scanResult;

  CreateDir createdir = CreateDir();
  var flag = 0;
  // BarcodeScannerController barcodeController = BarcodeScannerController();
  StreamController<bool> controller = StreamController();
  String barcode = "No Data";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scan1 = List<List<dynamic>>.empty(growable: true);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<List<Map<String, dynamic>>>(
            future: BarcodeScanlogDB.instance.getCompanyDetails(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }
              //  return Text(snapshot.data);
              return Text(snapshot.data![0]["company_name"]);
            }),

        // title: Text(widget.companyName != null ? widget.companyName.toString():"scanner"),
        actions: [
          // IconButton(
          //     onPressed: () {
          //       controller.add(true);
          //     },
          //     icon: Icon(Icons.refresh)),

          IconButton(
            onPressed: () {
              _showDialog(context);
            },
            icon: Icon(Icons.delete),
          ),
          PopupMenuButton(
            color: Color.fromARGB(255, 241, 235, 235),
            elevation: 20,
            enabled: true,
            onSelected: (value) async {
              attachment = await createFolderInAppDocDir("csv");
              final Email email = Email(
                body: 'Barcode result',
                subject: 'Barcode',
                // recipients: ['anugrahaamal9594@gmail.com'],
                attachmentPaths: ['${attachment}'],
                isHTML: false,
              );
              await FlutterEmailSender.send(email);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("Share to mail"),
                value: "first",
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BarcodeScannerScreen(
                          strcontroller: controller,
                        )),
              );
            },
            child: Icon(Icons.scanner),
          ),
        ],
      ),
      body: StreamBuilder<bool>(
          stream: controller.stream,
          builder: (context, snap) {
            return FutureBuilder<List<Map<String, dynamic>>>(
              future: BarcodeScanlogDB.instance.queryAllRows(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SpinKitWave(
                    color: Colors.black,
                    size: 50.0,
                  );
                }
                if (snapshot.data == null || snapshot.data!.isEmpty) {
                  // _isEnabled = false;
                  return Center(
                    child: Text("No Data"),
                  );
                }
                return Container(
                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: size.width * 0.25,
                            child: Text("Barcode",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            width: size.width * 0.3,
                            child: Text("Date & Time",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                          Container(),
                          // Container(
                          //   child: Text("Quantity",
                          //       style: TextStyle(
                          //           fontSize: 18, fontWeight: FontWeight.bold)),
                          // )
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  //SizedBox(height: size.height*0.03,),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                          width: size.width * 0.25,
                                          child: Text(snapshot.data![index]
                                              ["barcode"])),
                                      Container(
                                          width: size.width * 0.3,
                                          child: Text(
                                              snapshot.data![index]["time"])),
                                      Container(
                                        child: IconButton(
                                            onPressed: () {
                                              BarcodeScanlogDB.instance.delete(
                                                  snapshot.data![index]["id"]);
                                              controller.add(true);
                                            },
                                            icon: Icon(Icons.delete)),
                                      ),
                                      // Container(
                                      //   child: Text(snapshot.data![index]["qty"]
                                      //       .toString()),
                                      // )
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
    );
  }

  // _isButtonPress() {
  //   print("button kldjlkjdslk-----${_isButtonDisabled}");
  //   if (_isButtonDisabled) {
  //     return null;
  //   } else {
  //     return () {
  //       // do anything else you may want to here
  //       _showDialog(context);
  //     };
  //   }
  // }

  //////////////////////////////////////////////////
  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new Text("Are u sure! u want to delete?"),
          actions: <Widget>[
            ElevatedButton(
              child: new Text("OK"),
              onPressed: () {
                BarcodeScanlogDB.instance.deleteAllRows();
                controller.add(true);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  ///////////////////////////////////////////////////////
  Future<List<List>> getData() async {
    data = await BarcodeScanlogDB.instance.queryAllRows();
    // columnNames = await BarcodeScanlogDB.instance.getColumnnames();
    List<String> columnNames = ["Barcode", "Time"];
    scan1.add(columnNames);
    for (var i = 0; i < data.length; i++) {
      List<dynamic> row = List.empty(growable: true);
      row.add('${data[i]["barcode"]}');
      row.add('${data[i]["time"]}');
      scan1.add(row);
    }
    return scan1;
  }

//////////////////////////////////////////////////////////////////
  Future<String> createFolderInAppDocDir(String folderName) async {
    String filePath;
    //Get this App Document Directory
    scanResult = await getData();
    final Directory _appDocDir = await getApplicationDocumentsDirectory();
    //App Document Directory + folder name
    final Directory _appDocDirFolder =
        Directory('${_appDocDir.path}/$folderName/');
    if (await _appDocDirFolder.exists()) {
      //if folder already exists return path
      appDocumentsPath = _appDocDirFolder.path;
    } else {
      //if folder not exists create folder and then return its path
      final Directory _appDocDirNewFolder =
          await _appDocDirFolder.create(recursive: true);
      appDocumentsPath = _appDocDirNewFolder.path;
    }
    filePath = '$appDocumentsPath/barcodeResult.csv';
    //String header = "barcode,time\n";
    String csv =
        ListToCsvConverter(fieldDelimiter: ",", eol: "\n").convert(scanResult);
    File file = await File(filePath).create(recursive: true);
    file.writeAsString(csv);
    return filePath;
  }
}
