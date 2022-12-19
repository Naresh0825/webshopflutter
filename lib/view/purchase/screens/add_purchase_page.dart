import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/purchase/model/purchase_item_model.dart';
import 'package:webshop/view/purchase/services/delete_purchase_service.dart';
import 'package:webshop/view/purchase/services/purchase_by_id_service.dart';
import 'package:webshop/view/purchase/services/purchase_service.dart';
import 'package:webshop/view/purchase_return/provider/purchase_bill_number_provider.dart';
import 'package:webshop/view/purchase_return/purchase_return_entries.dart';
import 'package:webshop/view/stock/model/stock_list_model.dart';
import 'package:webshop/view/stock/screens/add_item.dart';
import 'package:webshop/view/stock/services/get_stock_detail_provider.dart';

class AddPurchasePage extends StatefulWidget {
  final int transactionType;
  final int? purId;
  final bool isPurchaseReturn;
  final TextEditingController discountController;
  final bool isPurchaseEdit;
  const AddPurchasePage({
    super.key,
    required this.transactionType,
    required this.discountController,
    required this.isPurchaseEdit,
    this.purId,
    required this.isPurchaseReturn,
  });

  @override
  State<AddPurchasePage> createState() => _AddPurchasePageState();
}

class _AddPurchasePageState extends State<AddPurchasePage> {
  TextEditingController stockTextController = TextEditingController();
  TextEditingController qtyTextController = TextEditingController();
  TextEditingController rateTextController = TextEditingController();
  TextEditingController saleRateTextController = TextEditingController();

  FocusNode brandFocusNode = FocusNode();
  FocusNode stockFocusNode = FocusNode();
  FocusNode qtyFocusNode = FocusNode();
  FocusNode rateFocusNode = FocusNode();

