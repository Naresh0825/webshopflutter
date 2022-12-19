import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/agent/model/agent_model.dart';

class AddAgentProvider extends ChangeNotifier {
  Future<dynamic> createAgent(AgentModel agentModel) async {
    var client = http.Client();

    dynamic jsonData;

    final url = Uri.parse("${Strings.webShopUrl}${Strings.createAgent}");

    Map body = {
      "AgtId": agentModel.agtId,
      "AgtCompany": agentModel.agtCompany,
      "AgtAdress": agentModel.agtAdress,
      "AgtVatNo": agentModel.agtVatNo,
      "AgtTel": agentModel.agtTel,
      "AgtMobile": agentModel.agtMobile,
      "AgtCategory": agentModel.agtCategory,
      "AgtCreditLimit": 0.0,
      "AgtOpAmount": agentModel.agtOpAmount,
      "AgtAmount": agentModel.agtAmount,
      "AgtInactive": agentModel.agtInactive,
      "AgtSrourceId": agentModel.agtSrourceId,
      "AgtOpDate": DateTime.parse(agentModel.agtOpDate!).toIso8601String(),
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
