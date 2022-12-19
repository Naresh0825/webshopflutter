import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/cash_in_cash_out/model/getbusiness_by_id_model.dart';

class EditCashInOutProvider extends ChangeNotifier {
    GetBusinessByIdModel getBusinessByIdModel = GetBusinessByIdModel();
  BillDesList? billDesList;
  String? _billCode;
  Future<GetBusinessByIdModel> getGetBusinessById(int billId) async {
    Client client = http.Client();

    var url = Uri.parse('${Strings.webShopUrl}${Strings.getBusinessById}?billid=$billId');

    try {
      var response = await client.get(url);
      var jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        getBusinessByIdModel = GetBusinessByIdModel.fromJson(jsonData);

        notifyListeners();
      }
    } catch (e) {
      log(e.toString(), name: 'EditCashInOutProvider Error');
    }
    return getBusinessByIdModel;
  }

  String? get billCode => _billCode;
  setBillCode(String? text) {
    _billCode = text;
  }

  DateTime _selectFromDate = DateTime.now();
DateTime get selectFromDate => _selectFromDate;
  setSelectFromDate(DateTime dateTime) {
    _selectFromDate = dateTime;
    notifyListeners();
  }
}
