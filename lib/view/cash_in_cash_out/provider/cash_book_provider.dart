import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/cash_in_cash_out/model/cash_report_model.dart';
import 'package:http/http.dart' as http;

class CashBookReportServiceProvider extends ChangeNotifier {
  CashReportModel cashReportModel = CashReportModel();

  String? fromDate, toDate;
  double cashTotal = 0.0, cashInTotal = 0.0, cashOutTotal = 0.0;

  Future<CashReportModel> getCashReport(String fromDate, String toDate) async {
    Client client = http.Client();

    var url = Uri.parse('${Strings.webShopUrl}${Strings.getCashBook}?FromDate=$fromDate&ToDate=$toDate');

    try {
      var response = await client.get(url);
      var jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        cashReportModel = CashReportModel.fromJson(jsonData);
        cashInTotal = cashReportModel.data!.map((sum) => sum.billCashIn).fold(0, (a, b) => a + b!);
        cashOutTotal = cashReportModel.data!.map((sum) => sum.billCashOut).fold(0, (a, b) => a + b!);
        cashTotal = cashInTotal - cashOutTotal;
        notifyListeners();
      }
    } catch (e) {
      log(e.toString(), name: 'cash report error');
    }
    return cashReportModel;
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
      getCashReport(selectedFromDate.toIso8601String().split("T")[0], selectedToDate.toIso8601String().split("T")[0]);
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
      getCashReport(selectedFromDate.toIso8601String().split("T")[0], selectedToDate.toIso8601String().split("T")[0]);
      notifyListeners();
    }
  }
}
