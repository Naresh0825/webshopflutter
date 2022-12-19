import 'dart:convert';
import 'dart:developer';
import 'package:webshop/commons/exporter.dart';
import 'package:http/http.dart' as http;
import 'package:webshop/view/purchase/model/purchase_by_id_model.dart';

class PurchaseByIdServiceProvider extends ChangeNotifier {
  PurchaseByIdModel purchaseByIdModel = PurchaseByIdModel();

  Future<PurchaseByIdModel> getPurchaseById(int purId) async {
    var client = http.Client();

    var url = Uri.parse("${Strings.webShopUrl}${Strings.getPurchaseById}?purId=$purId");

    try {
      var response = await client.get(url);

      var jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        purchaseByIdModel = PurchaseByIdModel.fromJson(jsonData);
        notifyListeners();
      }
    } catch (e) {
      log(e.toString(), name: 'PurchaseById Error');
    }

    return purchaseByIdModel;
  }
}
