import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:webshop/commons/exporter.dart';

class ValidMacAddressProvider extends ChangeNotifier {
  Future getMacID(String macId) async {
    var client = http.Client();

    dynamic jsonData;

    final url = Uri.parse('${Strings.webShopUrl}${Strings.validMAC}?MACID=$macId');

    try {
      var response = await client.get(
        url,
      );

      if (response.statusCode == 200) {
        jsonData = jsonDecode(response.body);

        notifyListeners();
      }
    } on Exception catch (_) {}
    return jsonData;
  }

  Future<dynamic> addMacID(String macId) async {
    var client = http.Client();

    dynamic jsonData;

    final url = Uri.parse('${Strings.webShopUrl}${Strings.updateMAC}');

    Map body = {"DeviceMACId": macId};

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
      }
    } catch (e) {
      log(e.toString(), name: 'Add Mac Error');
    }
    return jsonData;
  }
}
