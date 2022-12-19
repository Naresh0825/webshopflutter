import 'dart:convert';
import 'dart:developer';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/purchase/model/purchase_by_id_model.dart';
import 'package:webshop/view/purchase/model/purchase_item_model.dart';
import 'package:webshop/view/purchase/model/purchase_model.dart';
import 'package:http/http.dart' as http;

class PurchaseServiceProvider extends ChangeNotifier {
  PurchaseModel purchaseModel = PurchaseModel();

  //Calculation of credentials for purchase Page
  double purchaseSubTotal = 0.0;
  double purchaseSubTotalAfterDiscount = 0.0;
  double purchaseTaxableAmount = 0.0;
  double purchaseNonTaxableAmount = 0.0;
  double purchaseVatAmount = 0.0;
  double purchaseTotalAmount = 0.0;

  //All the List for purchase Page
  List<PurchaseItemModel> purchaseItemList = [];
  List<PurchaseItemModel> tempPurchaseItemList = [];
  List<PurchaseItemModel> duplicatePurchaseItemList = [];

  //purchasereturn
  double returnSubTotal = 0.0;
  double returnTotal = 0.0;

  bool duplicate = false;
  bool isAddPurchase = true;
  int? oldPurchaseItemIndex, purId, supId;

  String? fromDate, toDate, billName, payType, transactiontype, purchaseDate;

  ScrollController scrollController = ScrollController();

  //purchase Controllers
  TextEditingController supplierNameController = TextEditingController();
  TextEditingController discountController = TextEditingController(text: '0.0');

  setOldPurchaseItemIndex(int index) {
    oldPurchaseItemIndex = index;
    notifyListeners();
  }

  toggleIsAddPurchase(bool isAddPurchase) {
    this.isAddPurchase = isAddPurchase;
    notifyListeners();
  }

  setPurchaseTotalAmount(double purchaseTotalAmount) {
    this.purchaseTotalAmount = purchaseTotalAmount;
    notifyListeners();
  }

  Future<PurchaseModel> findPurchase(DateTime fromdate, DateTime toDate, int? supId, {int? purType}) async {
    String fromDateTime = fromdate.toString().split(" ")[0].toString();
    String toDateTime = toDate.toString().split(" ")[0].toString();

    String ifSupplier = supId != null ? '&PurSupId=$supId' : '';

    var client = http.Client();

    var url = Uri.parse("${Strings.webShopUrl}${Strings.findPurchaseSummary}?FromDate=$fromDateTime&ToDate=$toDateTime&PurType=$purType&$ifSupplier");

    try {
      var response = await client.get(url);

      var jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        purchaseModel = PurchaseModel.fromJson(jsonData);
        notifyListeners();
      }
    } catch (e) {
      log(e.toString(), name: 'FindPurchase Error');
    }

    return purchaseModel;
  }

  bool checkDuplicate(PurchaseItemModel p) {
    var isDuplicate = duplicatePurchaseItemList.any((element) => element.purDStkId == p.purDStkId);
    if (isDuplicate) {
      return true;
    } else {
      duplicatePurchaseItemList.add(p);
      return false;
    }
  }

  setPurchaseItem(PurchaseItemModel p) {
    tempPurchaseItemList.add(p);

    if ((tempPurchaseItemList.length) == 1) {
      purchaseItemList.insert(0, p);
    } else {
      var newPurchase = purchaseItemList.any((element) => element == p);
      if (!newPurchase) {
        log(jsonEncode(p));
        purchaseItemList.insert(0, p);
      }
    }
  }

  removePurchaseItem(PurchaseItemModel p) {
    purchaseItemList.removeWhere((element) => element == p);
    notifyListeners();
  }

  setClearDuplicateMenu(PurchaseItemModel p) {
    if (duplicatePurchaseItemList.contains(p)) {
      duplicatePurchaseItemList.remove(p);
    }
  }

