// To parse this JSON data, do
//
//     final tabletSetupModel = tabletSetupModelFromJson(jsonString);

import 'dart:convert';

TabletSetupModel tabletSetupModelFromJson(String str) => TabletSetupModel.fromJson(json.decode(str));

String tabletSetupModelToJson(TabletSetupModel data) => json.encode(data.toJson());

class TabletSetupModel {
  TabletSetupModel({
    this.success,
    this.responseType,
    this.message,
    this.data,
  });

  bool? success;
  int? responseType;
  String? message;
  Data? data;

  factory TabletSetupModel.fromJson(Map<String, dynamic> json) => TabletSetupModel(
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
    this.company,
    this.agentList,
    this.settingList,
    this.supplierList,
    this.stockList,
    this.itemGroupList,
    this.brandList,
    this.billDesList,
    this.fiscalYear,
  });

  Company? company;
  List<AgentList>? agentList;
  List<SettingList>? settingList;
  List<SupplierList>? supplierList;
  List<StockList>? stockList;
  List<ItemGroupList>? itemGroupList;
  List<BrandList>? brandList;
  List<BillDesList>? billDesList;
  FiscalYear? fiscalYear;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        company: Company.fromJson(json["company"]),
        agentList: List<AgentList>.from(json["agentList"].map((x) => AgentList.fromJson(x))),
        settingList: List<SettingList>.from(json["settingList"].map((x) => SettingList.fromJson(x))),
        supplierList: List<SupplierList>.from(json["supplierList"].map((x) => SupplierList.fromJson(x))),
        stockList: List<StockList>.from(json["stockList"].map((x) => StockList.fromJson(x))),
        itemGroupList: List<ItemGroupList>.from(json["itemGroupList"].map((x) => ItemGroupList.fromJson(x))),
        brandList: List<BrandList>.from(json["brandList"].map((x) => BrandList.fromJson(x))),
        billDesList: List<BillDesList>.from(json["billDesList"].map((x) => BillDesList.fromJson(x))),
        fiscalYear: FiscalYear.fromJson(json["fiscalYear"]),
      );

  Map<String, dynamic> toJson() => {
        "company": company!.toJson(),
        "agentList": List<dynamic>.from(agentList!.map((x) => x.toJson())),
        "settingList": List<dynamic>.from(settingList!.map((x) => x.toJson())),
        "supplierList": List<dynamic>.from(supplierList!.map((x) => x.toJson())),
        "stockList": List<dynamic>.from(stockList!.map((x) => x.toJson())),
        "itemGroupList": List<dynamic>.from(itemGroupList!.map((x) => x.toJson())),
        "brandList": List<dynamic>.from(brandList!.map((x) => x.toJson())),
      };
}

class FiscalYear {
  FiscalYear({
    this.fiscalYearId,
    this.startDate,
    this.endDate,
    this.startBs,
    this.endBs,
    this.activeYear,
    this.nepFiscalYear,
  });

  int? fiscalYearId;
  String? startDate;
  String? endDate;
  String? startBs;
  String? endBs;
  bool? activeYear;
  dynamic nepFiscalYear;

  factory FiscalYear.fromJson(Map<String, dynamic> json) => FiscalYear(
        fiscalYearId: json["fiscalYearID"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        startBs: json["startBS"],
        endBs: json["endBS"],
        activeYear: json["activeYear"],
        nepFiscalYear: json["nepFiscalYear"],
      );

  Map<String, dynamic> toJson() => {
        "fiscalYearID": fiscalYearId,
        "startDate": startDate,
        "endDate": endDate,
        "startBS": startBs,
        "endBS": endBs,
        "activeYear": activeYear,
        "nepFiscalYear": nepFiscalYear,
      };
}

class BillDesList {
  BillDesList({
    this.bdId,
    this.bdCode,
    this.bdName,
    this.bdSrvChg,
    this.bdVat,
    this.bdApproved,
    this.bdVisible,
    this.billDesList,
  });

  int? bdId;
  String? bdCode;
  String? bdName;
  bool? bdSrvChg;
  bool? bdVat;
  bool? bdApproved;
  bool? bdVisible;
  dynamic billDesList;

  factory BillDesList.fromJson(Map<String, dynamic> json) => BillDesList(
        bdId: json["bdId"],
        bdCode: json["bdCode"],
        bdName: json["bdName"],
        bdSrvChg: json["bdSrvChg"],
        bdVat: json["bdVat"],
        bdApproved: json["bdApproved"],
        bdVisible: json["bdVisible"],
        billDesList: json["billDesList"],
      );

  Map<String, dynamic> toJson() => {
        "bdId": bdId,
        "bdCode": bdCode,
        "bdName": bdName,
        "bdSrvChg": bdSrvChg,
        "bdVat": bdVat,
        "bdApproved": bdApproved,
        "bdVisible": bdVisible,
        "billDesList": billDesList,
      };
}

class AgentList {
  AgentList({
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
    this.agtDiscount,
  });

  int? agtId;
  String? agtCompany;
  String? agtAdress;
  int? agtVatNo;
  String? agtTel;
  String? agtMobile;
  int? agtCategory;
  double? agtCreditLimit;
  dynamic agtOpAmount;
  double? agtDiscount;
  double? agtAmount;
  bool? agtInactive;
  int? agtSrourceId;
  String? agtOpDate;
  dynamic agentsList;
  dynamic page;

