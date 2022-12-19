import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:webshop/commons/exporter.dart';

class GroupProvider extends ChangeNotifier {
  Future<dynamic> createGroup(int itemGroupId, String itemGroupName) async {
    var client = http.Client();

    dynamic jsonData;

    final url = Uri.parse("${Strings.webShopUrl}${Strings.createGroup}");

    Map body = {
      "ItemGroupId": itemGroupId,
      "ItemGroupName": itemGroupName,
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
      log(e.toString(), name: 'CreateGroupError');
    }
    return jsonData;
  }
}