//Getter and Setter fot this provider and page
  int? _purStockId;
  double? _purAmount;
  DateTime _selectedFromDate = DateTime.now();
  DateTime _selectedToDate = DateTime.now();
  int? _brandId;
  bool loading = false;
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

  setLoadingFalse() {
    loading = false;
    notifyListeners();
  }

  setLoadingTrue() {
    loading = true;
    notifyListeners();
  }

  int? get brandId => _brandId;
  setBrandId(int? id) {
    _brandId = id;
    notifyListeners();
  }

  DateTime get selectedFromDate => _selectedFromDate;
  setSelectedFromDate(DateTime dateTime) {
    _selectedFromDate = dateTime;
  }

  DateTime get selectedToDate => _selectedToDate;
  setSelectedToDate(DateTime dateTime) {
    _selectedToDate = dateTime;
    notifyListeners();
  }

  int? get purStockId => _purStockId;
  setPurStockId(int stockId) {
    _purStockId = stockId;
    notifyListeners();
  }

  double? get purAmount => _purAmount ?? 0.0;
  setpurAmount(double? purAmount) {
    _purAmount = purAmount ?? 0.0;
    notifyListeners();
  }

  calculateSubTotal(int vatNonVat, {double? discount}) {
    purchaseSubTotal = 0.0;
    if (purchaseItemList.isEmpty) {
      purchaseSubTotal = 0.0;
    }
    for (var element in purchaseItemList) {
      purchaseSubTotal += element.stkTotal;
      notifyListeners();
    }
    calculateTotal(discount, vatNonVat);
  }

  calculateTotal(double? discount, int vatNonVat) {
    purchaseSubTotalAfterDiscount = purchaseSubTotal - (discount ?? 0.0);

    if (vatNonVat == 0) {
      purchaseTaxableAmount = purchaseSubTotalAfterDiscount;
      purchaseVatAmount = .13 * purchaseTaxableAmount;
      purchaseTotalAmount = purchaseTaxableAmount + purchaseVatAmount;
    } else {
      purchaseNonTaxableAmount = purchaseSubTotalAfterDiscount;
      purchaseTotalAmount = purchaseNonTaxableAmount;
    }

    notifyListeners();
  }

  editPurchaseItem(PurchaseItemModel newPurchaseModel) {
    purchaseItemList[oldPurchaseItemIndex!] = newPurchaseModel;
    duplicatePurchaseItemList[oldPurchaseItemIndex!] = newPurchaseModel;
    toggleIsAddPurchase(true);
  }

  int? _supplierId;

  int? get supplierId => _supplierId;
  setSupId(int? id) {
    _supplierId = id;
    notifyListeners();
  }

  addToPurchaseModelList(List<PurchaseDetailDtoList>? purchaseDetailDtoList) {
    for (var i = 0; i < purchaseDetailDtoList!.length; i++) {
      PurchaseDetailDtoList purchaseDetailList = purchaseDetailDtoList[i];
      PurchaseItemModel purchaseItemModel = PurchaseItemModel(
        purDStkId: int.parse(purchaseDetailList.purDStkId.toString()),
        purDId: int.parse(purchaseDetailList.purDId.toString()),
        purDQty: double.parse(purchaseDetailList.purDQty.toString()),
        purchaseStkName: purchaseDetailList.stDes.toString(),
        purDRate: double.parse(purchaseDetailList.purDRate.toString()),
        stkTotal: double.parse(
          purchaseDetailList.purDAmount.toString(),
        ),
      );
      purchaseItemList.add(purchaseItemModel);
      tempPurchaseItemList.add(purchaseItemModel);
      duplicatePurchaseItemList.add(purchaseItemModel);
    }
    notifyListeners();
  }

  calculateTotalReturn(double discount) {
    returnTotal = 0.0;
    returnSubTotal = 0.0;

    returnSubTotal = purchaseItemList.map((sum) => sum.stkTotal).fold(0, (a, b) => a + b);
    returnTotal = returnSubTotal - double.parse(discount.toString());
  }

  calculateDiscount(String value) {
    double discAmt = value.isEmpty || value == "0.0" ? 0.0 : double.parse(value.toString());
    calculateTotalReturn(discAmt);
    notifyListeners();
  }
}
