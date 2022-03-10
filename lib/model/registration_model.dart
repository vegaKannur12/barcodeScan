class RegistrationModel {
  int? errStatus;
  String? msg;
  String? companyId;
  String? companyName;
  String? expiryDate;
  String? userId;

  RegistrationModel(
      {this.errStatus,
      this.msg,
      this.companyId,
      this.companyName,
      this.expiryDate,
      this.userId});

  RegistrationModel.fromJson(Map<String, dynamic> json) {
    errStatus = json['err_status'];
    msg = json['msg'];
    companyId = json['CompanyId'];
    companyName = json['CompanyName'];
    expiryDate = json['ExpiryDate'];
    userId = json['UserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['err_status'] = this.errStatus;
    data['msg'] = this.msg;
    data['CompanyId'] = this.companyId;
    data['CompanyName'] = this.companyName;
    data['ExpiryDate'] = this.expiryDate;
    data['UserId'] = this.userId;
    return data;
  }
}