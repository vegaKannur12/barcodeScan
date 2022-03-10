import 'dart:io';

import 'package:barcodescanner/barcode_dbhelper.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';

class CreateDir extends StatefulWidget {
  const CreateDir({Key? key}) : super(key: key);

  @override
  State<CreateDir> createState() => _CreateDirState();
}

class _CreateDirState extends State<CreateDir> {
  late String attachment;
  late String appDocumentsPath;
  List<Map<String,dynamic>> data=[];
  late List<List<dynamic>> scan1;

  getData() async {
    data = await BarcodeScanlogDB.instance.queryAllRows();
    print("data......${data}");
    
    for (var i = 0; i < data.length; i++) {
      List<dynamic> row = List.empty(growable: true);
      row.add('${data[i]["barcode"]}');
      row.add('${data[i]["time"]}');
      scan1.add(row);
    }
    print("scan--------------${scan1}");
  }

  Future<String> createFolderInAppDocDir(String folderName) async {
    String filePath;
    //Get this App Document Directory

    final Directory _appDocDir = await getApplicationDocumentsDirectory();
    //App Document Directory + folder name
    final Directory _appDocDirFolder =
        Directory('${_appDocDir.path}/$folderName/');

    if (await _appDocDirFolder.exists()) {
      //if folder already exists return path
      print("old---------------${_appDocDirFolder.path}");
      appDocumentsPath = _appDocDirFolder.path; 
    } else {
      //if folder not exists create folder and then return its path
      final Directory _appDocDirNewFolder =
          await _appDocDirFolder.create(recursive: true);
      print("new---------------${_appDocDirNewFolder.path}");
      appDocumentsPath = _appDocDirNewFolder.path; 
    }
    
    filePath = '$appDocumentsPath/demoTextFile.csv';
    print("filepath--------${filePath}");
    String csv=ListToCsvConverter().convert(scan1);
    File file = await File(filePath).create(recursive: true);
    file.writeAsString(csv);
    print(file);
    return filePath;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    scan1 = List<List<dynamic>>.empty(growable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: ElevatedButton(
            child: Text("click"),
            onPressed: () async {
              attachment = await createFolderInAppDocDir("csv1");
              final Email email = Email(
                body: 'Email body',
                subject: 'Email subject',
                // Rrecipients: ['anugrahaamal9594@gmail.com'],
                attachmentPaths: ['${attachment}'],
                isHTML: false,
              );
              await FlutterEmailSender.send(email);
            },
          ),
        ),
      ),
    );
  }
}
