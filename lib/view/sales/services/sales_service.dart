import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/sales/model/sales_add_model.dart';
import 'package:webshop/view/sales_return/models/get_sales_model.dart';

class SalesServiceProvider extends ChangeNotifier {
  int? _salesStockId;
  double salesAmount = 0.0;
  List<SalesItemModel> salesItemList = [];
  List<SalesItemModel> tempSalesItemList = [];
  List<SalesItemModel> duplicateSalesItemList = [];
  List<Businesslist> business = [];
  double salesSubTotal = 0.0;
  double salesTotalAmount = 0.0;
  double businessTotalAmount = 0.0;
  bool isAdd = true;
  int? indexSalesItem;
  AgentList? agentList;
  bool loading = false;
  List<String> paymentModes = [];
  String? paymentModeString;

  int? agtId;
  String? traDate;

  final formKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();

  TextEditingController custommerNameController = TextEditingController();
  TextEditingController billToController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController panNumberController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController discountController = TextEditingController(text: '0');
  TextEditingController discountPercentController = TextEditingController();

  setIndexSalesItem(int index) {
    indexSalesItem = index;
    notifyListeners();
  }

  changeEntryMode() {
    isAdd = false;
    notifyListeners();
  }

  int? get salesStockId => _salesStockId;
  setSalesStockId(int salesStockId) {
    _salesStockId = salesStockId;
  }

  clearSalesItemList() {
    salesItemList.clear();
    tempSalesItemList.clear();
    notifyListeners();
  }

  deleteSalesItem(SalesItemModel salesItemModel) {
    salesItemList.remove(salesItemModel);
    duplicateSalesItemList.remove(salesItemModel);
    notifyListeners();
  }

  onAddSAles(SalesItemModel s) {
    tempSalesItemList.add(s);

    if (tempSalesItemList.length == 1) {
      salesItemList.insert(0, s);
    } else {
      var newSales = salesItemList.any((element) => element.traDStkId == s.traDStkId);
      if (!newSales) {
        salesItemList.insert(0, s);
      }
    }
    notifyListeners();
  }

  onUpdateSales(SalesItemModel salesItemModel) {
    salesItemList[indexSalesItem!] = salesItemModel;
    isAdd = true;
    notifyListeners();
  }

  bool checkDuplicate(SalesItemModel s) {
    var isDuplicate = duplicateSalesItemList.any((element) => element.traDStkId == s.traDStkId);
    if (isDuplicate) {
      return true;
    } else {
      duplicateSalesItemList.add(s);

      return false;
    }
  }

  calculateTotalSalesAmount(double salesQuantity, double salesRate) {
    salesAmount = salesQuantity * salesRate;
    notifyListeners();
  }

  calculateSalesSubTotal({double? discount}) {
    salesSubTotal = 0.0;
    if (salesItemList.isEmpty) {
      salesSubTotal = 0.0;
    }
    for (var element in salesItemList) {
      salesSubTotal += element.traDAmount!;
      notifyListeners();
    }

    salesTotalAmount = salesSubTotal - (discount ?? 0.0);
  }

  addBusinessList(Businesslist businesslist) {
    business.add(businesslist);
    notifyListeners();
  }

  calculateBusinessTotalAmount() {
    businessTotalAmount = 0.0;
    if (business.isEmpty) {
      businessTotalAmount = 0.0;
    }
    for (var i = 0; i < business.length; i++) {
      businessTotalAmount += double.parse(business[i].billTotalAmt.toString());
    }
    notifyListeners();
  }

  //Getter and setter for sale page
  int? _agentId;
  String? tranType, customerrName;
  int? customerrId;
  bool _showBottom = true;
  bool get showBottom => _showBottom;
  setShowBottomTrue() {
    _showBottom = true;
    notifyListeners();
  }

  setShowBottomFalse() {
    _showBottom = false;
    notifyListeners();
  }

  String? get billPMode => tranType;
  setPMode(String? text) {
    tranType = text;
    notifyListeners();
  }

  String? get customerName => customerrName;
  setCustomerName(String? text) {
    customerrName = text;
    notifyListeners();
  }

  int? get customerId => customerrId;
  setCustomerId(int? num) {
    customerrId = num;
    notifyListeners();
  }

  int? get getAgentId => _agentId;
  setAgentId(int? id) {
    _agentId = id;
    notifyListeners();
  }

  setLoadingTrue() {
    loading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    loading = false;
    notifyListeners();
  }

  setPaymentModes(List<BusinessDtoList> businessDtoList) {
    paymentModes.clear();
    for (var i = 0; i < businessDtoList.length; i++) {
      paymentModes.add(businessDtoList[i].billModeDes.toString());
    }
    paymentModeString = paymentModes.join(",");
    notifyListeners();
  }
}
