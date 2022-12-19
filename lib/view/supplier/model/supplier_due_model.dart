// To parse this JSON data, do
//
//     final supplierDueModel = supplierDueModelFromJson(jsonString);

import 'dart:convert';

SupplierDueModel supplierDueModelFromJson(String str) => SupplierDueModel.fromJson(json.decode(str));

String supplierDueModelToJson(SupplierDueModel data) => json.encode(data.toJson());

class SupplierDueModel {
  SupplierDueModel({
    this.success,
    this.responseType,
    this.message,
    this.data,
  });

  bool? success;
  int? responseType;
  String? message;
  List<SupplierDue>? data;

  factory SupplierDueModel.fromJson(Map<String, dynamic> json) => SupplierDueModel(
        success: json["success"],
        responseType: json["responseType"],
        message: json["message"],
        data: List<SupplierDue>.from(json["data"].map((x) => SupplierDue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "responseType": responseType,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class SupplierDue {
  SupplierDue({
    this.supId,
    this.supName,
    this.supVatNo,
    this.supAddress,
    this.supMobile,
    this.supPhone,
    this.supOpDate,
    this.supOpAmount,
    this.supAmount,
    this.supInActive,
  });

  int? supId;
  String? supName;
  dynamic supVatNo;
  String? supAddress;
  String? supMobile;
  String? supPhone;
  dynamic supOpDate;
  dynamic supOpAmount;
  double? supAmount;
  bool? supInActive;

  factory SupplierDue.fromJson(Map<String, dynamic> json) => SupplierDue(
        supId: json["supId"],
        supName: json["supName"],
        supVatNo: json["supVatNo"],
        supAddress: json["supAddress"],
        supMobile: json["supMobile"],
        supPhone: json["supPhone"],
        supOpDate: json["supOpDate"],
        supOpAmount: json["supOpAmount"],
        supAmount: json["supAmount"],
        supInActive: json["supInActive"],
      );

  Map<String, dynamic> toJson() => {
        "supId": supId,
        "supName": supName,
        "supVatNo": supVatNo,
        "supAddress": supAddress,
        "supMobile": supMobile,
        "supPhone": supPhone,
        "supOpDate": supOpDate,
        "supOpAmount": supOpAmount,
        "supAmount": supAmount,
        "supInActive": supInActive,
      };
}
