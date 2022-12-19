import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:http/http.dart' as http;
import 'package:webshop/view/stock/model/stock_details_page_model.dart';

class StockDetailServiceProvider extends ChangeNotifier {
  GetStockDetailModel stockDetailModel = GetStockDetailModel();

  String? fromDate, toDate;
  int? stId;

  Map<String, double> purchaseQtyMap = {};
  Map<String, double> saleQtyMap = {};
  Map<String, double> lostQtyMap = {};
  Map<String, double> totalRateMap = {};

  double totallength = 0.0;

  Map<String, double> currentQtyMap = {};
  Map<String, double> currentRateMap = {};
  Map<String, double> currentTotalMap = {};
  Map<String, List<DetailsStock>> group = {};

  double totalQty = 0.0;
  double balance = 0.0;

  Future<GetStockDetailModel> getStockDetails(String fromDate, String toDate, int? stId) async {
    var client = http.Client();

    var newStId = (stId != null) ? '&StId=$stId' : '';

    var url = Uri.parse("${Strings.webShopUrl}${Strings.getStockDetail}?FromDate=$fromDate&ToDate=$toDate$newStId");
    try {
      var response = await client.get(url);

      var jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        stockDetailModel = GetStockDetailModel.fromJson(jsonData);

        notifyListeners();
      }
    } catch (e) {
      log(e.toString(), name: 'StockDetails Error');
    }
    notifyListeners();
    return stockDetailModel;
  }

  DateTime _selectedFromDate = DateTime.now().subtract(const Duration(days: 7));
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
      getStockDetails(selectedFromDate.toIso8601String().split("T")[0], selectedToDate.toIso8601String().split("T")[0], stId ?? 0);
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
      getStockDetails(selectedFromDate.toIso8601String().split("T")[0], selectedToDate.toIso8601String().split("T")[0], stId ?? 0);
      notifyListeners();
    }
  }

  calculateTotalQty(DetailsStock element) {
    if (element.stkPqty! > 0.0 && element.stkIqty! > 0.0 && element.stkLdqty! > 0.0) {
      totalQty = totalQty + element.stkPqty! - element.stkIqty! - element.stkLdqty!;
    } else if (element.stkPqty! > 0.0 && element.stkIqty! > 0.0) {
      totalQty = totalQty + element.stkPqty! - element.stkIqty!;
    } else if (element.stkPqty! > 0.0 && element.stkLdqty! > 0.0) {
      totalQty = totalQty + element.stkPqty! - element.stkLdqty!;
    } else if (element.stkIqty! > 0.0 && element.stkLdqty! > 0.0) {
      totalQty = totalQty - element.stkIqty! - element.stkLdqty!;
    } else if (element.stkPqty! > 0.0) {
      totalQty += element.stkPqty!;
    } else if (element.stkIqty! > 0.0) {
      totalQty -= element.stkIqty!;
    } else if (element.stkLdqty! > 0.0) {
      totalQty -= element.stkLdqty!;
    }
  }

  calculateBalance(DetailsStock element) {
    balance = totalQty * element.stkRate!;
  }
}
