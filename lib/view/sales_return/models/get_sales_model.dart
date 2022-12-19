// To parse this JSON data, do
//
//     final getSalesById = getSalesByIdFromJson(jsonString);

import 'dart:convert';

GetSalesByIdModel getSalesByIdModelFromJson(String str) => GetSalesByIdModel.fromJson(json.decode(str));

String getSalesByIdModelToJson(GetSalesByIdModel data) => json.encode(data.toJson());

class GetSalesByIdModel {
  GetSalesByIdModel({
    this.success,
    this.responseType,
    this.message,
    this.data,
  });

  bool? success;
  int? responseType;
  String? message;
  Data? data;

  factory GetSalesByIdModel.fromJson(Map<String, dynamic> json) => GetSalesByIdModel(
        success: json["success"],
        responseType: json["responseType"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "responseType": responseType,
        "message": message,
        "data": data == null ? null : data!.toJson(),
      };
}

class Data {
  Data({
    this.traId,
    this.traDate,
    this.traNepDate,
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
    this.tradeSaleList,
    this.tradeSaleDetailDtoList,
    this.businessDtoList,
    this.tradeSaleDetailDto,
  });

  int? traId;
  String? traDate;
  String? traNepDate;
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
  dynamic traCustomerAddress;
  dynamic traCustomerMobileNo;
  dynamic traPrint;
  dynamic agent;
  dynamic traInsertedStaff;
  int? tradConfirm;
  dynamic billPMode;
  dynamic billPModeDes;
  dynamic tradeSaleList;
  List<TradeSaleDetailDtoList>? tradeSaleDetailDtoList;
  List<BusinessDtoList>? businessDtoList;
  dynamic tradeSaleDetailDto;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        traId: json["traId"],
        traDate: json["traDate"],
        traNepDate: json["traNepDate"],
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
        traTotalAmount: json["traTotalAmount"],
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
        tradeSaleList: json["tradeSaleList"],
        tradeSaleDetailDtoList: List<TradeSaleDetailDtoList>.from(json["tradeSaleDetailDTOList"].map((x) => TradeSaleDetailDtoList.fromJson(x))),
        businessDtoList: List<BusinessDtoList>.from(json["businessDTOList"].map((x) => BusinessDtoList.fromJson(x))),
        tradeSaleDetailDto: json["tradeSaleDetailDTO"],
      );

  Map<String, dynamic> toJson() => {
        "traId": traId,
        "traDate": traDate,
        "traNepDate": traNepDate,
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
        "tradeSaleList": tradeSaleList,
        "tradeSaleDetailDTOList": List<dynamic>.from(tradeSaleDetailDtoList!.map((x) => x.toJson())),
        "businessDTOList": List<dynamic>.from(businessDtoList!.map((x) => x.toJson())),
        "tradeSaleDetailDTO": tradeSaleDetailDto,
      };
}

class BusinessDtoList {
  BusinessDtoList({
    this.billId,
    this.billPMode,
    this.billDescription,
    this.billDate,
    this.billCodeId,
    this.billTotalAmt,
    this.billAgtId,
    this.billSupplierId,
    this.billReceiptNo,
    this.billAddedBy,
    this.billInActive,
    this.billModifiedBy,
    this.billModifiedOn,
    this.billModifiedReason,
    this.billDeletedBy,
    this.billDeletedOn,
    this.billDeletedReason,
    this.billAddedByStaff,
    this.billModeDes,
    this.agtCompany,
    this.supName,
    this.billTranId,
    this.billTradId,
    this.billStaffId,
    this.billNo,
    this.billTraRId,
    this.businessList,
  });

  int? billId;
  int? billPMode;
  dynamic billDescription;
  String? billDate;
  int? billCodeId;
  double? billTotalAmt;
  int? billAgtId;
  int? billSupplierId;
  dynamic billReceiptNo;
  int? billAddedBy;
  dynamic billInActive;
  dynamic billModifiedBy;
  dynamic billModifiedOn;
  dynamic billModifiedReason;
  dynamic billDeletedBy;
  dynamic billDeletedOn;
  dynamic billDeletedReason;
  dynamic billAddedByStaff;
  String? billModeDes;
  dynamic agtCompany;
  dynamic supName;
  dynamic billTranId;
  dynamic billTradId;
  dynamic billStaffId;
  dynamic billNo;
  dynamic billTraRId;
  dynamic businessList;

