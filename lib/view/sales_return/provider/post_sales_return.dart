import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:webshop/view/sales/model/sales_add_model.dart';
import '../../../commons/exporter.dart';

class PostSaleReturnProvider extends ChangeNotifier {
  Future<dynamic> postSalesReturn(SalesModel salesModel) async {
    SalesModel bodySalesReturn = SalesModel(sales: salesModel.sales, tradeSaledetail: salesModel.tradeSaledetail, businesslist: salesModel.businesslist);
    var client = http.Client();
    dynamic jsonData;
    var test = json.encode(bodySalesReturn);
    log(test);

    final url = Uri.parse("${Strings.webShopUrl}${Strings.updateSales}");

    try {
      var response = await client.post(
        url,
        body: json.encode(bodySalesReturn),
        headers: {
          "content-type": "application/json",
        },
      );
      log(json.encode(bodySalesReturn), name: 'PostSalesReturn');
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
