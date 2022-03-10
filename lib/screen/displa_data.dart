import 'dart:async';

import 'package:barcodescanner/barcode_dbhelper.dart';
import 'package:barcodescanner/controller/barcodescanner_controller.dart';
import 'package:barcodescanner/db_helper.dart';
import 'package:barcodescanner/model/barcodescanner_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DataDisplay extends StatefulWidget {
  const DataDisplay({Key? key}) : super(key: key);

  @override
  State<DataDisplay> createState() => _DataDisplayState();
}

class _DataDisplayState extends State<DataDisplay> {
  late List<BarcodeClass> data;
  //late List<BarcodeClass> getdata;
  late BarcodeDataSource barcodeDataSource;

  @override
  initState() {
    // TODO: implement initState

    super.initState();
    getData();
    // getdata = getData() as List<BarcodeClass>;
    // barcodeDataSource = BarcodeDataSource(getdata);
  }

   getData() async {
    data =
        (await BarcodeScanlogDB.instance.queryAllRows()).cast<BarcodeClass>();
    barcodeDataSource = BarcodeDataSource(data);
    
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfDataGrid(
        source: barcodeDataSource,
        columns: [
          GridColumn(
            columnName: 'barcode',
            label: Container(
              child: Text(
                "barcode",
                overflow: TextOverflow.ellipsis,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
            ),
          ),
          GridColumn(
            columnName: 'time',
            label: Container(
              child: Text(
                "time",
                overflow: TextOverflow.ellipsis,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
            ),
          ),
        ],
      ),
    );
  }
}

class BarcodeDataSource extends DataGridSource {
  BarcodeDataSource(List<BarcodeClass> datas) {
    dataGridRows = datas
        .map<DataGridRow>((dataGridrow) => DataGridRow(cells: [
              DataGridCell<String>(
                  columnName: 'barcode', value: dataGridrow.barcode),
              DataGridCell<String>(
                  columnName: 'time', value: dataGridrow.datetime),
            ]))
        .toList();
  }
  late List<DataGridRow> dataGridRows;

  @override
  List<DataGridRow> get rows => dataGridRows;
  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    // TODO: implement buildRow
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((datagridcell) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        alignment: (datagridcell.columnName == 'barcode' ||
                datagridcell.columnName == 'time')
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Text(datagridcell.value.toString(),overflow: TextOverflow.ellipsis,),
      );
    }).toList());
  }
}

class BarcodeClass {
  int? id;
  String? barcode;
  String? product;
  String? datetime;
  BarcodeClass({this.id, this.barcode, this.product, this.datetime});
}
