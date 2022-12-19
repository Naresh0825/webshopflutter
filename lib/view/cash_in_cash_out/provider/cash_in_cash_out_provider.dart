import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/cash_in_cash_out/model/cash_in_cash_out_model.dart';
import 'package:http/http.dart' as http;

class CashInCashOutProvider extends ChangeNotifier {
  CashInCashOutModel cashInCashOutModel = CashInCashOutModel();
  BillDesList? billDesList;

  Future<CashInCashOutModel> getCashInCashOut(int billPMode, DateTime fromDate, DateTime toDate) async {
    Client client = http.Client();

    var url = Uri.parse('${Strings.webShopUrl}${Strings.cashInCashOut}?BillPMode=$billPMode&FromDate=$fromDate&ToDate=$toDate');
    Map<String, String> headers = {
      "content-type": "application/json",
    };
    try {
      var response = await client.get(
        url,
        headers: headers,
      );
      var jsonData = json.decode(response.body);
      if (response.statusCode == 200) {
        cashInCashOutModel = CashInCashOutModel.fromJson(jsonData);
        notifyListeners();
      }
    } catch (e) {
      log(e.toString(), name: 'CashInCashOutProvider');
    }
    return cashInCashOutModel;
  }

  //getter and setter
  DateTime _selectedFromDate = DateTime.now();
  DateTime _selectedToDate = DateTime.now();
  int billPMode = -1;
  double? _totalAmt;
  double? _creditAmt;
  double? _cashIn;
  double? _cashOut;
  bool _showBottom = true;
  bool get showBottom => _showBottom;
  setShowBottomTrue() {
    _showBottom = true;
    notifyListeners();
  }

  setShowBottomFalse() {
    _showBottom = false;
    notifyListeners();
  }

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

  setBillBMode(int billPModeInt) {
    billPMode = billPModeInt;
    notifyListeners();
  }

  double? get totalAmt => _totalAmt;
  setTotalAmt(double totalAmount) {
    _totalAmt = totalAmount;
    notifyListeners();
  }

  double? get creditAmt => _creditAmt;
  setCreditAmt(double credit) {
    _creditAmt = credit;
    notifyListeners();
  }

  double? get cashIn => _cashIn;
  setCashIn(double cash) {
    _cashIn = cash;
    notifyListeners();
  }

  double? get cashOut => _cashOut;
  setCashOut(double cashO) {
    _cashOut = cashO;
    notifyListeners();
  }

  //for Receive and payment page
  DateTime _selectFromDate = DateTime.now();
  String? _billCode;
  int? _cusId, _supId;

  DateTime get selectFromDate => _selectFromDate;
  setSelectFromDate(DateTime dateTime) {
    _selectFromDate = dateTime;
    notifyListeners();
  }

  String? get billCode => _billCode;
  setBillCode(String? text) {
    _billCode = text;
  }

  int? get cusId => _cusId;
  setCusId(int? num) {
    _cusId = num;
    notifyListeners();
  }

  int? get supId => _supId;
  setSupId(int? num) {
    _supId = num;
    notifyListeners();
  }
}
