import 'dart:convert';
import 'dart:developer';

import 'package:webshop/commons/exporter.dart';
import 'package:http/http.dart' as http;
import 'package:webshop/view/supplier/model/supplier_due_model.dart';

class SupplierDueServiceProvider extends ChangeNotifier {
  SupplierDueModel supplierDueModel = SupplierDueModel();

  List<SupplierDue> searchSupplierList = [];

  double creditorTotal = 0.0;

  SupplierDueServiceProvider() {
    getSupplierDue();
  }

  Future<SupplierDueModel> getSupplierDue() async {
    var client = http.Client();

    var url = Uri.parse("${Strings.webShopUrl}${Strings.getSupplierDue}");

    try {
      var response = await client.get(url);

      var jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        supplierDueModel = SupplierDueModel.fromJson(jsonData);

        creditorTotal = supplierDueModel.data!.where((e) => e.supAmount! > 0.0).map((sum) => sum.supAmount).fold(0, (a, b) => a + b!);
        notifyListeners();
      }
    } catch (e) {
      log(e.toString(), name: 'supplier due model');
    }

    return supplierDueModel;
  }

  searchSupplier(String value) {
    searchSupplierList = supplierDueModel.data!
        .where(
          (agent) => agent.supName!.toLowerCase().contains(
                value.toLowerCase(),
              ),
        )
        .toList();

    notifyListeners();
  }
}
