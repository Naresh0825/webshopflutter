import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/supplier/model/supplier_model.dart';

class AddSupplierProvider extends ChangeNotifier {
  Future<dynamic> createSupplier(SupplierModel supplierModel) async {
    var client = http.Client();

    dynamic jsonData;

    final url = Uri.parse("${Strings.webShopUrl}${Strings.createSupplier}");

    Map body = {
      "SupId": supplierModel.supId,
      "SupName": supplierModel.supName,
      "SupVatNo": supplierModel.supVat,
      "SupAddress": supplierModel.supAddress,
      "SupMobile": supplierModel.supMobile,
      "SupPhone": supplierModel.supPhone,
      "SupOpDate": DateTime.parse(supplierModel.supOpDate).toIso8601String(),
      "SupOpAmount": supplierModel.supOpAmt,
      "SupAmount": supplierModel.supAmt,
      "SupInActive": supplierModel.supInActive,
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
      log(e.toString(), name: 'CreateSupplier Error');
    }
    return jsonData;
  }
}
