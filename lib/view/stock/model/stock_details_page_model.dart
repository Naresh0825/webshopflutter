// To parse this JSON data, do
//
//     final getStockDetailModel = getStockDetailModelFromJson(jsonString);

import 'dart:convert';

GetStockDetailModel getStockDetailModelFromJson(String str) => GetStockDetailModel.fromJson(json.decode(str));

String getStockDetailModelToJson(GetStockDetailModel data) => json.encode(data.toJson());

class GetStockDetailModel {
  GetStockDetailModel({
    this.success,
    this.responseType,
    this.message,
    this.data,
  });

  bool? success;
  int? responseType;
  String? message;
  List<DetailsStock>? data;

  factory GetStockDetailModel.fromJson(Map<String, dynamic> json) => GetStockDetailModel(
        success: json["success"],
        responseType: json["responseType"],
        message: json["message"],
        data: List<DetailsStock>.from(json["data"].map((x) => DetailsStock.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "responseType": responseType,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DetailsStock {
  DetailsStock({
    this.stkId,
    this.stDes,
    this.stkDate,
    this.stTypeDes,
    this.catDes,
    this.itemGroupName,
    this.stkPurUnitId,
    this.stkTrackUnitId,
    this.stkPurUnitDes,
    this.stkTrackUnitDes,
    this.stkRate,
    this.tranType,
    this.stkObal,
    this.stkOval,
    this.stkPqty,
    this.stkPval,
    this.stkIqty,
    this.stkIval,
    this.stkLdqty,
    this.stkLdval,
    this.stkCbal,
    this.stkCval,
    this.supplier,
    this.purBillNo,
    this.customer,
    this.issueNo,
    this.lostComment,
    this.tranId,
    this.insertedDate,
    this.calRate,
    this.tranDId,
  });

  int? stkId;
  String? stDes;
  String? stkDate;
  dynamic stTypeDes;
  dynamic catDes;
  String? itemGroupName;
  int? stkPurUnitId;
  int? stkTrackUnitId;
  dynamic stkPurUnitDes;
  dynamic stkTrackUnitDes;
  double? stkRate;
  String? tranType;
  double? stkObal;
  double? stkOval;
  double? stkPqty;
  double? stkPval;
  double? stkIqty;
  double? stkIval;
  double? stkLdqty;
  double? stkLdval;
  double? stkCbal;
  double? stkCval;
  String? supplier;
  String? purBillNo;
  String? customer;
  String? issueNo;
  String? lostComment;
  int? tranId;
  String? insertedDate;
  int? calRate;
  int? tranDId;

  factory DetailsStock.fromJson(Map<String, dynamic> json) => DetailsStock(
        stkId: json["stkId"],
        stDes: json["stDes"],
        stkDate: json["stkDate"] == null ? '' : json["stkDate"].toString(),
        stTypeDes: json["stTypeDes"],
        catDes: json["catDes"],
        itemGroupName: json["itemGroupName"],
        stkPurUnitId: json["stkPurUnitId"],
        stkTrackUnitId: json["stkTrackUnitId"],
        stkPurUnitDes: json["stkPurUnitDes"],
        stkTrackUnitDes: json["stkTrackUnitDes"],
        stkRate: json["stkRate"],
        tranType: json["tranType"],
        stkObal: json["stkOBAL"],
        stkOval: json["stkOVAL"],
        stkPqty: json["stkPQTY"],
        stkPval: json["stkPVAL"],
        stkIqty: json["stkIQTY"],
        stkIval: json["stkIVAL"],
        stkLdqty: json["stkLDQTY"],
        stkLdval: json["stkLDVAL"],
        stkCbal: json["stkCBAL"],
        stkCval: json["stkCVAL"],
        supplier: json["supplier"],
        purBillNo: json["purBillNo"],
        customer: json["customer"],
        issueNo: json["issueNo"],
        lostComment: json["lostComment"],
        tranId: json["tranId"],
        insertedDate: json["insertedDate"],
        calRate: json["calRate"],
        tranDId: json["tranDId"] == null ? null : int.parse(json["tranDId"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "stkId": stkId,
        "stDes": stDes,
        "stkDate": stkDate,
        "stTypeDes": stTypeDes,
        "catDes": catDes,
        "itemGroupName": itemGroupName,
        "stkPurUnitId": stkPurUnitId,
        "stkTrackUnitId": stkTrackUnitId,
        "stkPurUnitDes": stkPurUnitDes,
        "stkTrackUnitDes": stkTrackUnitDes,
        "stkRate": stkRate,
        "tranType": tranType,
        "stkOBAL": stkObal,
        "stkOVAL": stkOval,
        "stkPQTY": stkPqty,
        "stkPVAL": stkPval,
        "stkIQTY": stkIqty,
        "stkIVAL": stkIval,
        "stkLDQTY": stkLdqty,
        "stkLDVAL": stkLdval,
        "stkCBAL": stkCbal,
        "stkCVAL": stkCval,
        "supplier": supplier,
        "purBillNo": purBillNo,
        "customer": customer,
        "issueNo": issueNo,
        "lostComment": lostComment,
        "tranId": tranId,
        "insertedDate": insertedDate,
        "calRate": calRate,
        "tranDId": tranDId,
      };
}
