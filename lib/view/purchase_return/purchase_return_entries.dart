import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/homepage/home_screen.dart';
import 'package:webshop/view/purchase/model/purchase_by_id_model.dart';
import 'package:webshop/view/purchase/model/purchase_item_model.dart';
import 'package:webshop/view/purchase/purchase_page.dart';
import 'package:webshop/view/purchase/screens/add_purchase_page.dart';
import 'package:webshop/view/purchase/services/purchase_by_id_service.dart';
import 'package:webshop/view/purchase/services/purchase_service.dart';
import 'package:webshop/view/purchase/services/update_purchase_provider.dart';
import 'package:webshop/view/purchase_return/models/purchase_by_bill_model.dart';
import 'package:webshop/view/purchase_return/provider/purchase_bill_number_provider.dart';
import 'package:webshop/view/sales/widgets/return_item_header.dart';
import 'package:webshop/widgets/no_data_dialog.dart';

class PurchaseReturnEntries extends StatefulWidget {
  const PurchaseReturnEntries({super.key});

  @override
  State<PurchaseReturnEntries> createState() => _PurchaseReturnEntriesState();
}

class _PurchaseReturnEntriesState extends State<PurchaseReturnEntries> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    TabletSetupServiceProvider watchTabletSetupServiceProvider = context.watch<TabletSetupServiceProvider>();
    PurchaseByBillNumberServiceProvider watchPurchaseBillServiceProvider = context.watch<PurchaseByBillNumberServiceProvider>();
    PurchaseServiceProvider watchPurchaseServiceProvider = context.watch<PurchaseServiceProvider>();
    PurchaseByIdServiceProvider watchPurchaseByIdServiceProvider = context.watch<PurchaseByIdServiceProvider>();

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                ColorManager.red,
                ColorManager.redAccent,
              ],
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                offset: const Offset(0.0, 1.0),
                color: ColorManager.grey,
              ),
            ],
          ),
        ),
        centerTitle: true,
        elevation: 1,
        backgroundColor: ColorManager.white,
        title: Text(
          'Purchase Return Entries',
          style: getMediumStyle(fontSize: FontSize.s18, color: ColorManager.white),
        ),
        leading: IconButton(
          onPressed: () {
            watchPurchaseBillServiceProvider.billNoTextEditingController.clear();
            watchPurchaseBillServiceProvider.paymentTextEditingController.clear();
            watchPurchaseBillServiceProvider.vatTextEditingController.clear();
            watchPurchaseBillServiceProvider.discountTextEditingController.clear();

            watchTabletSetupServiceProvider.supplierList = null;

            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
                (route) => false);
          },
          icon: Icon(
            Icons.arrow_back,
            color: ColorManager.white,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextButton(
              onPressed: () {
                if (watchPurchaseBillServiceProvider.billNoTextEditingController.text.isEmpty) {
                  Fluttertoast.cancel();
                  Fluttertoast.showToast(
                    msg: 'Bill No is Empty',
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: ColorManager.error,
                  );
                } else {
                  createPurchaseReturn(
                      watchPurchaseServiceProvider, watchPurchaseByIdServiceProvider.purchaseByIdModel.data!, watchPurchaseBillServiceProvider);
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(ColorManager.blueBright),
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: AppWidth.w10, vertical: AppHeight.h1)),
                textStyle: MaterialStateProperty.all(getMediumStyle(fontSize: FontSize.s14, color: ColorManager.white)),
              ),
              child: Text(
                'Save',
                style: getMediumStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.white,
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: size.height * 0.10,
        ),
        child: SizedBox(
          height: AppHeight.h40,
          width: AppWidth.w40,
          child: FloatingActionButton(
            onPressed: (watchPurchaseServiceProvider.purchaseItemList.isEmpty)
                ? () {
                    Fluttertoast.cancel();
                    Fluttertoast.showToast(msg: 'ItemList is Empty', gravity: ToastGravity.BOTTOM, backgroundColor: ColorManager.red);
                  }
                : () {
                    watchPurchaseServiceProvider.purchaseSubTotal = 0.0;
                    watchPurchaseServiceProvider.purchaseNonTaxableAmount = 0.0;
                    watchPurchaseServiceProvider.purchaseTaxableAmount = 0.0;
                    watchPurchaseServiceProvider.purchaseVatAmount = 0.0;
                    watchPurchaseServiceProvider.purchaseTotalAmount = 0.0;
                    watchPurchaseServiceProvider.discountController.text = '0.0';

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddPurchasePage(
                            transactionType: int.parse(watchPurchaseBillServiceProvider.purchaseByBillModel.data!.purMode.toString()),
                            discountController: watchPurchaseBillServiceProvider.discountTextEditingController,
                            isPurchaseEdit: false,
                            isPurchaseReturn: true,
                          ),
                        ),
                        (route) => false);
                  },
            backgroundColor: (watchPurchaseServiceProvider.purchaseItemList.isEmpty) ? ColorManager.grey2 : ColorManager.blueBright,
            elevation: 0,
            child: Icon(
              Icons.add,
              size: FontSize.s30,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Consumer<ConnectivityProvider>(
            builder: (context, connectivity, child) {
              return (connectivity.isOnline == false)
                  ? const NoInternet()
                  : Padding(
                      padding: EdgeInsets.all(AppHeight.h4),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: size.height * 0.065,
                                width: size.width * .2,
                                child: TextFormField(
                                  controller: watchPurchaseBillServiceProvider.billNoTextEditingController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h10, horizontal: AppWidth.w13),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1.5, color: ColorManager.blue),
                                      borderRadius: BorderRadius.circular(AppRadius.r5),
                                    ),
                                    labelText: 'Bill No',
                                    hintText: 'Bill No',
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  watchPurchaseServiceProvider.purchaseItemList = [];
                                  watchPurchaseServiceProvider.tempPurchaseItemList = [];
                                  watchPurchaseServiceProvider.duplicatePurchaseItemList = [];
                                  if (watchPurchaseBillServiceProvider.billNoTextEditingController.text.isEmpty) {
                                    Fluttertoast.cancel();
                                    Fluttertoast.showToast(
                                      msg: "Bill No Cannot be Empty",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: ColorManager.error,
                                    );
                                  } else {
                                    PurchaseByBillModel response = await context
                                        .read<PurchaseByBillNumberServiceProvider>()
                                        .getPurchaseByBillNo(int.parse(watchPurchaseBillServiceProvider.billNoTextEditingController.text.toString()));

                                    if (response.data != null) {
                                      if (!mounted) return;
                                      PurchaseByIdModel purchaseResponse = await context
                                          .read<PurchaseByIdServiceProvider>()
                                          .getPurchaseById(int.parse(response.data!.purId.toString()));

                                      if (purchaseResponse.data != null) {
                                        watchPurchaseServiceProvider.addToPurchaseModelList(purchaseResponse.data!.purchaseDetailDtoList);

                                        watchTabletSetupServiceProvider.selectSupplier(int.parse(purchaseResponse.data!.purSupId.toString()));

                                        watchPurchaseBillServiceProvider.discountTextEditingController.text =
                                            watchPurchaseBillServiceProvider.purchaseByBillModel.data!.purDiscAmount.toString();

                                        watchPurchaseServiceProvider
                                            .calculateTotalReturn(double.parse(watchPurchaseBillServiceProvider.discountTextEditingController.text));

                                        for (var i = 0; i < paymentType.length; i++) {
                                          if (purchaseResponse.data!.purCashCredit.toString() == paymentType[i]['id']) {
                                            watchPurchaseBillServiceProvider.paymentTextEditingController.text = paymentType[i]['name'];
                                          }
                                          if (purchaseResponse.data!.purMode.toString() == tranMode[i]['id']) {
                                            watchPurchaseBillServiceProvider.vatTextEditingController.text = tranMode[i]['name'];
                                          }
                                        }
                                      }
                                    } else {
                                      Fluttertoast.cancel();
                                      Fluttertoast.showToast(
                                        msg: "Bill No. Not Found",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: ColorManager.error,
                                      );
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorManager.blueBright,
                                ),
                                child: Text(
                                  'Search',
                                  style: getBoldStyle(
                                    fontSize: FontSize.s14,
                                    color: ColorManager.white,
                                  ),
                                ),
                              ),
                              SingleChildScrollView(
                                child: SizedBox(
                                  width: size.width * 0.5,
                                  height: size.height * 0.065,
                                  child: DropdownButtonFormField<SupplierList>(
                                    decoration: InputDecoration(
                                      label: Text(
                                        'Supplier',
                                        style: getRegularStyle(
                                          fontSize: FontSize.s12,
                                          color: ColorManager.blackOpacity54,
                                        ),
                                      ),
                                      hintText: 'Select Supplier',
                                      hintStyle: getSemiBoldStyle(
                                        fontSize: FontSize.s10,
                                        color: ColorManager.blackOpacity54,
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                        borderRadius: BorderRadius.circular(AppRadius.r10),
                                      ),
                                    ),
                                    isExpanded: true,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    iconEnabledColor: ColorManager.skyBlue,
                                    iconSize: FontSize.s15,
                                    items: watchTabletSetupServiceProvider.tabletSetupModel.data!.supplierList!.map((supplier) {
                                      return DropdownMenuItem<SupplierList>(
                                        value: supplier,
                                        child: Container(
                                          margin: EdgeInsets.only(left: AppWidth.w1),
                                          padding: EdgeInsets.only(left: AppWidth.w10),
                                          height: size.height * 0.08,
                                          width: double.infinity,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              supplier.supName.toString(),
                                              style: getRegularStyle(
                                                fontSize: FontSize.s10,
                                                color: ColorManager.blackOpacity54,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (supplier) {
                                      watchTabletSetupServiceProvider.supplierList = supplier;
                                    },
                                    value: watchTabletSetupServiceProvider.supplierList,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: AppHeight.h4, top: AppHeight.h4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: size.width * .45,
                                  child: TextFormField(
                                    controller: watchPurchaseBillServiceProvider.paymentTextEditingController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h4, horizontal: AppWidth.w10),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(width: 1.5, color: Colors.blue),
                                        borderRadius: BorderRadius.circular(AppRadius.r10),
                                      ),
                                      labelText: 'Payment',
                                      hintText: 'Payment',
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: size.width * .5,
                                  child: TextFormField(
                                    controller: watchPurchaseBillServiceProvider.vatTextEditingController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h4, horizontal: AppWidth.w10),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(width: 1.5, color: Colors.blue),
                                        borderRadius: BorderRadius.circular(AppRadius.r10),
                                      ),
                                      labelText: 'Vat/NonVat',
                                      hintText: 'Vat/NonVat',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: AppHeight.h6,
                          ),
                          Divider(
                            color: ColorManager.grey2,
                            thickness: AppHeight.h1,
                          ),
                          (watchPurchaseServiceProvider.purchaseItemList.isEmpty)
                              ? const SizedBox()
                              : Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Purchase Return:',
                                    style: getBoldStyle(
                                      fontSize: FontSize.s16,
                                      color: ColorManager.black,
                                    ),
                                  ),
                                ),
                          (watchPurchaseServiceProvider.purchaseItemList.isEmpty)
                              ? SizedBox(
                                  height: size.height * 0.65,
                                  width: size.width,
                                  child: const NoDataErrorBox(),
                                )
                              : Column(
                                  children: [
                                    const ReturnItemHeaderWidget(),
                                    Container(
                                      color: ColorManager.grey.withOpacity(.05),
                                      width: size.width,
                                      height: size.height * 0.55,
                                      child: ListView.separated(
                                        itemCount: watchPurchaseServiceProvider.purchaseItemList.length,
                                        separatorBuilder: (BuildContext context, int index) {
                                          return Divider(
                                            color: ColorManager.black,
                                          );
                                        },
                                        itemBuilder: (context, index) {
                                          PurchaseItemModel itemData = watchPurchaseServiceProvider.purchaseItemList[index];

                                          watchPurchaseServiceProvider.calculateTotalReturn(
                                              double.parse(watchPurchaseBillServiceProvider.discountTextEditingController.text));

                                          return SizedBox(
                                            height: size.height * 0.05,
                                            width: size.width,
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: size.width * 0.35,
                                                  child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(
                                                      "${itemData.purchaseStkName} (${itemData.purDQty})",
                                                      style: getRegularStyle(
                                                        color: ColorManager.black,
                                                        fontSize: FontSize.s12,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: size.width * 0.1,
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      itemData.purDQty.toString(),
                                                      style: getRegularStyle(
                                                        color: ColorManager.black,
                                                        fontSize: FontSize.s12,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: size.width * 0.2,
                                                  child: Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Text(
                                                      itemData.purDRate.toString(),
                                                      style: getRegularStyle(
                                                        color: ColorManager.black,
                                                        fontSize: FontSize.s12,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: size.width * 0.3,
                                                  child: Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Text(
                                                      itemData.stkTotal.toString(),
                                                      style: getRegularStyle(
                                                        color: ColorManager.black,
                                                        fontSize: FontSize.s12,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    );
            },
          ),
        ),
      ),
      bottomSheet: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppRadius.r10),
              topRight: Radius.circular(AppRadius.r10),
            ),
            color: ColorManager.white,
            boxShadow: [
              BoxShadow(
                color: ColorManager.blackOpacity38,
                blurRadius: 25.0, // soften the shadow
                spreadRadius: 5.0, //extend the shadow
                offset: const Offset(
                  15.0, // Move to right 10  horizontally
                  15.0, // Move to bottom 10 Vertically
                ),
              ),
            ],
          ),
          child: Container(
            width: size.width,
            height: size.height * .1,
            padding: EdgeInsets.symmetric(vertical: AppHeight.h8, horizontal: AppWidth.w8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Subtotal  ',
                      style: getRegularStyle(
                        fontSize: FontSize.s14,
                        color: ColorManager.black,
                      ),
                    ),
                    Text(
                      'Discount ',
                      style: getRegularStyle(
                        fontSize: FontSize.s14,
                        color: ColorManager.black,
                      ),
                    ),
                    Text(
                      'Total  ',
                      style: getRegularStyle(
                        fontSize: FontSize.s14,
                        color: ColorManager.black,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      watchPurchaseServiceProvider.returnSubTotal.toStringAsFixed(2),
                      style: getRegularStyle(
                        fontSize: FontSize.s12,
                        color: ColorManager.black,
                      ),
                    ),
                    SizedBox(
                      width: size.width * .2,
                      height: size.height * .03,
                      child: TextField(
                        textAlign: TextAlign.end,
                        keyboardType: TextInputType.number,
                        controller: watchPurchaseBillServiceProvider.discountTextEditingController,
                        onChanged: (value) {
                          watchPurchaseServiceProvider.calculateDiscount(value);
                        },
                        onTap: () {
                          if (watchPurchaseBillServiceProvider.discountTextEditingController.text == '0.0') {
                            watchPurchaseBillServiceProvider.discountTextEditingController.clear();
                          }
                        },
                        style: getRegularStyle(
                          fontSize: FontSize.s12,
                          color: ColorManager.grey2,
                        ),
                        decoration: InputDecoration(
                          // hintText: '0.0',
                          contentPadding: EdgeInsets.zero,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: ColorManager.blackOpacity38, width: 1.0),
                            borderRadius: BorderRadius.all(Radius.circular(AppRadius.r5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: ColorManager.blackOpacity38, width: 2.0),
                            borderRadius: BorderRadius.all(Radius.circular(AppRadius.r5)),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      watchPurchaseServiceProvider.returnTotal.toStringAsFixed(2),
                      style: getRegularStyle(
                        fontSize: FontSize.s12,
                        color: ColorManager.black,
                      ),
                    ),
                  ],
                ),
                VerticalDivider(thickness: AppWidth.w1, color: ColorManager.black),
                SizedBox(
                  width: size.width * .25,
                  height: size.height * .14,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {},
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(ColorManager.blueBright),
                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: AppWidth.w10, vertical: AppHeight.h1)),
                          textStyle: MaterialStateProperty.all(getMediumStyle(fontSize: FontSize.s14, color: ColorManager.white)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.width * .05),
                          child: Text(
                            'Save',
                            style: getMediumStyle(fontSize: FontSize.s15, color: ColorManager.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  createPurchaseReturn(PurchaseServiceProvider watchPurchaseServiceProvider, PurchaseId billPurchase,
      PurchaseByBillNumberServiceProvider watchPurchaseBillServiceProvider) async {
    if (watchPurchaseServiceProvider.purchaseItemList.isNotEmpty) {
      PurchaseDetails purchaseDetails = PurchaseDetails(
        purId: billPurchase.purId ?? 0,
        purType: 2,
        purDate: billPurchase.purDate.toString(),
        purSupId: billPurchase.purSupId,
        purMode: billPurchase.purMode,
        purCashCredit: billPurchase.purCashCredit!.toInt(),
        purInsertedDate: billPurchase.purInsertedDate,
        purInsertedBy: billPurchase.purInsertedBy,
        purSubAmount: watchPurchaseServiceProvider.returnSubTotal,
        purDiscAmount: double.parse(watchPurchaseBillServiceProvider.discountTextEditingController.text),
        purTaxableAmount: watchPurchaseServiceProvider.returnSubTotal,
        purNonTaxableAmount: 0.0,
        purVatAmount: 0.0,
        purTotalAmount: watchPurchaseServiceProvider.returnTotal,
        purInActive: false,
        supplier: billPurchase.supplier,
        purBillNo: billPurchase.purBillNo,
      );

      CreatePurchase createPurchase = CreatePurchase(
        purchase: purchaseDetails,
        purchasedetail: watchPurchaseServiceProvider.purchaseItemList,
      );
      var response = await context.read<UpdatePurchaseServiceProvider>().updatePurchase(createPurchase);

      if (response['responseType'] == 6) {
        watchPurchaseServiceProvider.purchaseItemList.clear();
        watchPurchaseServiceProvider.duplicatePurchaseItemList.clear();
        Fluttertoast.cancel();
        Fluttertoast.showToast(
          msg: 'Purchase Return Successful',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: ColorManager.green,
        );

        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const PurchasePage(
                isPurchaseReturn: true,
              ),
            ),
            (route) => false);
      } else {
        Fluttertoast.cancel();
        Fluttertoast.showToast(
          msg: 'Purchase Return Failed \n ${response['message']}',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: ColorManager.error,
        );
      }
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: 'Return Item is Empty',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ColorManager.error,
      );
    }
  }
}
