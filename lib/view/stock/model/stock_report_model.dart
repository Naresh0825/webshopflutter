import 'stock_model.dart';

class StockReportModel {
  bool? success;
  int? responseType;
  String? message;
  List<StockDetail>? data;

  StockReportModel({this.success, this.responseType, this.message, this.data});

  StockReportModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    responseType = json['responseType'];
    message = json['message'];
    if (json['data'] != null) {
      data = <StockDetail>[];
      json['data'].forEach((v) {
        data!.add(StockDetail.fromJson(v));
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
