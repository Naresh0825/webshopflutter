import 'dart:convert';
import 'dart:developer';

import 'package:webshop/commons/exporter.dart';
import 'package:http/http.dart' as http;

class DeleteSalesServiceProvider extends ChangeNotifier {
 TextEditingController reasonTextEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<dynamic> deleteSales(int traId, String remark) async {
    var client = http.Client();
    dynamic jsonData;

    int staffId = int.parse(sharedPref!.getString('staffId').toString());

    final url = Uri.parse('${Strings.webShopUrl}${Strings.deleteSales}?TraId=$traId&StaffId=$staffId&TraRemark=$remark');

    try {
      var response = await client.get(url);

      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
        notifyListeners();
      }
    } catch (e) {
      log(e.toString(), name: 'sales delete error');
    }

    return jsonData;
  }
}
