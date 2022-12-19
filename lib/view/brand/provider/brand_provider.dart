import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../commons/exporter.dart';

class BrandProvider extends ChangeNotifier {
  Future<dynamic> createBrand(int itemBrandId, String itemBrandName) async {
    var client = http.Client();

    dynamic jsonData;

    final url = Uri.parse("${Strings.webShopUrl}${Strings.createBrand}");

    Map body = {
      "BrandId": itemBrandId,
      "BrandName": itemBrandName,
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
    } catch (e) {
      log(e.toString(), name: 'CreateBrandError');
    }
    return jsonData;
  }
}
