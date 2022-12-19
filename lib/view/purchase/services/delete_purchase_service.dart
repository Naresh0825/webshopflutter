import 'dart:convert';
import 'dart:developer';

import 'package:webshop/commons/exporter.dart';
import 'package:http/http.dart' as http;

class DeletePurchaseServiceProvider extends ChangeNotifier {
  TextEditingController reasonTextEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Future<dynamic> deletePurchase(int purId, String remark) async {
    var client = http.Client();
    dynamic jsonData;

    int staffId = int.parse(sharedPref!.getString('staffId').toString());

    final url = Uri.parse('${Strings.webShopUrl}${Strings.deletePurchase}?PurId=$purId&StaffId=$staffId&Remark=$remark');

    try {
      var response = await client.get(url);

      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
        notifyListeners();
      }
    } catch (e) {
      log(e.toString(), name: 'purchase delete error');
    }

    return jsonData;
  }

  Future<dynamic> deletePurchaseItem(int purDId) async {
    var client = http.Client();
    dynamic jsonData;

    final url = Uri.parse('${Strings.webShopUrl}${Strings.deletePurchaseItem}?PurDId=$purDId');

    try {
      var response = await client.post(
        url,
        headers: {
          "content-type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
        notifyListeners();
      }
    } catch (e) {
      log(e.toString(), name: 'Purchase Item delete error');
    }

    return jsonData;
  }
}
