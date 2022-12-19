import 'dart:convert';
import 'dart:developer';
import 'package:webshop/commons/exporter.dart';
import 'package:http/http.dart' as http;
import 'package:webshop/view/sales/model/sales_add_model.dart';

class UpdateSalesProvider extends ChangeNotifier {
  Future<dynamic> updateSales(Sales salesDetails, List<SalesItemModel> salesItemList, List<Businesslist> business) async {
    var client = http.Client();
    dynamic jsonData;

    final url = Uri.parse("${Strings.webShopUrl}${Strings.updateSales}");
    SalesModel salesModel = SalesModel(sales: salesDetails, tradeSaledetail: salesItemList, businesslist: business);
    log(salesItemList.length.toString(), name: 'item list');
    log(json.encode(salesModel).toString(), name: 'sales model');

    try {
      var response = await client.post(
        url,
        body: json.encode(salesModel),
        headers: {
          "content-type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        jsonData = jsonDecode(response.body);
        notifyListeners();
      }
    } catch (e) {
      log(e.toString(), name: 'UpdateSalesProvider Error');
    }
    return jsonData;
  }
}
