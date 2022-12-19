class CreatePurchase {
  PurchaseDetails? purchase;
  List<PurchaseItemModel>? purchasedetail;

  CreatePurchase({this.purchase, this.purchasedetail});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (purchase != null) {
      data['purchase'] = purchase!.toJson();
    }
    if (purchasedetail != null) {
      data['purchasedetail'] = purchasedetail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PurchaseItemModel {
  final int purDStkId;
  final int purDId;
  final double purDQty;
  final String purchaseStkName;
  final double purDRate;
  final double stkTotal;
  final double? purDSalesRate;

  const PurchaseItemModel({
    required this.purDStkId,
    required this.purDId,
    required this.purDQty,
    required this.purchaseStkName,
    required this.purDRate,
    required this.stkTotal,
    this.purDSalesRate,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PurDStkId'] = purDStkId;
    data['PurDId'] = purDId;
    data['PurchaseStkName'] = purchaseStkName;
    data['PurDQty'] = purDQty;
    data['PurDRate'] = purDRate;
    data['PurDAmount'] = stkTotal;
    data['PurDSalesRate'] = purDSalesRate;
    return data;
  }
}

class PurchaseDetails {
  int? purId;
  int? purType;
  String? purDate;
  int? purSupId;
  int? purMode;
  int? purCashCredit;
  String? purInsertedDate;
  int? purInsertedBy;
  double? purSubAmount;
  double? purDiscAmount;
  double? purTaxableAmount;
  double? purNonTaxableAmount;
  double? purVatAmount;
  double? purTotalAmount;
  bool? purInActive;
  String? purBillNo;
  String? supplier;

  PurchaseDetails({
    this.purId,
    this.purType,
    this.purDate,
    this.purSupId,
    this.purMode,
    this.purCashCredit,
    this.purInsertedDate,
    this.purInsertedBy,
    this.purSubAmount,
    this.purDiscAmount,
    this.purTaxableAmount,
    this.purNonTaxableAmount,
    this.purVatAmount,
    this.purTotalAmount,
    this.purInActive,
    this.purBillNo,
    this.supplier,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PurId'] = purId;
    data['PurType'] = purType;
    data['PurDate'] = purDate;
    data['PurSupId'] = purSupId;
    data['PurMode'] = purMode;
    data['PurCashCredit'] = purCashCredit;
    data['PurInsertedDate'] = purInsertedDate;
    data['PurInsertedBy'] = purInsertedBy;
    data['PurSubAmount'] = purSubAmount;
    data['PurDiscAmount'] = purDiscAmount;
    data['PurTaxableAmount'] = purTaxableAmount;
    data['PurNonTaxableAmount'] = purNonTaxableAmount;
    data['PurVatAmount'] = purVatAmount;
    data['PurTotalAmount'] = purTotalAmount;
    data['PurInActive'] = purInActive;
    data['PurBillNo'] = purBillNo;
    data['supplier'] = supplier;
    return data;
  }
}
