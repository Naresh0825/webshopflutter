import 'dart:convert';
import 'dart:developer';

import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/purchase_return/models/purchase_by_bill_model.dart';
import 'package:http/http.dart' as http;

class PurchaseByBillNumberServiceProvider extends ChangeNotifier {
  PurchaseByBillModel purchaseByBillModel = PurchaseByBillModel();

  TextEditingController billNoTextEditingController = TextEditingController();
  TextEditingController paymentTextEditingController = TextEditingController();
  TextEditingController vatTextEditingController = TextEditingController();
  TextEditingController discountTextEditingController = TextEditingController(text: '0.0');

  Future<PurchaseByBillModel> getPurchaseByBillNo(int billNo, {purType = 1}) async {
    var client = http.Client();

    var url = Uri.parse("${Strings.webShopUrl}${Strings.getPurchaseByBillNo}?billno=$billNo&purtype=$purType");

    try {
      var response = await client.get(url);

      var jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        purchaseByBillModel = PurchaseByBillModel.fromJson(jsonData);
        notifyListeners();
      }
    } catch (e) {
      log(e.toString(), name: 'PurchaseByBill Error');
    }

    return purchaseByBillModel;
  }
}
