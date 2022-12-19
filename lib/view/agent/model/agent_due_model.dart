// To parse this JSON data, do
//
//     final agentDueModel = agentDueModelFromJson(jsonString);

import 'dart:convert';

AgentDueModel agentDueModelFromJson(String str) => AgentDueModel.fromJson(json.decode(str));

String agentDueModelToJson(AgentDueModel data) => json.encode(data.toJson());

class AgentDueModel {
  AgentDueModel({
    this.success,
    this.responseType,
    this.message,
    this.data,
  });

  bool? success;
  int? responseType;
  String? message;
  List<AgentDue>? data;

  factory AgentDueModel.fromJson(Map<String, dynamic> json) => AgentDueModel(
        success: json["success"],
        responseType: json["responseType"],
        message: json["message"],
        data: List<AgentDue>.from(json["data"].map((x) => AgentDue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "responseType": responseType,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class AgentDue {
  AgentDue({
    this.agtId,
    this.agtCompany,
    this.agtAdress,
    this.agtVatNo,
    this.agtTel,
    this.agtMobile,
    this.agtCategory,
    this.agtCreditLimit,
    this.agtOpAmount,
    this.agtAmount,
    this.agtInactive,
    this.agtSrourceId,
    this.agtOpDate,
    this.agentsList,
    this.page,
    this.agtSource,
  });

  int? agtId;
  String? agtCompany;
  String? agtAdress;
  dynamic agtVatNo;
  String? agtTel;
  String? agtMobile;
  int? agtCategory;
  dynamic agtCreditLimit;
  dynamic agtOpAmount;
  double? agtAmount;
  bool? agtInactive;
  int? agtSrourceId;
  DateTime? agtOpDate;
  dynamic agentsList;
  dynamic page;
  String? agtSource;

  factory AgentDue.fromJson(Map<String, dynamic> json) => AgentDue(
        agtId: json["agtId"],
        agtCompany: json["agtCompany"],
        agtAdress: json["agtAdress"],
        agtVatNo: json["agtVatNo"],
        agtTel: json["agtTel"],
        agtMobile: json["agtMobile"],
        agtCategory: json["agtCategory"],
        agtCreditLimit: json["agtCreditLimit"],
        agtOpAmount: json["agtOpAmount"],
        agtAmount: json["agtAmount"],
        agtInactive: json["agtInactive"],
        agtSrourceId: json["agtSrourceId"],
        agtOpDate: DateTime.parse(json["agtOpDate"]),
        agentsList: json["agentsList"],
        page: json["page"],
        agtSource: json["agtSource"],
      );

  Map<String, dynamic> toJson() => {
        "agtId": agtId,
        "agtCompany": agtCompany,
        "agtAdress": agtAdress,
        "agtVatNo": agtVatNo,
        "agtTel": agtTel,
        "agtMobile": agtMobile,
        "agtCategory": agtCategory,
        "agtCreditLimit": agtCreditLimit,
        "agtOpAmount": agtOpAmount,
        "agtAmount": agtAmount,
        "agtInactive": agtInactive,
        "agtSrourceId": agtSrourceId,
        "agtOpDate": agtOpDate,
        "agentsList": agentsList,
        "page": page,
        "agtSource": agtSource,
      };
}
