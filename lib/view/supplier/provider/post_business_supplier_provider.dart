import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:http/http.dart' as http;
import 'package:webshop/view/cash_in_cash_out/model/post_business_model.dart';

class PostBusinessSupplierServiceProvider extends ChangeNotifier {
  String? dateSelect;
  DateTime selectedDate = DateTime.now();

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController descriptionTextEditingController = TextEditingController();
  TextEditingController amountTextEditingController = TextEditingController();

  Future<dynamic> postServiceSupplier(PostBusiness postBusiness) async {
    var client = http.Client();

    dynamic jsonData;

    final url = Uri.parse("${Strings.webShopUrl}${Strings.postBusinessSupplier}");

    try {
      var response = await client.post(
        url,
        body: json.encode(postBusiness),
        headers: {
          "content-type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
        notifyListeners();
      }
    } catch (e) {
      log(e.toString(), name: 'business supplier error');
    }
    return jsonData;
  }

  void selectDate(BuildContext context, int supId) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2090),
    );

    if (selected != null && selected != selectedDate) {
      selectedDate = selected;
      dateSelect = selectedDate.toString().split(" ")[0];

      notifyListeners();
    }
  }

  clear(BuildContext context) {
    dateSelect = DateTime.now().toIso8601String().split("T")[0];
    descriptionTextEditingController.clear();
    amountTextEditingController.clear();
  }
}
