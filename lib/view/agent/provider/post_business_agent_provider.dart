import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:http/http.dart' as http;

class PostBusinessAgentProvider extends ChangeNotifier {
  String? dateSelect;
  DateTime selectedDate = DateTime.now();

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController descriptionTextEditingController = TextEditingController();
  TextEditingController amountTextEditingController = TextEditingController();

  Future<dynamic> postBusinessAgent(String billDescription, String selectedDate, double totalAmt, int agtId) async {
    var client = http.Client();

    dynamic jsonData;

    final url = Uri.parse("${Strings.webShopUrl}${Strings.postBusinessAgent}");

    Map body = {
      "BillId": 0,
      "BillPMode": 1,
      "BillDescription": billDescription,
      "BillDate": selectedDate,
      "BillTotalAmt": totalAmt,
      "BillCodeId": 4,
      "BillAgtId": agtId,
      "BillAddedBy": int.parse(sharedPref!.getString('staffId').toString()),
    };

    try {
      var response = await client.post(
        url,
        body: json.encode(body),
        headers: {
          "content-type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
        notifyListeners();
      }
    } catch (e) {
      log(e.toString(), name: 'business agent error');
    }
    return jsonData;
  }

  void selectDate(BuildContext context, int agtId) async {
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
