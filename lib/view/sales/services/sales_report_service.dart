import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:http/http.dart' as http;
import 'package:webshop/view/sales/model/sales_report_model.dart';

class SalesReportServiceProvider extends ChangeNotifier {
  SalesDetailReportModel salesDetailReportModel = SalesDetailReportModel();

  String? fromDate, toDate;
  int? agtId, traDStkId;

  Map<String, double> totalQty = {};
  Map<String, double> totalSales = {};
  Map<String, double> totalCost = {};
  Map<String, List<SalesData>> group = {};

  double profit = 0.0;
  double profitPer = 0.0;

  Future<SalesDetailReportModel> getSalesReport(DateTime fromDate, DateTime toDate, int? agId, int? traDStkId) async {
    String fromDateTime = fromDate.toString().split(" ")[0].toString();
    String toDateTime = toDate.toString().split(" ")[0].toString();

    String ifCustomer = agId != null ? '&AgtId=$agId' : '';
    String ifTraDStkId = traDStkId != null ? '&TraDStkId=$traDStkId' : '';

    var client = http.Client();

    var url =
        Uri.parse("${Strings.webShopUrl}${Strings.getSalesReport}?fromdate=$fromDateTime&todate=$toDateTime$ifCustomer&ReportType=5$ifTraDStkId");

    try {
      var response = await client.get(url);

      var jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        salesDetailReportModel = SalesDetailReportModel.fromJson(jsonData);
        notifyListeners();
      }
    } catch (e) {
      log(e.toString(), name: 'Sales Report Error');
    }
    return salesDetailReportModel;
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
      getSalesReport(selectedFromDate, selectedToDate, agtId, traDStkId);
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
      getSalesReport(selectedFromDate, selectedToDate, agtId, traDStkId);
      notifyListeners();
    }
  }

  calculateProfit(double sAmt, double pAmt) {
    if (sAmt == 0.0 || pAmt == 0.0) {
      profit = 0.0;
    } else {
      profit = sAmt - pAmt;
    }
  }

  calculateProfitPercent(double profit, double pAmt) {
    if (profit == 0.0 || pAmt == 0.0) {
      profitPer = 0.0;
    } else {
      double profitAmt = profit / pAmt;
      profitPer = profitAmt * 100;
    }
  }
}