  factory AgentList.fromJson(Map<String, dynamic> json) => AgentList(
        agtId: json["agtId"],
        agtCompany: json["agtCompany"],
        agtAdress: json["agtAdress"],
        agtVatNo: json["agtVatNo"],
        agtTel: json["agtTel"],
        agtMobile: json["agtMobile"],
        agtCategory: json["agtCategory"],
        agtCreditLimit: json["agtCreditLimit"].toDouble(),
        agtOpAmount: json["agtOpAmount"],
        agtAmount: json["agtAmount"].toDouble(),
        agtInactive: json["agtInactive"],
        agtDiscount: json["agtDiscount"],
        agtSrourceId: json["agtSrourceId"],
        agtOpDate: json["agtOpDate"],
        agentsList: json["agentsList"],
        page: json["page"],
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
        "agtDiscount": agtDiscount,
        "agtInactive": agtInactive,
        "agtSrourceId": agtSrourceId,
        "agtOpDate": agtOpDate,
        "agentsList": agentsList,
        "page": page,
      };
}

class BrandList {
  BrandList({
    this.brandId,
    this.brandName,
    this.storeCategoryList,
    this.accountChartList,
  });

  int? brandId;
  String? brandName;
  dynamic storeCategoryList;
  dynamic accountChartList;

  factory BrandList.fromJson(Map<String, dynamic> json) => BrandList(
        brandId: json["brandId"],
        brandName: json["brandName"],
        storeCategoryList: json["storeCategoryList"],
        accountChartList: json["accountChartList"],
      );

  Map<String, dynamic> toJson() => {
        "brandId": brandId,
        "brandName": brandName,
        "storeCategoryList": storeCategoryList,
        "accountChartList": accountChartList,
      };
}

class Company {
  Company({
    this.companyId,
    this.name,
    this.address,
    this.telephone,
    this.email,
    this.website,
    this.vatNo,
    this.version,
  });

  int? companyId;
  String? name;
  String? address;
  String? telephone;
  String? email;
  dynamic website;
  int? vatNo;
  String? version;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        companyId: json["companyId"],
        name: json["name"],
        address: json["address"],
        telephone: json["telephone"],
        email: json["email"],
        website: json["website"],
        vatNo: json["vatNo"],
        version: json["version"],
      );

  Map<String, dynamic> toJson() => {
        "companyId": companyId,
        "name": name,
        "address": address,
        "telephone": telephone,
        "email": email,
        "website": website,
        "vatNo": vatNo,
        "version": version,
      };
}

class ItemGroupList {
  ItemGroupList({
    this.itemGroupId,
    this.itemGroupName,
    this.storeCategoryList,
    this.accountChartList,
  });

  int? itemGroupId;
  String? itemGroupName;
  dynamic storeCategoryList;
  dynamic accountChartList;

  factory ItemGroupList.fromJson(Map<String, dynamic> json) => ItemGroupList(
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

class SettingList {
  SettingList({
    this.settingName,
    this.settingValue,
    this.description,
    this.settingType,
  });

  String? settingName;
  String? settingValue;
  String? description;
  bool? settingType;

  factory SettingList.fromJson(Map<String, dynamic> json) => SettingList(
        settingName: json["settingName"],
        settingValue: json["settingValue"],
        description: json["description"],
        settingType: json["settingType"],
      );

  Map<String, dynamic> toJson() => {
        "settingName": settingName,
        "settingValue": settingValue,
        "description": description,
        "settingType": settingType,
      };
}

class StockList {
  StockList({
    this.stId,
    this.stCode,
    this.stDes,
    this.stItemGroupId,
    this.stBrandId,
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
    this.itemGroupName,
    this.brandName,
    this.stockList,
    this.itemGroupList,
  });

  int? stId;
  String? stCode;
  String? stDes;
  int? stItemGroupId;
  int? stBrandId;
  bool? stInActive;
  dynamic stImage;
  String? stODate;
  double? stOBal;
  double? stORate;
  double? stOVal;
  double? stCurBal;
  double? stCurRate;
  double? stReOrder;
  double? stSalesRate;
  String? itemGroupName;
  String? brandName;
  dynamic stockList;
  dynamic itemGroupList;

  factory StockList.fromJson(Map<String, dynamic> json) => StockList(
        stId: json["stId"],
        stCode: json["stCode"],
        stDes: json["stDes"],
        stItemGroupId: json["stItemGroupId"],
        stBrandId: json["stBrandId"],
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
        itemGroupName: json["itemGroupName"],
        brandName: json["brandName"],
        stockList: json["stockList"],
        itemGroupList: json["itemGroupList"],
      );

  Map<String, dynamic> toJson() => {
        "stId": stId,
        "stCode": stCode,
        "stDes": stDes,
        "stItemGroupId": stItemGroupId,
        "stBrandId": stBrandId,
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
        "itemGroupName": itemGroupName,
        "brandName": brandName,
        "stockList": stockList,
        "itemGroupList": itemGroupList,
      };
}

class SupplierList {
  SupplierList({
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
  dynamic supMobile;
  String? supPhone;
  String? supOpDate;
  double? supOpAmount;
  double? supAmount;
  bool? supInActive;

  factory SupplierList.fromJson(Map<String, dynamic> json) => SupplierList(
        supId: json["supId"],
        supName: json["supName"],
        supVatNo: json["supVatNo"],
        supAddress: json["supAddress"],
        supMobile: json["supMobile"],
        supPhone: json["supPhone"],
        supOpDate: json["supOpDate"],
        supOpAmount: json["supOpAmount"].toDouble(),
        supAmount: json["supAmount"].toDouble(),
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
