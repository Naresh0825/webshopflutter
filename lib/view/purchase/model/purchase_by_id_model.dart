// To parse this JSON data, do
//
//     final purchaseByIdModel = purchaseByIdModelFromJson(jsonString);

import 'dart:convert';

PurchaseByIdModel purchaseByIdModelFromJson(String str) => PurchaseByIdModel.fromJson(json.decode(str));

String purchaseByIdModelToJson(PurchaseByIdModel data) => json.encode(data.toJson());

class PurchaseByIdModel {
  PurchaseByIdModel({
    this.success,
    this.responseType,
    this.message,
    this.data,
  });

  bool? success;
  int? responseType;
  String? message;
  PurchaseId? data;

  factory PurchaseByIdModel.fromJson(Map<String, dynamic> json) => PurchaseByIdModel(
        success: json["success"],
        responseType: json["responseType"],
        message: json["message"],
        data: PurchaseId.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "responseType": responseType,
        "message": message,
        "data": data!.toJson(),
      };
}

class PurchaseId {
  PurchaseId({
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
  dynamic purchaseList;
  List<PurchaseDetailDtoList>? purchaseDetailDtoList;

  factory PurchaseId.fromJson(Map<String, dynamic> json) => PurchaseId(
        purId: json["purId"],
        purType: json["purType"],
        purDate: json["purDate"],
        purSupId: json["purSupId"],
        purMode: json["purMode"],
        purBillNo: json["purBillNo"],
        purCashCredit: json["purCashCredit"],
        purInsertedDate: json["purInsertedDate"],
        purInsertedBy: json["purInsertedBy"],
        purSubAmount: double.parse(json["purSubAmount"].toString()),
        purDiscAmount: json["purDiscAmount"],
        purTaxableAmount: json["purTaxableAmount"],
        purNonTaxableAmount: double.parse(json["purNonTaxableAmount"].toString()),
        purVatAmount: json["purVatAmount"],
        purTotalAmount: double.parse(json["purTotalAmount"].toString()),
        purRemark: json["purRemark"],
        purInActive: json["purInActive"],
        purImage: json["purImage"],
        supplier: json["supplier"],
        purInsertedStaff: json["purInsertedStaff"],
        purchaseList: json["purchaseList"],
        purchaseDetailDtoList: List<PurchaseDetailDtoList>.from(json["purchaseDetailDTOList"].map((x) => PurchaseDetailDtoList.fromJson(x))),
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
        "purchaseList": purchaseList,
        "purchaseDetailDTOList": List<dynamic>.from(purchaseDetailDtoList!.map((x) => x.toJson())),
      };
}

class PurchaseDetailDtoList {
  PurchaseDetailDtoList({
    this.purDId,
    this.purDMastId,
    this.purDStkId,
    this.purDQty,
    this.purDRate,
    this.purDAmount,
    this.purDSalesRate,
    this.stDes,
    this.purchaseDetailList,
  });

  int? purDId;
  int? purDMastId;
  int? purDStkId;
  int? purDQty;
  double? purDRate;
  double? purDAmount;
  dynamic purDSalesRate;
  String? stDes;
  dynamic purchaseDetailList;

  factory PurchaseDetailDtoList.fromJson(Map<String, dynamic> json) => PurchaseDetailDtoList(
        purDId: json["purDId"],
        purDMastId: json["purDMastId"],
        purDStkId: json["purDStkId"],
        purDQty: json["purDQty"],
        purDRate: double.parse(json["purDRate"].toString()),
        purDAmount: double.parse(json["purDAmount"].toString()),
        purDSalesRate: json["purDSalesRate"],
        stDes: json["stDes"],
        purchaseDetailList: json["purchaseDetailList"],
      );

  Map<String, dynamic> toJson() => {
        "purDId": purDId,
        "purDMastId": purDMastId,
        "purDStkId": purDStkId,
        "purDQty": purDQty,
        "purDRate": purDRate,
        "purDAmount": purDAmount,
        "purDSalesRate": purDSalesRate,
        "stDes": stDes,
        "purchaseDetailList": purchaseDetailList,
      };
}
