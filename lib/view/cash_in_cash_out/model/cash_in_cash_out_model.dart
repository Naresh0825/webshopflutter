// To parse this JSON data, do
//
//     final cashInCashOutModel = cashInCashOutModelFromJson(jsonString);

import 'dart:convert';

CashInCashOutModel cashInCashOutModelFromJson(String str) => CashInCashOutModel.fromJson(json.decode(str));

String cashInCashOutModelToJson(CashInCashOutModel data) => json.encode(data.toJson());

class CashInCashOutModel {
  CashInCashOutModel({
    this.success,
    this.responseType,
    this.message,
    this.data,
  });

  bool? success;
  int? responseType;
  String? message;
  CashInOut? data;

  factory CashInCashOutModel.fromJson(Map<String, dynamic> json) => CashInCashOutModel(
        success: json["success"],
        responseType: json["responseType"],
        message: json["message"],
        data: CashInOut.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "responseType": responseType,
        "message": message,
        "data": data!.toJson(),
      };
}

class CashInOut {
  CashInOut({
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
  dynamic billDescription;
  dynamic billNo;
  DateTime? billDate;
  dynamic billNsDate;
  int? billCodeId;
  dynamic bdName;
  dynamic billCashIn;
  dynamic billCashOut;
  dynamic billCredit;
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
  bool? billInActive;
  dynamic billModifiedBy;
  dynamic billModifiedOn;
  dynamic billModifiedReason;
  dynamic billDeletedBy;
  dynamic billDeletedOn;
  dynamic billDeletedReason;
  dynamic billEventId;
  String? bdCode;
  BusinessTotal? businessTotal;
  List<CashInOut>? businessViewList;

  factory CashInOut.fromJson(Map<String, dynamic> json) => CashInOut(
        billId: json["billId"],
        billPMode: json["billPMode"],
        billModeDes: json["billModeDes"],
        billDescription: json["billDescription"],
        billNo: json["billNo"],
        billDate: DateTime.parse(json["billDate"]),
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
        businessTotal: json["businessTotal"] == null ? null : BusinessTotal.fromJson(json["businessTotal"]),
        businessViewList: json["businessViewList"] == null ? null : List<CashInOut>.from(json["businessViewList"].map((x) => CashInOut.fromJson(x))),
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
        "businessTotal": businessTotal == null ? null : businessTotal!.toJson(),
        "businessViewList": businessViewList == null ? null : List<dynamic>.from(businessViewList!.map((x) => x.toJson())),
      };
}

class BusinessTotal {
  BusinessTotal({
    this.cashInTotal,
    this.creditTotal,
    this.cashOutTotal,
    this.compTotal,
    this.cityLedgerTotal,
    this.posTotal,
    this.ePayTotal,
  });

  double? cashInTotal;
  double? creditTotal;
  double? cashOutTotal;
  double? compTotal;
  double? cityLedgerTotal;
  double? posTotal;
  double? ePayTotal;

  factory BusinessTotal.fromJson(Map<String, dynamic> json) => BusinessTotal(
        cashInTotal: json["cashInTotal"].toDouble(),
        creditTotal: json["creditTotal"].toDouble(),
        cashOutTotal: json["cashOutTotal"].toDouble(),
        compTotal: json["compTotal"].toDouble(),
        cityLedgerTotal: json["cityLedgerTotal"].toDouble(),
        posTotal: json["posTotal"].toDouble(),
        ePayTotal: json["ePayTotal"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "cashInTotal": cashInTotal,
        "creditTotal": creditTotal,
        "cashOutTotal": cashOutTotal,
        "compTotal": compTotal,
        "cityLedgerTotal": cityLedgerTotal,
        "posTotal": posTotal,
        "ePayTotal": ePayTotal,
      };
}
