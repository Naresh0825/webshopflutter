import 'dart:convert';
import 'dart:developer';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/sales/model/sales_add_model.dart';
import 'package:webshop/view/sales_return/models/get_sales_model.dart';
import 'package:http/http.dart' as http;

class GetSalesByIdProvider extends ChangeNotifier {
  GetSalesByIdModel getSalesByIdModel = GetSalesByIdModel();
  List<TradeSaleDetailDtoList> initialSalesReturnList = [];
  List<SalesItemModel> salesReturnCancelList = [];
  List<SalesItemModel> duplicateSalesItemList = [];
  List<SalesItemModel> tempSalesItemList = [];

  double salesReturnSubTotal = 0.0;
  double salesReturnTotalAmount = 0.0;

  Future<GetSalesByIdModel> getSalesById(int traId) async {
    var client = http.Client();

    var url = Uri.parse('${Strings.webShopUrl}${Strings.getSalesById}?traId=$traId');

    try {
      var response = await client.get(url);

      var jsonData = json.decode(response.body);
      if (response.statusCode == 200) {
        getSalesByIdModel = GetSalesByIdModel.fromJson(jsonData);
        notifyListeners();
      }
    } catch (e) {
      log(e.toString(), name: 'GetSalesByIdProvider Error');
    }
    return getSalesByIdModel;
  }

//For List manupulation
  List<bool> isChecked = [];
  double? _cancelQuantity;
  Map<int, int> cancelQty = {};
  List<Businesslist> business = [];

  int canQty = 0;
  double totalAmount = 0.0;

  addBool(List<bool> bool) {
    isChecked = bool;
    notifyListeners();
  }

  changeBool(bool bool, int index) {
    isChecked[index] = bool;
    notifyListeners();
  }

  double? get cancelQuantity => _cancelQuantity;
  void setCancelQuanity(double qty) {
    _cancelQuantity = qty;
    notifyListeners();
  }

  void itemDecrement(TradeSaleDetailDtoList o) {
    cancelQty[o.traDStkId!] = cancelQty[o.traDStkId]! - 1;

    notifyListeners();
  }

  void itemIncreament(TradeSaleDetailDtoList o) {
    cancelQty[o.traDStkId!] = cancelQty[o.traDStkId]! + 1;

    notifyListeners();
  }

  setQuantity(TradeSaleDetailDtoList o, int value) {
    cancelQty[o.traDStkId!] = value;
    notifyListeners();
  }

  bool checkDuplicate(SalesItemModel s) {
    var isDuplicate = duplicateSalesItemList.any((element) => element.traDStkName == s.traDStkName);
    if (isDuplicate) {
      return true;
    } else {
      duplicateSalesItemList.add(s);

      return false;
    }
  }

  addToList(List<TradeSaleDetailDtoList> modelList) {
    initialSalesReturnList.clear();
    initialSalesReturnList = modelList;
    notifyListeners();
  }

  addToCancelList(SalesItemModel modelList) {
    tempSalesItemList.add(modelList);
    if (tempSalesItemList.length == 1) {
      salesReturnCancelList.insert(0, modelList);
    } else {
      var newSalesReturn = salesReturnCancelList.any((element) => element.traDStkName == modelList.traDStkName);
      if (!newSalesReturn) {
        salesReturnCancelList.insert(0, modelList);
      }
    }
  }

  clearCancelList() {
    salesReturnSubTotal = 0.0;
    salesReturnTotalAmount = 0.0;
    tempSalesItemList.clear();
    duplicateSalesItemList.clear();
    salesReturnCancelList.clear();
    initialSalesReturnList.clear();
    notifyListeners();
  }

  deleteSalesReturnItem(SalesItemModel salesItemModel) {
    salesReturnCancelList.removeWhere((element) => element.traDStkName == salesItemModel.traDStkName);
    duplicateSalesItemList.removeWhere((element) => element.traDStkName == salesItemModel.traDStkName);
  }

  calculateSalesReturnSubTotal({double? discount}) {
    salesReturnSubTotal = 0.0;
    if (salesReturnCancelList.isEmpty) {
      salesReturnSubTotal = 0.0;
    }
    for (var element in salesReturnCancelList) {
      salesReturnSubTotal += element.traDAmount!;
    }

    salesReturnTotalAmount = salesReturnSubTotal - (discount! / 100 * salesReturnSubTotal);
    notifyListeners();
  }
}
