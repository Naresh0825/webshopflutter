class PurchaseByBillModel {
  bool? success;
  int? responseType;
  String? message;
  BillPurchase? data;

  PurchaseByBillModel({this.success, this.responseType, this.message, this.data});

  PurchaseByBillModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    responseType = json['responseType'];
    message = json['message'];
    data = json['data'] != null ? BillPurchase.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['responseType'] = responseType;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class BillPurchase {
  int? purId;
  int? purType;
  String? purDate;
  int? purSupId;
  int? purMode;
  String? purBillNo;
  double? purCashCredit;
  String? purInsertedDate;
  int? purInsertedBy;
  double? purSubAmount;
  double? purDiscAmount;
  double? purTaxableAmount;
  double? purNonTaxableAmount;
  double? purVatAmount;
  double? purTotalAmount;
  dynamic purRemark;
  bool? purInActive;
  dynamic purImage;
  String? supplier;
  dynamic purInsertedStaff;
  dynamic purDPQTY;
  dynamic purDRATE;
  dynamic purDAmount;
  dynamic stDes;
  dynamic purchaseList;
  dynamic purchaseDetailDTOList;

  BillPurchase(
      {this.purId,
      this.purType,
      this.purDate,
      this.purSupId,
      this.purMode,
      this.purBillNo,
      this.purCashCredit,
      this.purInsertedDate,
      this.purInsertedBy,
      this.purSubAmount,
      this.purDiscAmount,
      this.purTaxableAmount,
      this.purNonTaxableAmount,
      this.purVatAmount,
      this.purTotalAmount,
      this.purRemark,
      this.purInActive,
      this.purImage,
      this.supplier,
      this.purInsertedStaff,
      this.purDPQTY,
      this.purDRATE,
      this.purDAmount,
      this.stDes,
      this.purchaseList,
      this.purchaseDetailDTOList});

  BillPurchase.fromJson(Map<String, dynamic> json) {
    purId = json['purId'];
    purType = json['purType'];
    purDate = json['purDate'];
    purSupId = json['purSupId'];
    purMode = json['purMode'];
    purBillNo = json['purBillNo'];
    purCashCredit = double.parse(json['purCashCredit'].toString());
    purInsertedDate = json['purInsertedDate'];
    purInsertedBy = json['purInsertedBy'];
    purSubAmount = double.parse(json['purSubAmount'].toString());
    purDiscAmount = double.parse(json['purDiscAmount'].toString());
    purTaxableAmount = double.parse(json['purTaxableAmount'].toString());
    purNonTaxableAmount = double.parse(json['purNonTaxableAmount'].toString());
    purVatAmount = double.parse(json['purVatAmount'].toString());
    purTotalAmount = double.parse(json['purTotalAmount'].toString());
    purRemark = json['purRemark'];
    purInActive = json['purInActive'];
    purImage = json['purImage'];
    supplier = (json['supplier'] == null) ? '' : json['supplier'];
    purInsertedStaff = json['purInsertedStaff'];
    purDPQTY = json['purDPQTY'];
    purDRATE = json['purDRATE'];
    purDAmount = json['purDAmount'];
    stDes = json['stDes'];
    purchaseList = json['purchaseList'];
    purchaseDetailDTOList = json['purchaseDetailDTOList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['purId'] = purId;
    data['purType'] = purType;
    data['purDate'] = purDate;
    data['purSupId'] = purSupId;
    data['purMode'] = purMode;
    data['purBillNo'] = purBillNo;
    data['purCashCredit'] = purCashCredit;
    data['purInsertedDate'] = purInsertedDate;
    data['purInsertedBy'] = purInsertedBy;
    data['purSubAmount'] = purSubAmount;
    data['purDiscAmount'] = purDiscAmount;
    data['purTaxableAmount'] = purTaxableAmount;
    data['purNonTaxableAmount'] = purNonTaxableAmount;
    data['purVatAmount'] = purVatAmount;
    data['purTotalAmount'] = purTotalAmount;
    data['purRemark'] = purRemark;
    data['purInActive'] = purInActive;
    data['purImage'] = purImage;
    data['supplier'] = supplier;
    data['purInsertedStaff'] = purInsertedStaff;
    data['purDPQTY'] = purDPQTY;
    data['purDRATE'] = purDRATE;
    data['purDAmount'] = purDAmount;
    data['stDes'] = stDes;
    data['purchaseList'] = purchaseList;
    data['purchaseDetailDTOList'] = purchaseDetailDTOList;
    return data;
  }
}
