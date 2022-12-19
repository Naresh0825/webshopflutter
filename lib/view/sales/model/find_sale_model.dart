// To parse this JSON data, do
//
//     final findSaleModel = findSaleModelFromJson(jsonString);

import 'dart:convert';

FindSaleModel findSaleModelFromJson(String str) => FindSaleModel.fromJson(json.decode(str));

String findSaleModelToJson(FindSaleModel data) => json.encode(data.toJson());

class FindSaleModel {
  FindSaleModel({
    this.success,
    this.responseType,
    this.message,
    this.data,
  });

  bool? success;
  int? responseType;
  String? message;
  List<FindSale>? data;

  factory FindSaleModel.fromJson(Map<String, dynamic> json) => FindSaleModel(
        success: json["success"],
        responseType: json["responseType"],
        message: json["message"],
        data: List<FindSale>.from(json["data"].map((x) => FindSale.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "responseType": responseType,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class FindSale {
  FindSale({
    this.traId,
    this.traDate,
    this.traType,
    this.traAgtId,
    this.traBillNo,
    this.traInsertedBy,
    this.traSubAmount,
    this.traDiscPercent,
    this.traDiscAmount,
    this.traNonTaxableAmount,
    this.traTaxableAmount,
    this.traVatAmount,
    this.traTotalAmount,
    this.traRemark,
    this.traInActive,
    this.deletedOn,
    this.deletedBy,
    this.traCustomerName,
    this.traCustomerPanNo,
    this.traCustomerAddress,
    this.traCustomerMobileNo,
    this.traPrint,
    this.agent,
    this.traInsertedStaff,
    this.tradConfirm,
    this.billPMode,
    this.billPModeDes,
    this.traTypeMode,
    this.salesAmount,
    this.creditAmt,
    this.tradeSaleList,
    this.tradeSaleDetailDtoList,
    this.businessDtoList,
  });

  int? traId;
  String? traDate;
  int? traType;
  int? traAgtId;
  String? traBillNo;
  int? traInsertedBy;
  int? traSubAmount;
  int? traDiscPercent;
  dynamic traDiscAmount;
  dynamic traNonTaxableAmount;
  dynamic traTaxableAmount;
  dynamic traVatAmount;
  double? traTotalAmount;
  String? traRemark;
  bool? traInActive;
  dynamic deletedOn;
  dynamic deletedBy;
  String? traCustomerName;
  String? traCustomerPanNo;
  String? traCustomerAddress;
  dynamic traCustomerMobileNo;
  dynamic traPrint;
  dynamic agent;
  String? traInsertedStaff;
  int? tradConfirm;
  dynamic billPMode;
  dynamic billPModeDes;
  String? traTypeMode;
  double? salesAmount;
  double? creditAmt;
  dynamic tradeSaleList;
  dynamic tradeSaleDetailDtoList;
  dynamic businessDtoList;

  factory FindSale.fromJson(Map<String, dynamic> json) => FindSale(
        traId: json["traId"],
        traDate: json["traDate"],
        traType: json["traType"],
        traAgtId: json["traAgtId"],
        traBillNo: json["traBillNo"],
        traInsertedBy: json["traInsertedBy"],
        traSubAmount: json["traSubAmount"],
        traDiscPercent: json["traDiscPercent"],
        traDiscAmount: json["traDiscAmount"],
        traNonTaxableAmount: json["traNonTaxableAmount"],
        traTaxableAmount: json["traTaxableAmount"],
        traVatAmount: json["traVatAmount"],
        traTotalAmount: json["traTotalAmount"].toDouble(),
        traRemark: json["traRemark"],
        traInActive: json["traInActive"],
        deletedOn: json["deletedOn"],
        deletedBy: json["deletedBy"],
        traCustomerName: json["traCustomerName"],
        traCustomerPanNo: json["traCustomerPanNo"],
        traCustomerAddress: json["traCustomerAddress"],
        traCustomerMobileNo: json["traCustomerMobileNo"],
        traPrint: json["traPrint"],
        agent: json["agent"],
        traInsertedStaff: json["traInsertedStaff"],
        tradConfirm: json["tradConfirm"],
        billPMode: json["billPMode"],
        billPModeDes: json["billPModeDes"],
        traTypeMode: json["traTypeMode"],
        salesAmount: json["salesAmount"],
        creditAmt: json["creditAmt"],
        tradeSaleList: json["tradeSaleList"],
        tradeSaleDetailDtoList: json["tradeSaleDetailDTOList"],
        businessDtoList: json["businessDTOList"],
      );

  Map<String, dynamic> toJson() => {
        "traId": traId,
        "traDate": traDate,
        "traType": traType,
        "traAgtId": traAgtId,
        "traBillNo": traBillNo,
        "traInsertedBy": traInsertedBy,
        "traSubAmount": traSubAmount,
        "traDiscPercent": traDiscPercent,
        "traDiscAmount": traDiscAmount,
        "traNonTaxableAmount": traNonTaxableAmount,
        "traTaxableAmount": traTaxableAmount,
        "traVatAmount": traVatAmount,
        "traTotalAmount": traTotalAmount,
        "traRemark": traRemark,
        "traInActive": traInActive,
        "deletedOn": deletedOn,
        "deletedBy": deletedBy,
        "traCustomerName": traCustomerName,
        "traCustomerPanNo": traCustomerPanNo,
        "traCustomerAddress": traCustomerAddress,
        "traCustomerMobileNo": traCustomerMobileNo,
        "traPrint": traPrint,
        "agent": agent,
        "traInsertedStaff": traInsertedStaff,
        "tradConfirm": tradConfirm,
        "billPMode": billPMode,
        "billPModeDes": billPModeDes,
        "traTypeMode": traTypeMode,
        "salesAmount": salesAmount,
        "creditAmt": creditAmt,
        "tradeSaleList": tradeSaleList,
        "tradeSaleDetailDTOList": tradeSaleDetailDtoList,
        "businessDTOList": businessDtoList,
      };
}