  TabletSetupServiceProvider? watchTabletSetupServiceProvider;
  GetStockListProvider? watchGetStockListProvider;
  PurchaseByIdServiceProvider? readPurchaseByIdServiceProvider;
  PurchaseServiceProvider? readPurchaseServiceProvider;
  int? brandId;

  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    context.read<GetStockListProvider>().getStockList(brandId);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    brandFocusNode.dispose();
    stockFocusNode.dispose();
    qtyFocusNode.dispose();
    rateFocusNode.dispose();
  }

  Future<void> refresh() async {
    readPurchaseServiceProvider = context.read<PurchaseServiceProvider>();
    readPurchaseServiceProvider!.purchaseItemList.clear();
    readPurchaseServiceProvider!.duplicatePurchaseItemList.clear();
    readPurchaseServiceProvider!.tempPurchaseItemList.clear();
    readPurchaseByIdServiceProvider = context.read<PurchaseByIdServiceProvider>();
    readPurchaseServiceProvider = context.read<PurchaseServiceProvider>();
    await readPurchaseByIdServiceProvider!.getPurchaseById(widget.purId!);
    var purchaseDetails = readPurchaseByIdServiceProvider!.purchaseByIdModel.data!;
    readPurchaseServiceProvider!.purId = readPurchaseByIdServiceProvider!.purchaseByIdModel.data!.purId;
    readPurchaseServiceProvider!.supplierNameController.text = purchaseDetails.supplier.toString();
    readPurchaseServiceProvider!.supId = purchaseDetails.purSupId;
    readPurchaseServiceProvider!.billName = purchaseDetails.purBillNo;
    readPurchaseServiceProvider!.setSelectedFromDate(DateTime.parse(purchaseDetails.purDate.toString()));
    readPurchaseServiceProvider!.payType = purchaseDetails.purCashCredit.toString();
    readPurchaseServiceProvider!.discountController.text = purchaseDetails.purDiscAmount.toString();
    readPurchaseServiceProvider!.transactiontype = purchaseDetails.purMode.toString();
    readPurchaseServiceProvider!.purchaseSubTotal = double.parse(purchaseDetails.purSubAmount.toString());
    readPurchaseServiceProvider!.purchaseTaxableAmount = double.parse(purchaseDetails.purTaxableAmount.toString());
    readPurchaseServiceProvider!.purchaseNonTaxableAmount = double.parse(purchaseDetails.purNonTaxableAmount.toString());
    readPurchaseServiceProvider!.purchaseVatAmount = double.parse(purchaseDetails.purVatAmount.toString());
    readPurchaseServiceProvider!.purchaseTotalAmount = double.parse(purchaseDetails.purTotalAmount.toString());

    var data = readPurchaseByIdServiceProvider!.purchaseByIdModel.data!;
    //Purchase List Items
    for (var i = 0; i < data.purchaseDetailDtoList!.length; i++) {
      PurchaseItemModel purchaseItemModel = PurchaseItemModel(
        purDId: int.parse(data.purchaseDetailDtoList![i].purDId.toString()),
        purDStkId: int.parse(data.purchaseDetailDtoList![i].purDStkId.toString()),
        purDQty: double.parse(data.purchaseDetailDtoList![i].purDQty.toString()),
        purchaseStkName: data.purchaseDetailDtoList![i].stDes.toString(),
        purDRate: double.parse(data.purchaseDetailDtoList![i].purDRate.toString()),
        stkTotal: double.parse(data.purchaseDetailDtoList![i].purDAmount.toString()),
        purDSalesRate: data.purchaseDetailDtoList![i].purDSalesRate == null
            ? 0.0
            : double.parse(
                data.purchaseDetailDtoList![i].purDSalesRate.toString(),
              ),
      );
      readPurchaseServiceProvider!.purchaseItemList.add(purchaseItemModel);
      readPurchaseServiceProvider!.duplicatePurchaseItemList.add(purchaseItemModel);
      readPurchaseServiceProvider!.tempPurchaseItemList.add(purchaseItemModel);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    watchTabletSetupServiceProvider = context.watch<TabletSetupServiceProvider>();
    watchGetStockListProvider = context.watch<GetStockListProvider>();
    PurchaseServiceProvider readPurchaseServiceProvider = context.read<PurchaseServiceProvider>();
    PurchaseServiceProvider watchPurchaseServiceProvider = context.watch<PurchaseServiceProvider>();
    DeletePurchaseServiceProvider readDeletePurchaseServiceProvider = context.read<DeletePurchaseServiceProvider>();
    PurchaseByBillNumberServiceProvider readPurchaseBillServiceProvider = context.read<PurchaseByBillNumberServiceProvider>();

    return Consumer<ConnectivityProvider>(builder: (context, connectivity, child) {
      return (connectivity.isOnline == false)
          ? const NoInternet()
          : Stack(
              children: [
                Scaffold(
                  appBar: AppBar(
                    centerTitle: true,
                    leading: IconButton(
                      onPressed: () {
                        watchTabletSetupServiceProvider!.brandList = null;
                        readPurchaseServiceProvider.setBrandId(null);

                        watchPurchaseServiceProvider.calculateSubTotal(widget.transactionType,
                            discount: double.parse(widget.discountController.text.isEmpty ? 0.0.toString() : widget.discountController.text));
                        readPurchaseServiceProvider.setpurAmount(0.0);
                        widget.isPurchaseReturn
                            ? {
                                readPurchaseServiceProvider.purchaseItemList,
                                Navigator.pushAndRemoveUntil(
                                    context, MaterialPageRoute(builder: (context) => const PurchaseReturnEntries()), (route) => false)
                              }
                            : Navigator.pop(context, [readPurchaseServiceProvider.purchaseItemList, readPurchaseServiceProvider.purchaseSubTotal]);
                      },
                      icon: Icon(
                        Icons.close,
                        color: ColorManager.white,
                      ),
                    ),
                    flexibleSpace: Container(
                      decoration: BoxDecoration(
                        gradient: widget.isPurchaseEdit || widget.isPurchaseReturn
                            ? LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  ColorManager.red,
                                  ColorManager.redAccent,
                                ],
                              )
                            : LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  ColorManager.blue,
                                  ColorManager.blueBright,
                                ],
                              ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            offset: const Offset(0.0, 1.0),
                            color: ColorManager.grey,
                          )
                        ],
                      ),
                    ),
                    title: Text(
                      widget.isPurchaseEdit
                          ? 'Edit Purchase'
                          : widget.isPurchaseReturn
                              ? 'Add Purchase Return'
                              : 'Add Purchase',
                      style: getBoldStyle(
                        fontSize: FontSize.s18,
                        color: ColorManager.white,
                      ),
                    ),
                  ),
                  body: Container(
                    color: ColorManager.blue.withOpacity(.05),
                    child: SafeArea(
                      child: SingleChildScrollView(
                        child: GestureDetector(
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(AppRadius.r10),
                                    bottomRight: Radius.circular(AppRadius.r10),
                                  ),
                                  color: ColorManager.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: ColorManager.blackOpacity38,
                                      blurRadius: 5.0, // soften the shadow
                                      spreadRadius: 1.0, //extend the shadow
                                      offset: const Offset(1.0, .5),
                                    )
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: AppHeight.h10,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: AppWidth.w4, right: AppWidth.w4),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: size.width * .75,
                                            height: size.height * .065,
                                            child: SingleChildScrollView(
                                              padding: EdgeInsets.only(bottom: AppHeight.h4),
                                              child: DropdownButtonFormField<BrandList>(
                                                focusNode: brandFocusNode,
                                                validator: (value) {
                                                  if (value == null) {
                                                    return '*Required';
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h8, horizontal: AppWidth.w10),
                                                  hintText: 'Select brand',
                                                  labelText: 'Select brand',
                                                  labelStyle: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                                  hintStyle: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                                    borderRadius: BorderRadius.circular(AppRadius.r4),
                                                  ),
                                                ),
                                                itemHeight: size.height * 0.08,
                                                isExpanded: true,
                                                icon: const Icon(Icons.arrow_drop_down),
                                                iconEnabledColor: ColorManager.skyBlue,
                                                iconSize: FontSize.s30,
                                                items: watchTabletSetupServiceProvider!.tabletSetupModel.data!.brandList!
                                                    .map(
                                                      (e) => DropdownMenuItem<BrandList>(
                                                        value: e,
                                                        child: Container(
                                                          padding: EdgeInsets.only(left: AppWidth.w10),
                                                          height: size.height * 0.08,
                                                          width: double.infinity,
                                                          child: Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: Text(
                                                              e.brandName.toString(),
                                                              style: getRegularStyle(
                                                                fontSize: FontSize.s16,
                                                                color: ColorManager.black,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                    .toList(),
                                                onChanged: (group) {
                                                  //  fieldFocusChange(context, brandFocusNode, stockFocusNode);
                                                  watchTabletSetupServiceProvider!.brandList = group;
                                                  readPurchaseServiceProvider.setBrandId(group!.brandId);
                                                },
                                                value: watchTabletSetupServiceProvider!.brandList,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              addStockFromPurchase = true;
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => const AddStockPage(),
                                                ),
                                              );
                                            },
                                            customBorder: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            splashColor: ColorManager.grey,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(vertical: AppHeight.h2, horizontal: AppWidth.w2),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.black38, // red as border color
                                                ),
                                                color: ColorManager.white,
                                                borderRadius: BorderRadius.circular(AppRadius.r10),
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: size.height * .035,
                                                    width: size.width * .07,
                                                    decoration: const BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage("assets/images/quickAddItem.png"),
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'Create Stock',
                                                    style: getMediumStyle(fontSize: FontSize.s12, color: ColorManager.black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: AppHeight.h6,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: AppWidth.w4, right: AppWidth.w4),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SingleChildScrollView(
                                            child: SizedBox(
                                              height: size.height * 0.06,
                                              width: size.width * 0.7,
                                              child: TypeAheadFormField<StockDetailList>(
                                                textFieldConfiguration: TextFieldConfiguration(
                                                    focusNode: stockFocusNode,
                                                    style: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                                    controller: stockTextController,
                                                    decoration: InputDecoration(
                                                      contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h8, horizontal: AppWidth.w10),
                                                      suffixIcon: (stockTextController.text == "")
                                                          ? Icon(
                                                              Icons.search_outlined,
                                                              size: FontSize.s20,
                                                            )
                                                          : IconButton(
                                                              icon: const Icon(Icons.close_outlined),
                                                              iconSize: FontSize.s20,
                                                              onPressed: () {
                                                                stockTextController.clear();
                                                                qtyTextController.clear();
                                                                rateTextController.clear();
                                                                saleRateTextController.clear();
                                                                readPurchaseServiceProvider.setpurAmount(0.0);
                                                              },
                                                            ),
                                                      border: OutlineInputBorder(
                                                        borderSide: BorderSide.none,
                                                        borderRadius: BorderRadius.circular(AppRadius.r10),
                                                      ),
                                                      fillColor: ColorManager.white,
                                                      filled: true,
                                                      hintText: 'Stock List',
                                                      labelText: 'Stock List',
                                                      labelStyle: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                                      hintStyle: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(color: ColorManager.blackOpacity38),
                                                        borderRadius: BorderRadius.circular(AppRadius.r5),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(color: ColorManager.blueBright),
                                                        borderRadius: BorderRadius.circular(AppRadius.r5),
                                                      ),
                                                      errorBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(color: ColorManager.red),
                                                        borderRadius: BorderRadius.circular(AppRadius.r10),
                                                      ),
                                                    )),
                                                onSuggestionSelected: (StockDetailList stock) {
                                                  fieldFocusChange(context, stockFocusNode, qtyFocusNode);
                                                  stockTextController.text = stock.stDes.toString();
                                                  saleRateTextController.text = (stock.stSalesRate! > 0) ? stock.stSalesRate.toString() : "";
                                                  rateTextController.text = stock.stCurRate.toString();
                                                  readPurchaseServiceProvider.setPurStockId(int.parse(stock.stId.toString()));
                                                  qtyTextController.text = 1.toString();
                                                  readPurchaseServiceProvider.setpurAmount(
                                                      double.parse((qtyTextController.text.isEmpty) ? '0' : qtyTextController.text) *
                                                          double.parse((rateTextController.text.isEmpty) ? '0' : rateTextController.text));
                                                },
                                                itemBuilder: (context, StockDetailList stock) => ListTile(
                                                  title: Text(
                                                    stock.stDes.toString(),
                                                    style: getMediumStyle(
                                                      fontSize: FontSize.s14,
                                                      color: ColorManager.black,
                                                    ),
                                                  ),
                                                ),
                                                suggestionsCallback:
                                                    readPurchaseServiceProvider.brandId == null ? getStockSuggestion : getStockSuggestionWithBrand,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: size.height * 0.06,
                                            width: size.width * 0.25,
                                            child: TextFormField(
                                              style: getMediumStyle(
                                                fontSize: FontSize.s14,
                                                color: ColorManager.black,
                                              ),
                                              controller: saleRateTextController,
                                              keyboardType: TextInputType.number,
                                              maxLines: null,
                                              decoration: InputDecoration(
                                                contentPadding: const EdgeInsets.all(10),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius: BorderRadius.circular(AppRadius.r5),
                                                ),
                                                fillColor: ColorManager.white,
                                                filled: true,
                                                hintText: 'Sales Rate',
                                                labelText: 'Sales Rate',
                                                labelStyle: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                                hintStyle: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: ColorManager.blackOpacity38),
                                                  borderRadius: BorderRadius.circular(AppRadius.r5),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: ColorManager.blueBright),
                                                  borderRadius: BorderRadius.circular(AppRadius.r5),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: ColorManager.red),
                                                  borderRadius: BorderRadius.circular(AppRadius.r10),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: AppHeight.h10,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: AppWidth.w4, right: AppWidth.w4),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            height: size.height * .06,
                                            width: size.width * 0.3,
                                            child: TextFormField(
                                              textInputAction: TextInputAction.done,
                                              focusNode: qtyFocusNode,
                                              onFieldSubmitted: (value) {
                                                fieldFocusChange(context, qtyFocusNode, rateFocusNode);
                                              },
                                              style: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                              controller: qtyTextController,
                                              keyboardType: TextInputType.number,
                                              maxLines: null,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(left: AppWidth.w10),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius: BorderRadius.circular(AppRadius.r10),
                                                ),
                                                fillColor: ColorManager.white,
                                                filled: true,
                                                hintText: 'Quantity',
                                                labelText: 'Quantity',
                                                labelStyle: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                                hintStyle: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: ColorManager.blackOpacity38),
                                                  borderRadius: BorderRadius.circular(AppRadius.r5),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: ColorManager.blueBright),
                                                  borderRadius: BorderRadius.circular(AppRadius.r5),
                                                ),
                                                errorBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: ColorManager.error),
                                                  borderRadius: BorderRadius.circular(AppRadius.r10),
                                                ),
                                              ),
                                              onChanged: (quantity) {
                                                readPurchaseServiceProvider.setpurAmount(double.parse((quantity.isEmpty) ? '0' : quantity) *
                                                    double.parse((rateTextController.text.isEmpty) ? '0' : rateTextController.text));
                                                // setState(() {});
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: size.height * 0.06,
                                            width: size.width * 0.32,
                                            child: TextFormField(
                                              focusNode: rateFocusNode,
                                              style: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                              controller: rateTextController,
                                              keyboardType: TextInputType.number,
                                              maxLines: null,
                                              onTap: () {
                                                if (rateTextController.text == '0.0' ||
                                                    double.parse(rateTextController.text.toString()) == 0.0 ||
                                                    double.parse(rateTextController.text.toString()) < 0.0) {
                                                  rateTextController.clear();
                                                }
                                              },
                                              onChanged: (rate) {
                                                readPurchaseServiceProvider.setpurAmount(double.parse((rate.isEmpty) ? '0' : rate) *
                                                    double.parse((qtyTextController.text.isEmpty) ? '0' : qtyTextController.text));
                                                // setState(() {});
                                              },
                                              decoration: InputDecoration(
                                                contentPadding: const EdgeInsets.all(10),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius: BorderRadius.circular(10.0),
                                                ),
                                                fillColor: ColorManager.white,
                                                filled: true,
                                                hintText: 'Rate',
                                                labelText: 'Rate',
                                                labelStyle: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                                hintStyle: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: ColorManager.blackOpacity38),
                                                  borderRadius: BorderRadius.circular(AppRadius.r5),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: ColorManager.blueBright),
                                                  borderRadius: BorderRadius.circular(AppRadius.r5),
                                                ),
                                                errorBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: ColorManager.red),
                                                  borderRadius: BorderRadius.circular(AppRadius.r10),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: size.height * 0.0568,
                                            width: size.width * 0.32,
                                            child: InputDecorator(
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(left: AppWidth.w10),
                                                labelText: 'Amount',
                                                labelStyle: getMediumStyle(
                                                  fontSize: FontSize.s16,
                                                  color: ColorManager.black,
                                                ),
                                                hintText: 'Amount',
                                                hintStyle: getMediumStyle(
                                                  fontSize: FontSize.s16,
                                                  color: ColorManager.black,
                                                ),
                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(AppRadius.r5),
                                                  borderSide: BorderSide(
                                                    color: ColorManager.black,
                                                    width: 10.0,
                                                  ),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  (readPurchaseServiceProvider.purAmount.toString().split(".")[1] == "0")
                                                      ? readPurchaseServiceProvider.purAmount!.toString().split(".")[0]
                                                      : readPurchaseServiceProvider.purAmount!.toStringAsFixed(2),
                                                  style: getSemiBoldStyle(
                                                    fontSize: FontSize.s14,
                                                    color: ColorManager.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: AppHeight.h10,
                                    ),
                                  ],
                                ),
                              ),
                              NotificationListener<UserScrollNotification>(
                                onNotification: (notification) {
                                  final ScrollDirection direction = notification.direction;

                                  if (direction == ScrollDirection.reverse) {
                                    readPurchaseServiceProvider.setShowBottomFalse();
                                  } else if (direction == ScrollDirection.forward) {
                                    readPurchaseServiceProvider.setShowBottomTrue();
                                  }

                                  return true;
                                },
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          (readPurchaseServiceProvider.purchaseItemList.isEmpty)
                                              ? Container()
                                              : Padding(
                                                  padding: EdgeInsets.all(AppHeight.h4),
                                                  child: Text(
                                                    'Purchase Items: ',
                                                    style: getBoldStyle(
                                                      fontSize: FontSize.s16,
                                                      color: ColorManager.black,
                                                    ),
                                                  ),
                                                ),
                                          ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: (stockTextController.text.isNotEmpty &&
                                                      rateTextController.text.isNotEmpty &&
                                                      qtyTextController.text.isNotEmpty)
                                                  ? Colors.green
                                                  : Colors.green.shade200,
                                            ),
                                            onPressed: () {
                                              if (stockTextController.text.isNotEmpty &&
                                                  rateTextController.text.isNotEmpty &&
                                                  qtyTextController.text.isNotEmpty) {
                                                _onAddPurchase(readPurchaseServiceProvider, readPurchaseBillServiceProvider);

                                                FocusScope.of(context).requestFocus(FocusNode());
                                              }
                                            },
                                            icon: const Icon(Icons.add),
                                            label: Text(
                                              watchPurchaseServiceProvider.isAddPurchase ? 'Add' : 'Update',
                                              style: getMediumStyle(
                                                fontSize: FontSize.s14,
                                                color: ColorManager.white,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: size.height * 0.7,
                                        child: (readPurchaseServiceProvider.purchaseItemList.isEmpty)
                                            ? Container()
                                            : ListView.builder(
                                                itemCount: readPurchaseServiceProvider.purchaseItemList.length,
                                                itemBuilder: (context, index) {
                                                  PurchaseItemModel purchase = readPurchaseServiceProvider.purchaseItemList[index];
                                                  return Card(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(5.0),
                                                    ),
                                                    elevation: 3,
                                                    margin: EdgeInsets.all(AppHeight.h4),
                                                    child: ListTile(
                                                      leading: IconButton(
                                                        onPressed: () {
                                                          widget.isPurchaseEdit
                                                              ? {
                                                                  showDialog<String>(
                                                                    context: context,
                                                                    builder: (BuildContext context) => AlertDialog(
                                                                      title: const Text('Remove Item'),
                                                                      content: const Text('Are you sure you want to remove the item?'),
                                                                      actions: <Widget>[
                                                                        TextButton(
                                                                          onPressed: () {
                                                                            readPurchaseServiceProvider.removePurchaseItem(purchase);
                                                                            onDeleteItem(readDeletePurchaseServiceProvider, purchase.purDId);
                                                                            refresh();
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child: const Text('Yes'),
                                                                        ),
                                                                        TextButton(
                                                                          onPressed: () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child: const Text('No'),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                }
                                                              : {readPurchaseServiceProvider.removePurchaseItem(purchase)};
                                                        },
                                                        icon: Icon(
                                                          Icons.close,
                                                          size: FontSize.s25,
                                                          color: ColorManager.error,
                                                        ),
                                                      ),
                                                      title: Text(
                                                        purchase.purchaseStkName.toString(),
                                                        style: getSemiBoldStyle(
                                                          fontSize: FontSize.s15,
                                                          color: ColorManager.black,
                                                        ),
                                                      ),
                                                      subtitle: Row(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                purchase.purDQty.toString(),
                                                                style: getMediumStyle(
                                                                  fontSize: FontSize.s13,
                                                                  color: ColorManager.black,
                                                                ),
                                                              ),
                                                              Text(
                                                                ' x ',
                                                                style: getMediumStyle(
                                                                  fontSize: FontSize.s13,
                                                                  color: ColorManager.black,
                                                                ),
                                                              ),
                                                              Text(
                                                                purchase.purDRate.toString(),
                                                                style: getMediumStyle(
                                                                  fontSize: FontSize.s13,
                                                                  color: ColorManager.black,
                                                                ),
                                                              ),
                                                              Text(
                                                                ' = ',
                                                                style: getMediumStyle(
                                                                  fontSize: FontSize.s10,
                                                                  color: ColorManager.black,
                                                                ),
                                                              ),
                                                              Text(
                                                                purchase.stkTotal.toString(),
                                                                style: getMediumStyle(
                                                                  fontSize: FontSize.s13,
                                                                  color: ColorManager.blue,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      trailing: IconButton(
                                                        onPressed: () {
                                                          readPurchaseServiceProvider.toggleIsAddPurchase(false);
                                                          readPurchaseServiceProvider.setOldPurchaseItemIndex(index);
                                                          stockTextController.text = purchase.purchaseStkName;
                                                          qtyTextController.text = purchase.purDQty.toString();
                                                          rateTextController.text = purchase.purDRate.toString();
                                                          saleRateTextController.text =
                                                              (purchase.purDSalesRate == null) ? '0.0' : purchase.purDSalesRate.toString();
                                                          readPurchaseServiceProvider.setpurAmount(purchase.stkTotal);
                                                          if (widget.isPurchaseReturn) {
                                                            readPurchaseServiceProvider.setPurStockId(purchase.purDStkId);
                                                          }
                                                        },
                                                        icon: Icon(
                                                          Icons.edit_note,
                                                          size: FontSize.s30,
                                                          color: ColorManager.blueBright,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  bottomSheet: readPurchaseServiceProvider.showBottom
                      ? Container(
                          height: size.height * .08,
                          width: size.width,
                          decoration: BoxDecoration(
                            color: ColorManager.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5.0, // soften the shadow
                                spreadRadius: 1.0, //extend the shadow
                                offset: Offset(1.0, .5),
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (readPurchaseServiceProvider.purchaseItemList.isNotEmpty) {
                                      if (widget.isPurchaseReturn) {
                                        readPurchaseServiceProvider.calculateTotalReturn(double.parse(widget.discountController.text));
                                      } else {
                                        readPurchaseServiceProvider.calculateSubTotal(widget.transactionType);
                                      }

                                      widget.isPurchaseReturn
                                          ? {
                                              readPurchaseServiceProvider.purchaseItemList,
                                              Navigator.pushAndRemoveUntil(
                                                  context, MaterialPageRoute(builder: (context) => const PurchaseReturnEntries()), (route) => false)
                                            }
                                          : Navigator.pop(
                                              context, [readPurchaseServiceProvider.purchaseItemList, readPurchaseServiceProvider.purchaseSubTotal]);
                                    } else {
                                      Fluttertoast.cancel();
                                      Fluttertoast.showToast(
                                        msg: 'Cannot Save Empty Data',
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: ColorManager.error,
                                      );
                                    }
                                  },
                                  style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(const Size(180, 50)),
                                    maximumSize: MaterialStateProperty.all(const Size(200, 60)),
                                    backgroundColor: MaterialStateProperty.all(
                                        watchPurchaseServiceProvider.purchaseItemList.isEmpty ? ColorManager.greenInActive : ColorManager.green),
                                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: AppWidth.w10, vertical: AppHeight.h1)),
                                    textStyle: MaterialStateProperty.all(getMediumStyle(fontSize: FontSize.s14, color: ColorManager.white)),
                                  ),
                                  child: Text(
                                    'Confirm',
                                    style: getBoldStyle(fontSize: FontSize.s16, color: ColorManager.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SizedBox(width: size.width, height: size.height * .01),
                ),
                if (readPurchaseServiceProvider.loading)
                  Container(
                    alignment: Alignment.center,
                    color: Colors.white70,
                    child: const SpinKitCubeGrid(
                      color: Colors.indigoAccent,
                      size: 70,
                    ),
                  )
              ],
            );
    });
  }

  static void fieldFocusChange(BuildContext context, FocusNode currentFocusNode, FocusNode nextFocusNode) {
    currentFocusNode.unfocus();
    FocusScope.of(context).requestFocus(nextFocusNode);
  }

  List<StockDetailList> getStockSuggestionWithBrand(String query) => List.of(watchGetStockListProvider!.getStockListModel.data!)
          .where((element) => element.stBrandId == context.read<PurchaseServiceProvider>().brandId)
          .where((StockDetailList stock) {
        final stockNameLower = stock.stDes!.toLowerCase();
        final queryLower = query.toLowerCase();
        return stockNameLower.contains(queryLower);
      }).toList();
  List<StockDetailList> getStockSuggestion(String query) =>
      List.of(watchGetStockListProvider!.getStockListModel.data!).where((StockDetailList stock) {
        final stockNameLower = stock.stDes!.toLowerCase();
        final queryLower = query.toLowerCase();
        return stockNameLower.contains(queryLower);
      }).toList();

  _onAddPurchase(PurchaseServiceProvider readPurchaseServiceProvider, PurchaseByBillNumberServiceProvider readPurchaseBillServiceProvider) {
    if (readPurchaseServiceProvider.purStockId == null) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: 'Stock Not Available',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ColorManager.error,
      );
    } else {
      PurchaseItemModel setpurchaseItemModel = PurchaseItemModel(
        // purType: int.parse(tranTypeId.toString()),
        purDId: 0,
        purDStkId: readPurchaseServiceProvider.purStockId!,
        purchaseStkName: stockTextController.text,
        purDQty: double.parse(qtyTextController.text),
        purDRate: double.parse(rateTextController.text),
        stkTotal: readPurchaseServiceProvider.purAmount!,
        purDSalesRate: (saleRateTextController.text.isEmpty) ? 0.0 : double.parse(saleRateTextController.text),
      );

      if (readPurchaseServiceProvider.isAddPurchase) {
        readPurchaseServiceProvider.setLoadingTrue();
        if (readPurchaseServiceProvider.checkDuplicate(setpurchaseItemModel)) {
          readPurchaseServiceProvider.billName = null;
          readPurchaseServiceProvider.setBrandId(null);

          Fluttertoast.showToast(
            msg: 'Item Already Added',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: ColorManager.error,
          );
        } else {
          // log(jsonEncode(setpurchaseItemModel));
          readPurchaseServiceProvider.setPurchaseItem(setpurchaseItemModel);
          watchTabletSetupServiceProvider!.brandList = null;
          readPurchaseServiceProvider.setBrandId(null);

          Fluttertoast.showToast(
            msg: 'Item Added',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: ColorManager.green,
          );
        }
        readPurchaseServiceProvider.setLoadingFalse();
      } else {
        readPurchaseServiceProvider.editPurchaseItem(setpurchaseItemModel);
        Fluttertoast.showToast(
          msg: 'Item Updated',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: ColorManager.amber,
        );
      }
    }
    stockTextController.clear();
    qtyTextController.clear();
    rateTextController.clear();
    saleRateTextController.clear();
    readPurchaseServiceProvider.setpurAmount(0.0);
  }

  onDeleteItem(DeletePurchaseServiceProvider deletePurchaseServiceProvider, int purDId) async {
    var deleteItem = await deletePurchaseServiceProvider.deletePurchaseItem(purDId);

    if (deleteItem != null) {
      if (deleteItem["success"] == true) {
        Fluttertoast.showToast(
          msg: 'Item Deleted',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: ColorManager.green,
        );
        if (!mounted) return;
      } else {
        Fluttertoast.cancel();
        return Fluttertoast.showToast(
          msg: 'Error occured',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: ColorManager.error,
        );
      }
    }
  }
}
