import 'dart:convert';
import 'dart:developer';

import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/stock/model/stock_list_model.dart';
import 'package:http/http.dart' as http;

class GetStockListProvider extends ChangeNotifier {
  GetStockListModel getStockListModel = GetStockListModel();
  List<StockDetailList> searchStockList = [];

  Future<GetStockListModel> getStockList(int? stBrandId) async {
    var client = http.Client();

    String newStBrandId = stBrandId != null ? '&StBrandId=$stBrandId' : "";

    var url = Uri.parse("${Strings.webShopUrl}${Strings.getStockList}?$newStBrandId");
    try {
      var response = await client.get(url);

      var jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        getStockListModel = GetStockListModel.fromJson(jsonData);

        notifyListeners();
      }
    } catch (e) {
      log(e.toString(), name: 'getStockList Error');
    }
    notifyListeners();
    return getStockListModel;
  }

  searchStock(String value) {
    searchStockList = getStockListModel.data!
        .where(
          (stock) =>
              stock.stDes!.toLowerCase().contains(
                    value.toLowerCase(),
                  ) ||
              stock.brandName!.toLowerCase().contains(value.toLowerCase()),
        )
        .toList();

    notifyListeners();
  }
}
