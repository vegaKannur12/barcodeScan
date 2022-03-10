class BarcodeScannerModel {
  List<Data>? data;

  BarcodeScannerModel({this.data});

  BarcodeScannerModel.fromJson(Map<String, dynamic> json) {
    if (json.isNotEmpty) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? barcode;
  String? brand;
  String? model;
  String? size;
  String? description;
  String? rate;
  String? product;

  Data(
      {this.barcode,
      this.brand,
      this.model,
      this.size,
      this.description,
      this.rate,
      this.product});

  Data.fromJson(Map<String, dynamic> json) {
    barcode = json['Barcode'];
    brand = json['Brand'];
    model = json['Model'];
    size = json['Size'];
    description = json['Description'];
    rate = json['Rate'];
    product = json['Product'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Barcode'] = this.barcode;
    data['Brand'] = this.brand;
    data['Model'] = this.model;
    data['Size'] = this.size;
    data['Description'] = this.description;
    data['Rate'] = this.rate;
    data['Product'] = this.product;
    return data;
  }
}