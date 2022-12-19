// To parse this JSON data, do
//
//     final postBusiness = postBusinessFromJson(jsonString);

import 'dart:convert';

PostBusiness postBusinessFromJson(String str) => PostBusiness.fromJson(json.decode(str));

String postBusinessToJson(PostBusiness data) => json.encode(data.toJson());

class PostBusiness {
  PostBusiness({
    required this.billId,
    required this.billPMode,
    required this.billDescription,
    required this.billDate,
    required this.billTotalAmt,
    required this.billCodeId,
    this.billAgtId,
    this.billSupplierId,
    required this.billAddedBy,
    required this.billInActive,
    this.billDeletedBy,
    this.billDeletedOn,
    this.billDeletedReason,
  });

  int billId;
  int billPMode;
  String billDescription;
  String billDate;
  double billTotalAmt;
  int billCodeId;
  int? billAgtId;
  int? billSupplierId;
  int billAddedBy;
  bool billInActive;
  int? billDeletedBy;
  String? billDeletedOn;
  String? billDeletedReason;

  factory PostBusiness.fromJson(Map<String, dynamic> json) => PostBusiness(
        billId: json["BillId"],
        billPMode: json["BillPMode"],
        billDescription: json["BillDescription"],
        billDate: json["BillDate"],
        billTotalAmt: json["BillTotalAmt"],
        billCodeId: json["BillCodeId"],
        billAgtId: json["BillAgtId"],
        billSupplierId: json["BillSupplierId"],
        billAddedBy: json["BillAddedBy"],
        billInActive: json["BillInActive"],
        billDeletedBy: json["billDeletedBy"],
        billDeletedOn: json["billDeletedOn"],
        billDeletedReason: json["billDeletedReason"],
      );

  Map<String, dynamic> toJson() => {
        "BillId": billId,
        "BillPMode": billPMode,
        "BillDescription": billDescription,
        "BillDate": billDate,
        "BillTotalAmt": billTotalAmt,
        "BillCodeId": billCodeId,
        "BillAgtId": billAgtId,
        "BillSupplierId": billSupplierId,
        "BillAddedBy": billAddedBy,
        "BillInActive": billInActive,
        "billDeletedBy": billDeletedBy,
        "billDeletedOn": billDeletedOn,
        "billDeletedReason": billDeletedReason,
      };
}
