import 'dart:convert';
import 'dart:developer';

import 'package:webshop/commons/exporter.dart';
import 'package:http/http.dart' as http;

import '../model/add_stock_model.dart';

class AddRemoveStockProvider extends ChangeNotifier {
  Future<dynamic> addStock(StockModel stockModel) async {
    var client = http.Client();

    dynamic jsonData;

    final url = Uri.parse("${Strings.webShopUrl}${Strings.addStock}");
    Map body = {
      "StDes": stockModel.stDes,
      "StCode": stockModel.stCode,
      "StItemGroupId": stockModel.stItemGroupId,
      "StBrandId": stockModel.stBrandId,
      "StInActive": stockModel.stInActive,
      "StOBal": stockModel.stOBal,
      "StORate": stockModel.stORate,
      "StOVal": stockModel.stOVal,
      "StCurBal": stockModel.stCurBal,
      "StCurRate": stockModel.stCurRate,
      "StReOrder": stockModel.stReOrder,
      "StImage": stockModel.stImage,
      "StId": stockModel.stId,
      "StODate": stockModel.stODate,
      "StSalesRate": stockModel.stSalesRate
    };
    try {
      var response = await client.post(
        url,
        body: jsonEncode(body),
        headers: {
          "content-type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        jsonData = jsonDecode(response.body);
        notifyListeners();
      } else if (response.statusCode == 400) {}
    } on Exception catch (e) {
      log(e.toString(), name: 'Add Stock error');
    }

    return jsonData;
  }

  Future<bool> removeStock(int id) async {
    var client = http.Client();
    dynamic status;

    try {
      var response = await client.post(Uri.parse('${Strings.webShopUrl}${Strings.deleteStock}?stId=$id'));

      if (response.statusCode == 200) {
        status = json.decode(response.body);
      } else if (response.statusCode == 404) {
      } else {
        throw Exception('Data Not Found');
      }
    } catch (e) {
      log(e.toString(), name: 'removeStock Error');
    }

    return status!['success'];
  }
}
