import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:webshop/view/sales_return/models/searchsalesbybillno_model.dart';

import '../../../commons/exporter.dart';

class SalesReturnServiceProvider extends ChangeNotifier {
  //API CAll for Sale return by bill Id
  SearchSalesByBillNo searchSalesByBillNoModel = SearchSalesByBillNo();
  Future<SearchSalesByBillNo> getSalesByBillNo(int billNo) async {
    var client = http.Client();

    var url = Uri.parse("${Strings.webShopUrl}${Strings.searchSalesByBillNo}?billNo=$billNo");
    try {
      var response = await client.get(url);

      var jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        searchSalesByBillNoModel = SearchSalesByBillNo.fromJson(jsonData);
        notifyListeners();
      }
    } catch (e) {
      log(e.toString(), name: 'Sale Return');
    }

    return searchSalesByBillNoModel;
  }
}
