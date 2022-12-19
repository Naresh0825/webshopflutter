import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/supplier/model/supplier_statement_model.dart';
import 'package:http/http.dart' as http;

class SupplierStatementProvider extends ChangeNotifier {
  SupplierStatementModel supplierStatementModel = SupplierStatementModel();
  TabletSetupServiceProvider tabletSetupServiceProvider = TabletSetupServiceProvider();

  String? fromDate, toDate;

  DateTime? _selectedFromDate;
  DateTime selectedToDate = DateTime.now();

  double balance = 0.0;
  double purchaseTotal = 0.0;
  double payable = 0.0;
  double paymentTotal = 0.0;

  clearBalance() {
    balance = 0.0;
    notifyListeners();
  }

  calculateTotalBalance(SupplierStatement supplierStatement) {
    if (supplierStatement.billCredit! > 0.0 && supplierStatement.billCashIn! > 0.0) {
      balance = balance + supplierStatement.billCredit! - supplierStatement.billCashIn!;
    } else if (supplierStatement.billCredit! > 0.0) {
      balance += supplierStatement.billCredit!;
    } else if (supplierStatement.billCashIn! > 0.0) {
      balance -= supplierStatement.billCashIn!;
    }
  }

  Future<SupplierStatementModel> getSupplierStatement(int supId, String fromDate, String toDate) async {
    var client = http.Client();

    var url = Uri.parse('${Strings.webShopUrl}${Strings.getSupplierStatement}?SUPID=$supId&FromDate=$fromDate&ToDate=$toDate');

    try {
      var response = await client.get(url);

      var jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        supplierStatementModel = SupplierStatementModel.fromJson(jsonData);

        purchaseTotal = supplierStatementModel.data!.map((sum) => sum.billCredit).fold(0, (a, b) => a + b!);
        paymentTotal = supplierStatementModel.data!.map((sum) => sum.billCashIn).fold(0, (a, b) => a + b!);
        payable = purchaseTotal - paymentTotal;
        notifyListeners();
      }
    } catch (e) {
      log(e.toString(), name: 'supplier statement error');
    }

    return supplierStatementModel;
  }

  DateTime? get selectedFromDate => _selectedFromDate;
  setFromDate(DateTime date) {
    _selectedFromDate = date;
    notifyListeners();
  }

  void selectFromDate(BuildContext context, int? supId) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedFromDate!,
      firstDate: DateTime(2000),
      lastDate: DateTime(2090),
    );
    if (supId != null) {
      if (selected != null && selected != selectedFromDate) {
        _selectedFromDate = selected;
        fromDate = selectedFromDate.toString().split(" ")[0];

        getSupplierStatement(supId, fromDate.toString(), toDate.toString());
        notifyListeners();
      }
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: 'Please Choose Supplier',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ColorManager.error,
      );
    }
  }

  void selectToDate(BuildContext context, int? supId) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedToDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2090),
    );

    if (supId != null) {
      if (selected != null && selected != selectedToDate) {
        selectedToDate = selected;
        toDate = selectedToDate.toString().split(" ")[0];

        getSupplierStatement(supId, fromDate.toString(), toDate.toString());
        notifyListeners();
      }
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: 'Please Choose Agent',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ColorManager.error,
      );
    }
  }
}
