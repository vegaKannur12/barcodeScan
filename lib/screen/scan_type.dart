import 'package:barcodescanner/screen/barcode_scan_scree.dart';
import 'package:flutter/material.dart';

class ScanType extends StatefulWidget {
  const ScanType({Key? key}) : super(key: key);

  @override
  State<ScanType> createState() => _ScanTypeState();
}

class _ScanTypeState extends State<ScanType> {
  List<String> scanType = [
    "Free to Scan",
    "Free to Scan with qty",
    "Api Scan",
    "Api Scan with qty"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Scan Type"),
      ),
      body: ListView.builder(
          itemCount: scanType.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BarcodeScannerScreen()),
                );
              },
              tileColor: Colors.grey,
              title: Text(scanType[index]),
            );
          }),
    );
  }
}
