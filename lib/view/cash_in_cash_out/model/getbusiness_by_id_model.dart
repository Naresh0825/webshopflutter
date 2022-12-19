// To parse this JSON data, do
//
//     final getBusinessByIdModel = getBusinessByIdModelFromJson(jsonString);

import 'dart:convert';

GetBusinessByIdModel getBusinessByIdModelFromJson(String str) => GetBusinessByIdModel.fromJson(json.decode(str));

String getBusinessByIdModelToJson(GetBusinessByIdModel data) => json.encode(data.toJson());

class GetBusinessByIdModel {
    GetBusinessByIdModel({
        this.success,
        this.responseType,
        this.message,
        this.data,
    });

    bool? success;
    int? responseType;
    String? message;
    Data? data;

    factory GetBusinessByIdModel.fromJson(Map<String, dynamic> json) => GetBusinessByIdModel(
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
    String? billDescription;
    String? billDate;
    int? billCodeId;
    double? billTotalAmt;
    int? billAgtId;
    dynamic billSupplierId;
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
    dynamic billModeDes;
    dynamic agtCompany;
    dynamic supName;
    dynamic billTranId;
    int? billTradId;
    dynamic billStaffId;
    dynamic billNo;
    dynamic billTraRId;
    dynamic businessList;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
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
