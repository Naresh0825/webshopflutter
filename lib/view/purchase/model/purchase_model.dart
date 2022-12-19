// To parse this JSON data, do
//
//     final purchaseModel = purchaseModelFromJson(jsonString);

import 'dart:convert';

PurchaseModel purchaseModelFromJson(String str) => PurchaseModel.fromJson(json.decode(str));

String purchaseModelToJson(PurchaseModel data) => json.encode(data.toJson());

class PurchaseModel {
  PurchaseModel({
    this.success,
    this.responseType,
    this.message,
    this.data,
  });

  bool? success;
  int? responseType;
  String? message;
  List<Purchase>? data;

  factory PurchaseModel.fromJson(Map<String, dynamic> json) => PurchaseModel(
        success: json["success"],
        responseType: json["responseType"],
        message: json["message"],
        data: List<Purchase>.from(json["data"].map((x) => Purchase.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "responseType": responseType,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Purchase {
  Purchase({
    this.purId,
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
    this.purDpqty,
    this.purDrate,
    this.purDAmount,
    this.stDes,
    this.purchaseList,
    this.purchaseDetailDtoList,
  });

  int? purId;
  int? purType;
  String? purDate;
  int? purSupId;
  int? purMode;
  String? purBillNo;
  int? purCashCredit;
  String? purInsertedDate;
  int? purInsertedBy;
  dynamic purSubAmount;
  dynamic purDiscAmount;
  dynamic purTaxableAmount;
  dynamic purNonTaxableAmount;
  dynamic purVatAmount;
  double? purTotalAmount;
  dynamic purRemark;
  bool? purInActive;
  dynamic purImage;
  String? supplier;
  dynamic purInsertedStaff;
  dynamic purDpqty;
  dynamic purDrate;
  dynamic purDAmount;
  dynamic stDes;
  dynamic purchaseList;
  dynamic purchaseDetailDtoList;

  factory Purchase.fromJson(Map<String, dynamic> json) => Purchase(
        purId: json["purId"],
        purType: json["purType"],
        purDate: json["purDate"],
        purSupId: json["purSupId"],
        purMode: json["purMode"],
        purBillNo: json["purBillNo"],
        purCashCredit: json["purCashCredit"],
        purInsertedDate: json["purInsertedDate"],
        purInsertedBy: json["purInsertedBy"],
        purSubAmount: json["purSubAmount"],
        purDiscAmount: json["purDiscAmount"],
        purTaxableAmount: json["purTaxableAmount"],
        purNonTaxableAmount: json["purNonTaxableAmount"],
        purVatAmount: json["purVatAmount"],
        purTotalAmount: json["purTotalAmount"],
        purRemark: json["purRemark"],
        purInActive: json["purInActive"],
        purImage: json["purImage"],
        supplier: json["supplier"],
        purInsertedStaff: json["purInsertedStaff"],
        purDpqty: json["purDPQTY"],
        purDrate: json["purDRATE"],
        purDAmount: json["purDAmount"],
        stDes: json["stDes"],
        purchaseList: json["purchaseList"],
        purchaseDetailDtoList: json["purchaseDetailDTOList"],
      );

  Map<String, dynamic> toJson() => {
        "purId": purId,
        "purType": purType,
        "purDate": purDate,
        "purSupId": purSupId,
        "purMode": purMode,
        "purBillNo": purBillNo,
        "purCashCredit": purCashCredit,
        "purInsertedDate": purInsertedDate,
        "purInsertedBy": purInsertedBy,
        "purSubAmount": purSubAmount,
        "purDiscAmount": purDiscAmount,
        "purTaxableAmount": purTaxableAmount,
        "purNonTaxableAmount": purNonTaxableAmount,
        "purVatAmount": purVatAmount,
        "purTotalAmount": purTotalAmount,
        "purRemark": purRemark,
        "purInActive": purInActive,
        "purImage": purImage,
        "supplier": supplier,
        "purInsertedStaff": purInsertedStaff,
        "purDPQTY": purDpqty,
        "purDRATE": purDrate,
        "purDAmount": purDAmount,
        "stDes": stDes,
        "purchaseList": purchaseList,
        "purchaseDetailDTOList": purchaseDetailDtoList,
      };
}
