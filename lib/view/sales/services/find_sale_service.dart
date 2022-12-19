import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/sales/model/find_sale_model.dart';
import 'package:http/http.dart' as http;

class SaleSummaryServiceProvider extends ChangeNotifier {
  FindSaleModel findSaleModel = FindSaleModel();

  String? fromDate, toDate;
  int? agtId, transType;

  double totalSum = 0.0;
  double cashTotal = 0.0;
  double creditTotal = 0.0;

  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  int? sortColumnIndex;
  bool isAscending = false;
  dynamic data;
  String? customerName;

  TextEditingController customerController = TextEditingController();

  Future<FindSaleModel> getSaleSummary(DateTime fromDate, DateTime toDate, int? agId, {int? traType}) async {
    String fromDateTime = fromDate.toString().split(" ")[0].toString();
    String toDateTime = toDate.toString().split(" ")[0].toString();
    transType = traType;

    var client = http.Client();

    String ifCustomer = agId != null ? '&traAgtId=$agId' : '';

    var url = Uri.parse("${Strings.webShopUrl}${Strings.getSaleSummary}?fromdate=$fromDateTime&todate=$toDateTime$ifCustomer&ReportType=1&traType=$traType");

    try {
      var response = await client.get(url);

      var jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        findSaleModel = FindSaleModel.fromJson(jsonData);

        totalSum = findSaleModel.data!.map((sum) => sum.traTotalAmount).fold(0, (a, b) => a + b!);
        cashTotal = findSaleModel.data!.map((sum) => sum.salesAmount).fold(0, (a, b) => a + b!);
        creditTotal = findSaleModel.data!.map((sum) => sum.creditAmt).fold(0, (a, b) => a + b!);
        notifyListeners();
      }
    } catch (e) {
      log(e.toString(), name: 'Findsale Error');
    }

    return findSaleModel;
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
      getSaleSummary(selectedFromDate, selectedToDate, agtId, traType: transType);
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
      getSaleSummary(selectedFromDate, selectedToDate, agtId, traType: transType);
      notifyListeners();
    }
  }
}
