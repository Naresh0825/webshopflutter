import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:webshop/commons/exporter.dart';

class TabletSetupServiceProvider extends ChangeNotifier {
  TabletSetupModel tabletSetupModel = TabletSetupModel();

  SupplierList? supplierList;
  AgentList? agentList;

  StockList? stockList;
  ItemGroupList? groupName;
  BrandList? brandList;
  int? brandId;

  String? supplierName;
  String? paymentName;
  String? cashCreditName;

  List<StockList> searchStockList = [];
  List<ItemGroupList> searchGroupList = [];
  List<BrandList> searchBrandList = [];
  List<AgentList> searchAgentList = [];
  List<SupplierList> searchSupplierList = [];

  Map<int, double> quantity = {};

  double price = 0.0;

  TabletSetupServiceProvider() {
    getTabletSetup();
  }

  Future<TabletSetupModel> getTabletSetup() async {
    var client = http.Client();

    var url = Uri.parse("${Strings.webShopUrl}${Strings.tabletSetup}");

    try {
      var response = await client.get(url);

      var jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        tabletSetupModel = TabletSetupModel.fromJson(jsonData);
        notifyListeners();
      }
    } catch (e) {
      log(e.toString(), name: 'TabletError');
    }
    notifyListeners();
    return tabletSetupModel;
  }

  searchStock(String value) {
    searchStockList = tabletSetupModel.data!.stockList!
        .where(
          (stock) => stock.stDes!.toLowerCase().contains(
                value.toLowerCase(),
              ),
        )
        .toList();

    notifyListeners();
  }

  searchItemGroup(String value) {
    searchGroupList = tabletSetupModel.data!.itemGroupList!
        .where(
          (group) => group.itemGroupName!.toLowerCase().contains(
                value.toLowerCase(),
              ),
        )
        .toList();

    notifyListeners();
  }

  searchItemBrand(String value) {
    searchBrandList = tabletSetupModel.data!.brandList!
        .where(
          (group) => group.brandName!.toLowerCase().contains(
                value.toLowerCase(),
              ),
        )
        .toList();

    notifyListeners();
  }

  getSupplierName(int supId) {
    for (var i = 0; i < tabletSetupModel.data!.supplierList!.length; i++) {
      if (supId == tabletSetupModel.data!.supplierList![i].supId) {
        supplierName = tabletSetupModel.data!.supplierList![i].supName;
      }
    }
    notifyListeners();
  }

  getSupplierTransaction(String payment) {
    for (var i = 0; i < tranMode.length; i++) {
      if (payment == tranMode[i]['id']) {
        paymentName = tranMode[i]['name'];
      }
    }
    notifyListeners();
  }

  getSupplierCashCredit(String cashCredit) {
    for (var i = 0; i < paymentType.length; i++) {
      if (cashCredit == paymentType[i]['id']) {
        cashCreditName = paymentType[i]['name'];
      }
    }
    notifyListeners();
  }

  searchAgentListShowall(String value) {
    searchAgentList = tabletSetupModel.data!.agentList!
        .where(
          (agent) => agent.agtCompany!.toLowerCase().contains(
                value.toLowerCase(),
              ),
        )
        .toList();

    notifyListeners();
  }

  searchSupplierListShowall(String value) {
    searchSupplierList = tabletSetupModel.data!.supplierList!
        .where(
          (agent) => agent.supName!.toLowerCase().contains(
                value.toLowerCase(),
              ),
        )
        .toList();

    notifyListeners();
  }

  selectAgent(int agtId) {
    for (var i = 0; i < tabletSetupModel.data!.agentList!.length; i++) {
      if (tabletSetupModel.data!.agentList![i].agtId == agtId) {
        agentList = tabletSetupModel.data!.agentList![i];
      }
    }
  }

  selectSupplier(int supId) {
    for (var i = 0; i < tabletSetupModel.data!.supplierList!.length; i++) {
      if (tabletSetupModel.data!.supplierList![i].supId == supId) {
        supplierList = tabletSetupModel.data!.supplierList![i];
      }
    }
  }

  selectStock(int stId) {
    for (var i = 0; i < tabletSetupModel.data!.stockList!.length; i++) {
      if (tabletSetupModel.data!.stockList![i].stId == stId) {
        stockList = tabletSetupModel.data!.stockList![i];
      }
    }
  }

  selectBrandName(int stbrandId) {
    for (var i = 0; i < tabletSetupModel.data!.brandList!.length; i++) {
      if (tabletSetupModel.data!.brandList![i].brandId == stbrandId) {
        brandList = tabletSetupModel.data!.brandList![i];
      }
    }
  }

  selectGroupName(int stGroupId) {
    for (var i = 0; i < tabletSetupModel.data!.itemGroupList!.length; i++) {
      if (tabletSetupModel.data!.itemGroupList![i].itemGroupId == stGroupId) {
        groupName = tabletSetupModel.data!.itemGroupList![i];
      }
    }
  }

  
}
