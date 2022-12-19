class SalesModel {
  Sales? sales;
  List<SalesItemModel>? tradeSaledetail;
  List<Businesslist>? businesslist;

  SalesModel({this.sales, this.tradeSaledetail, this.businesslist});

  SalesModel.fromJson(Map<String, dynamic> json) {
    sales = json['sales'] != null ? Sales.fromJson(json['sales']) : null;
    if (json['tradeSaledetail'] != null) {
      tradeSaledetail = <SalesItemModel>[];
      json['tradeSaledetail'].forEach((v) {
        tradeSaledetail!.add(SalesItemModel.fromJson(v));
      });
    }
    if (json['businesslist'] != null) {
      businesslist = <Businesslist>[];
      json['businesslist'].forEach((v) {
        businesslist!.add(Businesslist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (sales != null) {
      data['sales'] = sales!.toJson();
    }
    if (tradeSaledetail != null) {
      data['tradeSaledetail'] = tradeSaledetail!.map((v) => v.toJson()).toList();
    }
    if (businesslist != null) {
      data['businesslist'] = businesslist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sales {
  int? traId;
  String? traDate;
  int? traType;
  int? traAgtId;
  String? traBillNo;
  int? traInsertedBy;
  double? traDiscPercent;
  double? traDiscAmount;
  double? traSubAmount;
  double? traTotalAmount;
  String? traRemark;
  bool? traInActive;
  String? traCustomerName;
  String? traCustomerPanNo;
  String? traCustomerAddress;
  String? traCustomerMobileNo;
  String? traInsertedStaff;
  String? billPModeDes;
  int? tranId;

  Sales(
      {this.traId,
      this.traDate,
      this.traType,
      this.traAgtId,
      this.traBillNo,
      this.traInsertedBy,
      this.traDiscPercent,
      this.traDiscAmount,
      this.traSubAmount,
      this.traTotalAmount,
      this.traRemark,
      this.traInActive,
      this.traCustomerName,
      this.traCustomerPanNo,
      this.traCustomerAddress,
      this.traCustomerMobileNo,
      this.traInsertedStaff,
      this.billPModeDes,
      this.tranId});

  Sales.fromJson(Map<String, dynamic> json) {
    traId = json['TraId'];
    traDate = json['TraDate'];
    traType = json['TraType'];
    traAgtId = json['TraAgtId'];
    traBillNo = json['TraBillNo'];
    traInsertedBy = json['TraInsertedBy'];
    traDiscPercent = json['TraDiscPercent'];
    traDiscAmount = json['TraDiscAmount'];
    traSubAmount = json['TraSubAmount'];
    traTotalAmount = json['TraTotalAmount'];
    traRemark = json['TraRemark'];
    traInActive = json['TraInActive'];
    traCustomerName = json['TraCustomerName'];
    traCustomerPanNo = json['TraCustomerPanNo'];
    traCustomerAddress = json['TraCustomerAddress'];
    traCustomerMobileNo = json['TraCustomerMobileNo'];
    traInsertedStaff = json['TraInsertedStaff'];
    billPModeDes = json['BillPModeDes'];
    tranId = json['TranId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TraId'] = traId;
    data['TraDate'] = traDate;
    data['TraType'] = traType;
    data['TraAgtId'] = traAgtId;
    data['TraBillNo'] = traBillNo;
    data['TraInsertedBy'] = traInsertedBy;
    data['TraDiscPercent'] = traDiscPercent;
    data['TraDiscAmount'] = traDiscAmount;
    data['TraSubAmount'] = traSubAmount;
    data['TraTotalAmount'] = traTotalAmount;
    data['TraRemark'] = traRemark;
    data['TraInActive'] = traInActive;
    data['TraCustomerName'] = traCustomerName;
    data['TraCustomerPanNo'] = traCustomerPanNo;
    data['TraCustomerAddress'] = traCustomerAddress;
    data['TraCustomerMobileNo'] = traCustomerMobileNo;
    data['TraInsertedStaff'] = traInsertedStaff;
    data['BillPModeDes'] = billPModeDes;
    data['TranId'] = tranId;
    return data;
  }
}

class SalesItemModel {
  int? traDId;
  int? traDStkId;
  double? traDQty;
  double? traDRate;
  double? traDAmount;
  String? traDStkName;

  SalesItemModel({this.traDId, this.traDStkId, this.traDQty, this.traDRate, this.traDAmount, this.traDStkName});

  SalesItemModel.fromJson(Map<String, dynamic> json) {
    traDId = json['traDId'];
    traDStkId = json['TraDStkId'];
    traDQty = json['TraDQty'];
    traDRate = json['TraDRate'];
    traDAmount = json['TraDAmount'];
    traDStkName = json['TraDStkName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['traDId'] = traDId;
    data['TraDStkId'] = traDStkId;
    data['TraDQty'] = traDQty;
    data['TraDRate'] = traDRate;
    data['TraDAmount'] = traDAmount;
    data['TraDStkName'] = traDStkName;
    return data;
  }
}

class Businesslist {
  int? billId;
  int? billPMode;
  String? billDescription;
  String? billDate;
  double? billTotalAmt;
  int? billCodeId;
  int? billAgtId;
  int? billAddedBy;

  Businesslist({this.billId, this.billPMode, this.billDescription, this.billDate, this.billTotalAmt, this.billCodeId, this.billAgtId, this.billAddedBy});

  Businesslist.fromJson(Map<String, dynamic> json) {
    billId = json['BillId'];
    billPMode = json['BillPMode'];
    billDescription = json['BillDescription'];
    billDate = json['BillDate'];
    billTotalAmt = json['BillTotalAmt'].toDouble(billAddedBy);
    billCodeId = json['BillCodeId'];
    billAgtId = json['BillAgtId'];
    billAddedBy = json['BillAddedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['BillId'] = billId;
    data['BillPMode'] = billPMode;
    data['BillDescription'] = billDescription;
    data['BillDate'] = billDate;
    data['BillTotalAmt'] = billTotalAmt;
    data['BillCodeId'] = billCodeId;
    data['BillAgtId'] = billAgtId;
    data['BillAddedBy'] = billAddedBy;
    return data;
  }
}
