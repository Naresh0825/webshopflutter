class SalesDetailReportModel {
  bool? success;
  int? responseType;
  String? message;
  List<SalesData>? data;

  SalesDetailReportModel({this.success, this.responseType, this.message, this.data});

  SalesDetailReportModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    responseType = json['responseType'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SalesData>[];
      json['data'].forEach((v) {
        data!.add(SalesData.fromJson(v));
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

class SalesData {
  String? traDate;
  int? traDQty;
  double? traDRate;
  double? traDAmount;
  double? traDCostPrice;
  double? traDCostAmount;
  String? stDes;
  String? traBillNo;
  dynamic buyerBillTo;

  SalesData(
      {this.traDate,
      this.traDQty,
      this.traDRate,
      this.traDAmount,
      this.traDCostPrice,
      this.traDCostAmount,
      this.stDes,
      this.traBillNo,
      this.buyerBillTo});

  SalesData.fromJson(Map<String, dynamic> json) {
    traDate = json['traDate'];
    traDQty = json['traDQty'];
    traDRate = double.parse(json['traDRate'].toString());
    traDAmount = double.parse(json['traDAmount'].toString());
    traDCostPrice = double.parse(json['traDCostPrice'].toString());
    traDCostAmount = double.parse(json['traDCostAmount'].toString());
    stDes = json['stDes'];
    traBillNo = json['traBillNo'];
    buyerBillTo = json['buyerBillTo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['traDate'] = traDate;
    data['traDQty'] = traDQty;
    data['traDRate'] = traDRate;
    data['traDAmount'] = traDAmount;
    data['traDCostPrice'] = traDCostPrice;
    data['traDCostAmount'] = traDCostAmount;
    data['stDes'] = stDes;
    data['traBillNo'] = traBillNo;
    data['buyerBillTo'] = buyerBillTo;
    return data;
  }
}
