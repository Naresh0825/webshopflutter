// To parse this JSON data, do
//
//     final searchSalesByBillNo = searchSalesByBillNoFromJson(jsonString);

import 'dart:convert';

SearchSalesByBillNo searchSalesByBillNoFromJson(String str) => SearchSalesByBillNo.fromJson(json.decode(str));

String searchSalesByBillNoToJson(SearchSalesByBillNo data) => json.encode(data.toJson());

class SearchSalesByBillNo {
  SearchSalesByBillNo({
    this.success,
    this.responseType,
    this.message,
    this.data,
  });

  bool? success;
  int? responseType;
  String? message;
  Data? data;

  factory SearchSalesByBillNo.fromJson(Map<String, dynamic> json) => SearchSalesByBillNo(
        success: json["success"],
        responseType: json["responseType"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "responseType": responseType,
        "message": message,
        "data": data!.toJson(),
      };
}

class Data {
  Data({
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
    this.tradeSaleDetailDto,
  });

  int? traId;
  String? traDate;
  int? traType;
  int? traAgtId;
  String? traBillNo;
  int? traInsertedBy;
  double? traSubAmount;
  double? traDiscPercent;
  double? traDiscAmount;
  dynamic traNonTaxableAmount;
  dynamic traTaxableAmount;
  dynamic traVatAmount;
  double? traTotalAmount;
  dynamic traRemark;
  bool? traInActive;
  dynamic deletedOn;
  dynamic deletedBy;
  String? traCustomerName;
  dynamic traCustomerPanNo;
  String? traCustomerAddress;
  dynamic traCustomerMobileNo;
  dynamic traPrint;
  dynamic agent;
  dynamic traInsertedStaff;
  int? tradConfirm;
  dynamic billPMode;
  dynamic billPModeDes;
  dynamic traTypeMode;
  dynamic salesAmount;
  dynamic creditAmt;
  dynamic tradeSaleList;
  dynamic tradeSaleDetailDtoList;
  dynamic businessDtoList;
  dynamic tradeSaleDetailDto;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        traId: json["traId"],
        traDate: json["traDate"],
        traType: json["traType"],
        traAgtId: json["traAgtId"],
        traBillNo: json["traBillNo"],
        traInsertedBy: json["traInsertedBy"],
        traSubAmount: json["traSubAmount"].toDouble(),
        traDiscPercent: json["traDiscPercent"].toDouble(),
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
        tradeSaleDetailDto: json["tradeSaleDetailDTO"],
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
        "tradeSaleDetailDTO": tradeSaleDetailDto,
      };
}
