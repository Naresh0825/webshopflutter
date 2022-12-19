import 'dart:convert';
import 'dart:developer';

import 'package:webshop/commons/exporter.dart';
import 'package:http/http.dart' as http;
import 'package:webshop/view/purchase/model/purchase_item_model.dart';

class UpdatePurchaseServiceProvider extends ChangeNotifier {
  CreatePurchase detailCreatePurchase = CreatePurchase();
  Future<dynamic> updatePurchase(CreatePurchase createPurchase) async {
    var client = http.Client();

    dynamic jsonData;

    final url = Uri.parse("${Strings.webShopUrl}${Strings.updatePurchase}");

    var purchaseDate = DateTime.parse(DateTime.now().toString().split(" ")[0]).toIso8601String();

    PurchaseDetails purchaseDetails = PurchaseDetails(
      purId: createPurchase.purchase!.purId ?? 0,
      purType: createPurchase.purchase!.purType,
      purDate: purchaseDate,
      purSupId: createPurchase.purchase!.purSupId,
      purMode: createPurchase.purchase!.purMode,
      purCashCredit: createPurchase.purchase!.purCashCredit,
      purInsertedDate: purchaseDate,
      purInsertedBy: createPurchase.purchase!.purInsertedBy,
      purSubAmount: createPurchase.purchase!.purSubAmount,
      purDiscAmount: createPurchase.purchase!.purDiscAmount,
      purTaxableAmount: createPurchase.purchase!.purTaxableAmount,
      purNonTaxableAmount: createPurchase.purchase!.purNonTaxableAmount,
      purVatAmount: createPurchase.purchase!.purVatAmount,
      purTotalAmount: createPurchase.purchase!.purTotalAmount,
      purInActive: createPurchase.purchase!.purInActive,
      purBillNo: createPurchase.purchase!.purBillNo,
      supplier: createPurchase.purchase!.supplier,
    );

    detailCreatePurchase = CreatePurchase(purchase: purchaseDetails, purchasedetail: createPurchase.purchasedetail);

    try {
      var response = await client.post(
        url,
        body: json.encode(detailCreatePurchase),
        headers: {
          "content-type": "application/json",
        },
      );
      log(json.encode(detailCreatePurchase));
      if (response.statusCode == 200) {
        jsonData = jsonDecode(response.body);
        notifyListeners();
      } else if (response.statusCode == 400) {}
    } on Exception catch (e) {
      log(e.toString(), name: 'updatepurchase error');
    }

    return jsonData;
  }

  String? _billName;

  String? get billName => _billName;

  setBillName(String? bill) {
    _billName = bill;
    notifyListeners();
  }
}
