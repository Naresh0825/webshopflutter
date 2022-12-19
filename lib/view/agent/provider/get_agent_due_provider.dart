import 'dart:convert';
import 'dart:developer';

import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/agent/model/agent_due_model.dart';
import 'package:http/http.dart' as http;

class AgentDueServiceProvider extends ChangeNotifier {
  AgentDueModel agentDueModel = AgentDueModel();

  List<AgentDue> searchAgentList = [];

  double debtorTotal = 0.0;

  AgentDueServiceProvider() {
    getAgentDue();
  }

  Future<AgentDueModel> getAgentDue() async {
    var client = http.Client();

    var url = Uri.parse("${Strings.webShopUrl}${Strings.getAgentDue}");

    try {
      var response = await client.get(url);

      var jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        agentDueModel = AgentDueModel.fromJson(jsonData);

        debtorTotal = agentDueModel.data!.where((e) => e.agtAmount! > 0.0).map((sum) => sum.agtAmount).fold(0, (a, b) => a + b!);
        notifyListeners();
      }
    } catch (e) {
      log(e.toString(), name: 'agent due model');
    }

    return agentDueModel;
  }

  searchAgent(String value) {
    searchAgentList = agentDueModel.data!
        .where(
          (agent) => agent.agtCompany!.toLowerCase().contains(
                value.toLowerCase(),
              ),
        )
        .toList();

    notifyListeners();
  }
}
