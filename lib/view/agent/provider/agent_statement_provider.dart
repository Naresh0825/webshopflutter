import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/agent/model/agent_statement_model.dart';
import 'package:http/http.dart' as http;

class AgentStatementProvider extends ChangeNotifier {
  AgentStatementModel agentStatementModel = AgentStatementModel();

  String? fromDate, toDate;

  DateTime? _selectedFromDate;
  DateTime selectedToDate = DateTime.now();

  double balance = 0.0;
  double receiveable = 0.0;
  double purchaseTotal = 0.0;
  double paymentTotal = 0.0;

  clearBalance() {
    balance = 0.0;
    notifyListeners();
  }

  Future<AgentStatementModel> getAgentStatement(int agtId, String fromDate, String toDate) async {
    var client = http.Client();

    var url = Uri.parse('${Strings.webShopUrl}${Strings.getAgentStatement}?AGTID=$agtId&FromDate=$fromDate&ToDate=$toDate');

    try {
      var response = await client.get(url);

      var jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        agentStatementModel = AgentStatementModel.fromJson(jsonData);

        purchaseTotal = agentStatementModel.data!.map((sum) => sum.billCredit).fold(0, (a, b) => a + b!);
        paymentTotal = agentStatementModel.data!.map((sum) => sum.billCashIn).fold(0, (a, b) => a + b!);
        receiveable = purchaseTotal - paymentTotal;
        notifyListeners();
      }
    } catch (e) {
      log(e.toString(), name: 'agent statement error');
    }

    return agentStatementModel;
  }

  DateTime? get selectedFromDate => _selectedFromDate;
  setSelectedFromDate(DateTime? dateTime) {
    _selectedFromDate = dateTime!;
  }

  void selectFromDate(BuildContext context, int? agtId) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedFromDate!,
      firstDate: DateTime(2000),
      lastDate: DateTime(2090),
    );
    if (agtId != null) {
      if (selected != null && selected != selectedFromDate) {
        _selectedFromDate = selected;
        fromDate = selectedFromDate.toString().split(" ")[0];

        getAgentStatement(agtId, fromDate.toString(), toDate.toString());
        notifyListeners();
      }
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: 'Please Choose Agent',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ColorManager.error,
      );
    }
  }

  void selectToDate(BuildContext context, int? agtId) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedToDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2090),
    );

    if (agtId != null) {
      if (selected != null && selected != selectedToDate) {
        selectedToDate = selected;
        toDate = selectedToDate.toString().split(" ")[0];

        getAgentStatement(agtId, fromDate.toString(), toDate.toString());
        notifyListeners();
      }
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: 'Please Choose Agent',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ColorManager.error,
      );
    }
  }
}
