// To parse this JSON data, do
//
//     final getItemGroupModel = getItemGroupModelFromJson(jsonString);

import 'dart:convert';

GetItemGroupModel getItemGroupModelFromJson(String str) => GetItemGroupModel.fromJson(json.decode(str));

String getItemGroupModelToJson(GetItemGroupModel data) => json.encode(data.toJson());

class GetItemGroupModel {
    GetItemGroupModel({
        this.success,
        this.responseType,
        this.message,
        this.data,
    });

    bool? success;
    int? responseType;
    String? message;
    List<GroupName>? data;

    factory GetItemGroupModel.fromJson(Map<String, dynamic> json) => GetItemGroupModel(
        success: json["success"],
        responseType: json["responseType"],
        message: json["message"],
        data: List<GroupName>.from(json["data"].map((x) => GroupName.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "responseType": responseType,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class GroupName {
    GroupName({
        this.itemGroupId,
        this.itemGroupName,
        this.storeCategoryList,
        this.accountChartList,
    });

    int? itemGroupId;
    String? itemGroupName;
    dynamic storeCategoryList;
    dynamic accountChartList;

    factory GroupName.fromJson(Map<String, dynamic> json) => GroupName(
        itemGroupId: json["itemGroupId"],
        itemGroupName: json["itemGroupName"],
        storeCategoryList: json["storeCategoryList"],
        accountChartList: json["accountChartList"],
    );

    Map<String, dynamic> toJson() => {
        "itemGroupId": itemGroupId,
        "itemGroupName": itemGroupName,
        "storeCategoryList": storeCategoryList,
        "accountChartList": accountChartList,
    };
}
