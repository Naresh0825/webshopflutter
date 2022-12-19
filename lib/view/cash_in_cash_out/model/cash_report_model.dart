class CashReportModel {
  bool? success;
  int? responseType;
  String? message;
  List<CashReport>? data;

  CashReportModel({this.success, this.responseType, this.message, this.data});

  CashReportModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    responseType = json['responseType'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CashReport>[];
      json['data'].forEach((v) {
        data!.add(CashReport.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['responseType'] = responseType;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CashReport {
  int? billId;
  int? billPMode;
  dynamic billModeDes;
  String? billDescription;
  String? billNo;
  String? billDate;
  dynamic billNSDate;
  int? billCodeId;
  String? bdName;
  double? billCashIn;
  double? billCashOut;
  dynamic billCredit;
  dynamic billCompAmt;
  int? billTotalAmt;
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
  String? billAddedByStaff;
  dynamic billCreditNoteNo;
  dynamic billInActive;
  dynamic billModifiedBy;
  dynamic billModifiedOn;
  dynamic billModifiedReason;
  dynamic billDeletedBy;
  dynamic billDeletedOn;
  dynamic billDeletedReason;
  dynamic billEventId;
  dynamic billTraId;
  String? bdCode;
  dynamic businessTotal;
  dynamic businessViewList;

  CashReport({
    this.billId,
    this.billPMode,
    this.billModeDes,
    this.billDescription,
    this.billNo,
    this.billDate,
    this.billNSDate,
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
    this.billTraId,
    this.bdCode,
    this.businessTotal,
    this.businessViewList,
  });

  CashReport.fromJson(Map<String, dynamic> json) {
    billId = json['billId'];
    billPMode = json['billPMode'];
    billModeDes = json['billModeDes'];
    billDescription = json['billDescription'];
    billNo = json['billNo'];
    billDate = json['billDate'];
    billNSDate = json['billNSDate'];
    billCodeId = json['billCodeId'];
    bdName = json['bdName'];
    billCashIn = json['billCashIn'];
    billCashOut = double.parse(json['billCashOut'].toString());
    billCredit = json['billCredit'];
    billCompAmt = json['billCompAmt'];
    billTotalAmt = json['billTotalAmt'];
    billShiftId = json['billShiftId'];
    billAgtId = json['billAgtId'];
    agtCompany = json['agtCompany'];
    billCvId = json['billCvId'];
    billSupplierId = json['billSupplierId'];
    supName = json['supName'];
    billVoid = json['billVoid'];
    billCurCode = json['billCurCode'];
    billFxRate = json['billFxRate'];
    billAddedBy = json['billAddedBy'];
    billAddedByStaff = json['billAddedByStaff'];
    billCreditNoteNo = json['billCreditNoteNo'];
    billInActive = json['billInActive'];
    billModifiedBy = json['billModifiedBy'];
    billModifiedOn = json['billModifiedOn'];
    billModifiedReason = json['billModifiedReason'];
    billDeletedBy = json['billDeletedBy'];
    billDeletedOn = json['billDeletedOn'];
    billDeletedReason = json['billDeletedReason'];
    billEventId = json['billEventId'];
    billTraId = json['billTraId'];
    bdCode = json['bdCode'];
    businessTotal = json['businessTotal'];
    businessViewList = json['businessViewList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['billId'] = billId;
    data['billPMode'] = billPMode;
    data['billModeDes'] = billModeDes;
    data['billDescription'] = billDescription;
    data['billNo'] = billNo;
    data['billDate'] = billDate;
    data['billNSDate'] = billNSDate;
    data['billCodeId'] = billCodeId;
    data['bdName'] = bdName;
    data['billCashIn'] = billCashIn;
    data['billCashOut'] = billCashOut;
    data['billCredit'] = billCredit;
    data['billCompAmt'] = billCompAmt;
    data['billTotalAmt'] = billTotalAmt;
    data['billShiftId'] = billShiftId;
    data['billAgtId'] = billAgtId;
    data['agtCompany'] = agtCompany;
    data['billCvId'] = billCvId;
    data['billSupplierId'] = billSupplierId;
    data['supName'] = supName;
    data['billVoid'] = billVoid;
    data['billCurCode'] = billCurCode;
    data['billFxRate'] = billFxRate;
    data['billAddedBy'] = billAddedBy;
    data['billAddedByStaff'] = billAddedByStaff;
    data['billCreditNoteNo'] = billCreditNoteNo;
    data['billInActive'] = billInActive;
    data['billModifiedBy'] = billModifiedBy;
    data['billModifiedOn'] = billModifiedOn;
    data['billModifiedReason'] = billModifiedReason;
    data['billDeletedBy'] = billDeletedBy;
    data['billDeletedOn'] = billDeletedOn;
    data['billDeletedReason'] = billDeletedReason;
    data['billEventId'] = billEventId;
    data['billTraId'] = billTraId;
    data['bdCode'] = bdCode;
    data['businessTotal'] = businessTotal;
    data['businessViewList'] = businessViewList;
    return data;
  }
}