  factory BusinessDtoList.fromJson(Map<String, dynamic> json) => BusinessDtoList(
        billId: json["billId"],
        billPMode: json["billPMode"],
        billDescription: json["billDescription"],
        billDate: json["billDate"],
        billCodeId: json["billCodeId"],
        billTotalAmt: json["billTotalAmt"],
        billAgtId: json["billAgtId"],
        billSupplierId: json["billSupplierId"],
        billReceiptNo: json["billReceiptNo"],
        billAddedBy: json["billAddedBy"],
        billInActive: json["billInActive"],
        billModifiedBy: json["billModifiedBy"],
        billModifiedOn: json["billModifiedOn"],
        billModifiedReason: json["billModifiedReason"],
        billDeletedBy: json["billDeletedBy"],
        billDeletedOn: json["billDeletedOn"],
        billDeletedReason: json["billDeletedReason"],
        billAddedByStaff: json["billAddedByStaff"],
        billModeDes: json["billModeDes"],
        agtCompany: json["agtCompany"],
        supName: json["supName"],
        billTranId: json["billTranId"],
        billTradId: json["billTradId"],
        billStaffId: json["billStaffId"],
        billNo: json["billNo"],
        billTraRId: json["billTraRId"],
        businessList: json["businessList"],
      );

  Map<String, dynamic> toJson() => {
        "billId": billId,
        "billPMode": billPMode,
        "billDescription": billDescription,
        "billDate": billDate,
        "billCodeId": billCodeId,
        "billTotalAmt": billTotalAmt,
        "billAgtId": billAgtId,
        "billSupplierId": billSupplierId,
        "billReceiptNo": billReceiptNo,
        "billAddedBy": billAddedBy,
        "billInActive": billInActive,
        "billModifiedBy": billModifiedBy,
        "billModifiedOn": billModifiedOn,
        "billModifiedReason": billModifiedReason,
        "billDeletedBy": billDeletedBy,
        "billDeletedOn": billDeletedOn,
        "billDeletedReason": billDeletedReason,
        "billAddedByStaff": billAddedByStaff,
        "billModeDes": billModeDes,
        "agtCompany": agtCompany,
        "supName": supName,
        "billTranId": billTranId,
        "billTradId": billTradId,
        "billStaffId": billStaffId,
        "billNo": billNo,
        "billTraRId": billTraRId,
        "businessList": businessList,
      };
}

class TradeSaleDetailDtoList {
  TradeSaleDetailDtoList({
    this.traDId,
    this.traDMastId,
    this.traDStkId,
    this.traDQty,
    this.traDRate,
    this.traDAmount,
    this.stDes,
    this.traDCostPrice,
    this.tradeSaleDetailList,
  });

  int? traDId;
  int? traDMastId;
  int? traDStkId;
  int? traDQty;
  double? traDRate;
  double? traDAmount;
  String? stDes;
  double? traDCostPrice;
  dynamic tradeSaleDetailList;

  factory TradeSaleDetailDtoList.fromJson(Map<String, dynamic> json) => TradeSaleDetailDtoList(
        traDId: json["traDId"],
        traDMastId: json["traDMastId"],
        traDStkId: json["traDStkId"],
        traDQty: json["traDQty"],
        traDRate: json["traDRate"],
        traDAmount: json["traDAmount"],
        stDes: json["stDes"],
        traDCostPrice: json["traDCostPrice"],
        tradeSaleDetailList: json["tradeSaleDetailList"],
      );

  Map<String, dynamic> toJson() => {
        "traDId": traDId,
        "traDMastId": traDMastId,
        "traDStkId": traDStkId,
        "traDQty": traDQty,
        "traDRate": traDRate,
        "traDAmount": traDAmount,
        "stDes": stDes,
        "traDCostPrice": traDCostPrice,
        "tradeSaleDetailList": tradeSaleDetailList,
      };
}
