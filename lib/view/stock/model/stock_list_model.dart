// To parse this JSON data, do
//
//     final getStockListModel = getStockListModelFromJson(jsonString);

import 'dart:convert';

GetStockListModel getStockListModelFromJson(String str) => GetStockListModel.fromJson(json.decode(str));

String getStockListModelToJson(GetStockListModel data) => json.encode(data.toJson());

class GetStockListModel {
  GetStockListModel({
    this.success,
    this.responseType,
    this.message,
    this.data,
  });

  bool? success;
  int? responseType;
  String? message;
  List<StockDetailList>? data;

  factory GetStockListModel.fromJson(Map<String, dynamic> json) => GetStockListModel(
        success: json["success"],
        responseType: json["responseType"],
        message: json["message"],
        data: List<StockDetailList>.from(json["data"].map((x) => StockDetailList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "responseType": responseType,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class StockDetailList {
  StockDetailList({
    this.stId,
    this.stCode,
    this.stDes,
    this.stItemGroupId,
    this.stInActive,
    this.stImage,
    this.stODate,
    this.stOBal,
    this.stORate,
    this.stOVal,
    this.stCurBal,
    this.stCurRate,
    this.stReOrder,
    this.stSalesRate,
    this.stBrandId,
    this.itemGroupName,
    this.brandName,
    this.stockList,
    this.itemGroupList,
    this.brandList,
  });

  int? stId;
  String? stCode;
  String? stDes;
  int? stItemGroupId;
  bool? stInActive;
  String? stImage;
  String? stODate;
  double? stOBal;
  double? stORate;
  double? stOVal;
  double? stCurBal;
  double? stCurRate;
  double? stReOrder;
  double? stSalesRate;
  int? stBrandId;
  String? itemGroupName;
  String? brandName;
  dynamic stockList;
  dynamic itemGroupList;
  dynamic brandList;

  factory StockDetailList.fromJson(Map<String, dynamic> json) => StockDetailList(
        stId: json["stId"],
        stCode: json["stCode"],
        stDes: json["stDes"],
        stItemGroupId: json["stItemGroupId"],
        stInActive: json["stInActive"],
        stImage: json["stImage"],
        stODate: json["stODate"],
        stOBal: json["stOBal"].toDouble(),
        stORate: json["stORate"].toDouble(),
        stOVal: json["stOVal"].toDouble(),
        stCurBal: json["stCurBal"].toDouble(),
        stCurRate: json["stCurRate"].toDouble(),
        stReOrder: json["stReOrder"].toDouble(),
        stSalesRate: json["stSalesRate"].toDouble(),
        stBrandId: json["stBrandId"],
        itemGroupName: json["itemGroupName"],
        brandName: json["brandName"],
        stockList: json["stockList"],
        itemGroupList: json["itemGroupList"],
        brandList: json["brandList"],
      );

  Map<String, dynamic> toJson() => {
        "stId": stId,
        "stCode": stCode,
        "stDes": stDes,
        "stItemGroupId": stItemGroupId,
        "stInActive": stInActive,
        "stImage": stImage,
        "stODate": stODate,
        "stOBal": stOBal,
        "stORate": stORate,
        "stOVal": stOVal,
        "stCurBal": stCurBal,
        "stCurRate": stCurRate,
        "stReOrder": stReOrder,
        "stSalesRate": stSalesRate,
        "stBrandId": stBrandId,
        "itemGroupName": itemGroupName,
        "brandName": brandName,
        "stockList": stockList,
        "itemGroupList": itemGroupList,
        "brandList": brandList,
      };
}
