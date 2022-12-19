import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/stock/model/stock_model.dart';
import 'package:webshop/view/stock/model/stock_report_model.dart';
import 'package:http/http.dart' as http;

class StockStatementServiceProvider extends ChangeNotifier {
  StockReportModel stockReportModel = StockReportModel();

  String? fromDate, toDate;
  int? stItemGroupId, stId;

  double opTotal = 0.0;
  double purchaseTotal = 0.0;
  double salesTotal = 0.0;
  double lostTotal = 0.0;
  double closeTotal = 0.0;

  String boolValue = 'i';

  Map<String, double> openBal = {};
  Map<String, double> purBal = {};
  Map<String, double> saleBal = {};
  Map<String, double> lossBal = {};
  Map<String, double> closeBal = {};
  Map<String, List<StockDetail>> group = {};

  Future<StockReportModel> getStockStatement(String fromDate, String toDate, int? stId, int? stItemGroupId) async {
    var client = http.Client();
    String rStId = stId != null ? '&StId=$stId' : '';
    String rStItemGroupId = stItemGroupId != null ? '&StItemGroupId=$stItemGroupId' : '';

    var url = Uri.parse("${Strings.webShopUrl}${Strings.getStockStatement}?FromDate=$fromDate&ToDate=$toDate$rStId$rStItemGroupId");
    try {
      var response = await client.get(url);

      var jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        stockReportModel = StockReportModel.fromJson(jsonData);

        opTotal = stockReportModel.data!.map((sum) => sum.stkOVAL).fold(0, (a, b) => a + b!);
        purchaseTotal = stockReportModel.data!.map((sum) => sum.stkPVAL).fold(0, (a, b) => a + b!);
        salesTotal = stockReportModel.data!.map((sum) => sum.stkIVAL).fold(0, (a, b) => a + b!);
        lostTotal = stockReportModel.data!.map((sum) => sum.stkLDVAL).fold(0, (a, b) => a + b!);
        closeTotal = stockReportModel.data!.map((sum) => sum.stkCVAL).fold(0, (a, b) => a + b!);

        notifyListeners();
      }
    } catch (e) {
      log(e.toString(), name: 'StockStatement Error');
    }
    notifyListeners();
    return stockReportModel;
  }

  DateTime _selectedFromDate = DateTime.now();
  DateTime _selectedToDate = DateTime.now();

  DateTime get selectedFromDate => _selectedFromDate;
  setSelectedFromDate(DateTime dateTime) {
    _selectedFromDate = dateTime;
    notifyListeners();
  }

  DateTime get selectedToDate => _selectedToDate;
  setSelectedToDate(DateTime dateTime) {
    _selectedToDate = dateTime;
    notifyListeners();
  }

  DateTime _selectFromDate = DateTime.now();
  DateTime get selectFromDate => _selectFromDate;
  setSelectFromDate(DateTime dateTime) {
    _selectFromDate = dateTime;
    notifyListeners();
  }

  void selectStartDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedFromDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2090),
    );
    if (selected != null && selected != selectedFromDate) {
      setSelectedFromDate(selected);
      getStockStatement(
          selectedFromDate.toIso8601String().split("T")[0], selectedToDate.toIso8601String().split("T")[0], stId ?? 0, stItemGroupId ?? 0);
      notifyListeners();
    }
  }

  void selectEndDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedToDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2090),
    );
    if (selected != null && selected != selectedToDate) {
      setSelectedToDate(selected);
      getStockStatement(
          selectedFromDate.toIso8601String().split("T")[0], selectedToDate.toIso8601String().split("T")[0], stId ?? 0, stItemGroupId ?? 0);
      notifyListeners();
    }
  }

  changeBoolValue(String value) {
    boolValue = value;
    notifyListeners();
  }
}
