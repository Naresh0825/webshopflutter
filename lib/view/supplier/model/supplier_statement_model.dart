// To parse this JSON data, do
//
//     final supplierStatementModel = supplierStatementModelFromJson(jsonString);

import 'dart:convert';

SupplierStatementModel supplierStatementModelFromJson(String str) => SupplierStatementModel.fromJson(json.decode(str));

String supplierStatementModelToJson(SupplierStatementModel data) => json.encode(data.toJson());

class SupplierStatementModel {
  SupplierStatementModel({
    this.success,
    this.responseType,
    this.message,
    this.data,
  });

  bool? success;
  int? responseType;
  String? message;
  List<SupplierStatement>? data;

  factory SupplierStatementModel.fromJson(Map<String, dynamic> json) => SupplierStatementModel(
        success: json["success"],
        responseType: json["responseType"],
        message: json["message"],
        data: List<SupplierStatement>.from(json["data"].map((x) => SupplierStatement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "responseType": responseType,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class SupplierStatement {
  SupplierStatement({
    this.billId,
    this.billPMode,
    this.billModeDes,
    this.billDescription,
    this.billNo,
    this.billDate,
    this.billNsDate,
    this.billCodeId,
    this.bdName,
    this.billCashIn,
    this.billCashOut,
    this.billCredit,
    this.billCompAmt,
    this.billTotalAmt,
    this.billShiftId,
    this.billAgtId,
    this.agtCompany,
    this.billCvId,
    this.billSupplierId,
    this.supName,
    this.billVoid,
    this.billCurCode,
    this.billFxRate,
    this.billAddedBy,
    this.billAddedByStaff,
    this.billCreditNoteNo,
    this.billInActive,
    this.billModifiedBy,
    this.billModifiedOn,
    this.billModifiedReason,
    this.billDeletedBy,
    this.billDeletedOn,
    this.billDeletedReason,
    this.billEventId,
    this.bdCode,
    this.businessTotal,
    this.businessViewList,
  });

  int? billId;
  int? billPMode;
  dynamic billModeDes;
  String? billDescription;
  String? billNo;
  String? billDate;
  String? billNsDate;
  int? billCodeId;
  dynamic bdName;
  double? billCashIn;
  dynamic billCashOut;
  double? billCredit;
  dynamic billCompAmt;
  double? billTotalAmt;
  dynamic billShiftId;
  dynamic billAgtId;
  dynamic agtCompany;
  dynamic billCvId;
  dynamic billSupplierId;
  dynamic supName;
  dynamic billVoid;
  dynamic billCurCode;
  int? billFxRate;
  int? billAddedBy;
  dynamic billAddedByStaff;
  dynamic billCreditNoteNo;
  dynamic billInActive;
  dynamic billModifiedBy;
  dynamic billModifiedOn;
  dynamic billModifiedReason;
  dynamic billDeletedBy;
  dynamic billDeletedOn;
  dynamic billDeletedReason;
  dynamic billEventId;
  dynamic bdCode;
  dynamic businessTotal;
  dynamic businessViewList;

  factory SupplierStatement.fromJson(Map<String, dynamic> json) => SupplierStatement(
        billId: json["billId"],
        billPMode: json["billPMode"],
        billModeDes: json["billModeDes"],
        billDescription: json["billDescription"],
        billNo: json["billNo"],
        billDate: json["billDate"],
        billNsDate: json["billNSDate"],
        billCodeId: json["billCodeId"],
        bdName: json["bdName"],
        billCashIn: json["billCashIn"],
        billCashOut: json["billCashOut"],
        billCredit: json["billCredit"],
        billCompAmt: json["billCompAmt"],
        billTotalAmt: json["billTotalAmt"].toDouble(),
        billShiftId: json["billShiftId"],
        billAgtId: json["billAgtId"],
        agtCompany: json["agtCompany"],
        billCvId: json["billCvId"],
        billSupplierId: json["billSupplierId"],
        supName: json["supName"],
        billVoid: json["billVoid"],
        billCurCode: json["billCurCode"],
        billFxRate: json["billFxRate"],
        billAddedBy: json["billAddedBy"],
        billAddedByStaff: json["billAddedByStaff"],
        billCreditNoteNo: json["billCreditNoteNo"],
        billInActive: json["billInActive"],
        billModifiedBy: json["billModifiedBy"],
        billModifiedOn: json["billModifiedOn"],
        billModifiedReason: json["billModifiedReason"],
        billDeletedBy: json["billDeletedBy"],
        billDeletedOn: json["billDeletedOn"],
        billDeletedReason: json["billDeletedReason"],
        billEventId: json["billEventId"],
        bdCode: json["bdCode"],
        businessTotal: json["businessTotal"],
        businessViewList: json["businessViewList"],
      );

  Map<String, dynamic> toJson() => {
        "billId": billId,
        "billPMode": billPMode,
        "billModeDes": billModeDes,
        "billDescription": billDescription,
        "billNo": billNo,
        "billDate": billDate,
        "billNSDate": billNsDate,
        "billCodeId": billCodeId,
        "bdName": bdName,
        "billCashIn": billCashIn,
        "billCashOut": billCashOut,
        "billCredit": billCredit,
        "billCompAmt": billCompAmt,
        "billTotalAmt": billTotalAmt,
        "billShiftId": billShiftId,
        "billAgtId": billAgtId,
        "agtCompany": agtCompany,
        "billCvId": billCvId,
        "billSupplierId": billSupplierId,
        "supName": supName,
        "billVoid": billVoid,
        "billCurCode": billCurCode,
        "billFxRate": billFxRate,
        "billAddedBy": billAddedBy,
        "billAddedByStaff": billAddedByStaff,
        "billCreditNoteNo": billCreditNoteNo,
        "billInActive": billInActive,
        "billModifiedBy": billModifiedBy,
        "billModifiedOn": billModifiedOn,
        "billModifiedReason": billModifiedReason,
        "billDeletedBy": billDeletedBy,
        "billDeletedOn": billDeletedOn,
        "billDeletedReason": billDeletedReason,
        "billEventId": billEventId,
        "bdCode": bdCode,
        "businessTotal": businessTotal,
        "businessViewList": businessViewList,
      };
}
