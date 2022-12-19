import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/homepage/home_screen.dart';
import 'package:webshop/view/purchase/model/purchase_by_id_model.dart';
import 'package:webshop/view/purchase/model/purchase_item_model.dart';
import 'package:webshop/view/purchase/purchase_page.dart';
import 'package:webshop/view/purchase/services/purchase_by_id_service.dart';
import 'package:webshop/view/supplier/screens/add_supplier_screen.dart';
import 'package:webshop/widgets/entries_title_heading.dart';
import 'screens/add_purchase_page.dart';
import 'services/purchase_service.dart';
import 'services/update_purchase_provider.dart';

class PurchaseEntries extends StatefulWidget {
  final PurchaseDetails? purchaseDetails;

  final bool fromPurchase;
  const PurchaseEntries({super.key, this.purchaseDetails, required this.fromPurchase});

  @override
  State<PurchaseEntries> createState() => _PurchaseEntriesState();
}

class _PurchaseEntriesState extends State<PurchaseEntries> {
  final formKey = GlobalKey<FormState>();
  PurchaseByIdModel purchaseByIdModel = PurchaseByIdModel();
  FocusNode customerFocusNode = FocusNode();
  bool showBottomSheet = true;
  bool purchaseEdit = false;

  TextEditingController billController = TextEditingController();
  TabletSetupServiceProvider? watchTabletSetupServiceProvider;
  PurchaseServiceProvider? readPurchaseServiceProvider;
  PurchaseByIdServiceProvider? readPurchaseByIdServiceProvider;
  UpdatePurchaseServiceProvider? readUpdatePurchaseServiceProvider;
  PurchaseServiceProvider? watchPurchaseServiceProvider;

  @override
  void initState() {
    readPurchaseServiceProvider = context.read<PurchaseServiceProvider>();
    super.initState();

    if (widget.purchaseDetails != null) {
      refresh();
    } else {
      readPurchaseServiceProvider!.transactiontype = tranMode[1]['id'];
      readPurchaseServiceProvider!.payType = paymentType[1]['id'];

      readPurchaseServiceProvider!.purId = null;
      readPurchaseServiceProvider!.supId = null;
      readPurchaseServiceProvider!.billName = null;

      readPurchaseServiceProvider!.supplierNameController.clear();
      readPurchaseServiceProvider!.discountController.clear();

      readPurchaseServiceProvider!.purchaseSubTotal = 0.0;
      readPurchaseServiceProvider!.purchaseTaxableAmount = 0.0;
      readPurchaseServiceProvider!.purchaseNonTaxableAmount = 0.0;
      readPurchaseServiceProvider!.purchaseVatAmount = 0.0;
      readPurchaseServiceProvider!.purchaseTotalAmount = 0.0;
    }
  }

  @override
  void dispose() {
    purchaseEdit = false;
    super.dispose();
  }

  Future<void> refresh() async {
    readPurchaseByIdServiceProvider = context.read<PurchaseByIdServiceProvider>();
    await readPurchaseByIdServiceProvider!.getPurchaseById(widget.purchaseDetails!.purId!);
    var purchaseDetails = readPurchaseByIdServiceProvider!.purchaseByIdModel.data!;
    readPurchaseServiceProvider!.purId = readPurchaseByIdServiceProvider!.purchaseByIdModel.data!.purId;
    readPurchaseServiceProvider!.supplierNameController.text = purchaseDetails.supplier.toString();
    readPurchaseServiceProvider!.billName = purchaseDetails.purBillNo ?? '';
    billController.text = purchaseDetails.purBillNo ?? '';
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
    purchaseEdit = true;

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

    watchPurchaseServiceProvider = context.watch<PurchaseServiceProvider>();
    readUpdatePurchaseServiceProvider = context.read<UpdatePurchaseServiceProvider>();

    readPurchaseServiceProvider!.purchaseDate = readPurchaseServiceProvider!.selectedFromDate.toString().split(" ")[0].toString();

    Widget labelStartDate = InkWell(
      onTap: () {
        selectFromDate();
      },
      child: SizedBox(
        height: size.height * 0.06,
        width: size.width * 0.3,
        child: InputDecorator(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: AppWidth.w10),
            labelText: 'Date',
            labelStyle: getMediumStyle(
              fontSize: FontSize.s16,
              color: ColorManager.black,
            ),
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
              readPurchaseServiceProvider!.purchaseDate.toString(),
              style: getRegularStyle(
                fontSize: FontSize.s14,
                color: ColorManager.black,
              ),
            ),
          ),
        ),
      ),
    );
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivity, child) {
        return (connectivity.isOnline == false)
            ? const NoInternet()
            : Stack(
                children: [
                  Scaffold(
                    floatingActionButton: Consumer<ConnectivityProvider>(builder: (context, connectivity, child) {
                      return (connectivity.isOnline == false)
                          ? Container()
                          : Padding(
                              padding: EdgeInsets.only(
                                bottom: size.height * 0.10,
                              ),
                              child: SizedBox(
                                height: AppHeight.h40,
                                width: AppWidth.w40,
                                child: FloatingActionButton(
                                  onPressed: () {
                                    watchTabletSetupServiceProvider!.brandList = null;
                                    readPurchaseServiceProvider!.setpurAmount(0.0);
                                    readPurchaseServiceProvider!.isAddPurchase = true;
                                    readPurchaseServiceProvider!.toggleIsAddPurchase(true);
                                    readPurchaseServiceProvider!.purchaseSubTotal = 0.0;
                                    readPurchaseServiceProvider!.purchaseSubTotalAfterDiscount = 0.0;
                                    readPurchaseServiceProvider!.purchaseNonTaxableAmount = 0.0;
                                    readPurchaseServiceProvider!.purchaseTaxableAmount = 0.0;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddPurchasePage(
                                          purId: widget.purchaseDetails?.purId,
                                          transactionType: int.parse(readPurchaseServiceProvider!.transactiontype.toString()),
                                          discountController: readPurchaseServiceProvider!.discountController,
                                          isPurchaseEdit: purchaseEdit,
                                          isPurchaseReturn: false,
                                        ),
                                        fullscreenDialog: true,
                                      ),
                                    );
                                  },
                                  backgroundColor: ColorManager.blueBright,
                                  elevation: 0,
                                  child: Icon(
                                    Icons.add,
                                    size: FontSize.s30,
                                  ),
                                ),
                              ),
                            );
                    }),
                    appBar: AppBar(
                      centerTitle: true,
                      elevation: 1,
                      flexibleSpace: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              ColorManager.blue,
                              ColorManager.blueBright,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: AppRadius.r4,
                              offset: const Offset(0.0, 1.0),
                              color: ColorManager.grey,
                            )
                          ],
                        ),
                      ),
                      title: Text(
                        'Purchase Entries',
                        style: getMediumStyle(
                          fontSize: FontSize.s18,
                          color: ColorManager.white,
                        ),
                      ),
                      leading: IconButton(
                        onPressed: () {
                          readPurchaseServiceProvider!.purchaseItemList = [];
                          readPurchaseServiceProvider!.tempPurchaseItemList = [];
                          readPurchaseServiceProvider!.duplicatePurchaseItemList = [];
                          readPurchaseServiceProvider!.purchaseSubTotal = 0.0;
                          readPurchaseServiceProvider!.purchaseNonTaxableAmount = 0.0;
                          readPurchaseServiceProvider!.purchaseTaxableAmount = 0.0;
                          readPurchaseServiceProvider!.purchaseVatAmount = 0.0;
                          readPurchaseServiceProvider!.purchaseTotalAmount = 0.0;
                          readPurchaseServiceProvider!.discountController.text = '0.0';

                          if (widget.fromPurchase) {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const PurchasePage(
                                    isPurchaseReturn: false,
                                  ),
                                ),
                                (route) => false);
                          } else {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                                (route) => false);
                          }
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: ColorManager.white,
                        ),
                      ),
                    ),
                    body: Consumer<ConnectivityProvider>(builder: (context, connectivity, child) {
                      return (connectivity.isOnline == false)
                          ? const NoInternet()
                          : GestureDetector(
                              onTap: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                                showBottomSheet = true;
                              },
                              child: Container(
                                color: ColorManager.blue.withOpacity(.05),
                                child: Consumer<PurchaseServiceProvider>(
                                  builder: (context, purchaseServiceProvider, child) {
                                    return Column(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Form(
                                                key: formKey,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    FocusScope.of(context).requestFocus(FocusNode());
                                                    showBottomSheet = true;
                                                  },
                                                  child: Container(
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
                                                    padding: EdgeInsets.only(left: AppWidth.w6, right: AppWidth.w6),
                                                    width: size.width,
                                                    height: size.height * .16,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SizedBox(
                                                          height: AppHeight.h10,
                                                        ),
                                                        SizedBox(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  SizedBox(
                                                                    height: size.height * 0.06,
                                                                    width: size.width * .7,
                                                                    child: SizedBox(
                                                                      child: TypeAheadFormField<SupplierList>(
                                                                        textFieldConfiguration: TextFieldConfiguration(
                                                                            focusNode: customerFocusNode,
                                                                            onChanged: (_) {
                                                                              if (customerFocusNode.hasFocus) {
                                                                                showBottomSheet = false;
                                                                              }
                                                                            },
                                                                            onTap: () {
                                                                              showBottomSheet = false;
                                                                            },
                                                                            onSubmitted: (_) {
                                                                              showBottomSheet = true;
                                                                            },
                                                                            scrollPadding: EdgeInsets.zero,
                                                                            style: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                                                            controller: readPurchaseServiceProvider!.supplierNameController,
                                                                            decoration: InputDecoration(
                                                                              suffixIcon: Icon(
                                                                                Icons.arrow_drop_down,
                                                                                color: ColorManager.blueBright,
                                                                              ),
                                                                              prefixIcon: Icon(
                                                                                Icons.person,
                                                                                color: ColorManager.blueBright,
                                                                              ),
                                                                              border: OutlineInputBorder(
                                                                                borderSide: BorderSide(width: 2, color: ColorManager.blackOpacity38),
                                                                                borderRadius: BorderRadius.circular(AppRadius.r5),
                                                                              ),
                                                                              fillColor: ColorManager.white,
                                                                              filled: true,
                                                                              hintText: 'Suppliers',
                                                                              labelText: 'Suppliers',
                                                                              labelStyle:
                                                                                  getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                                                              hintStyle:
                                                                                  getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                                                              focusedBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(width: 2, color: ColorManager.blueBright),
                                                                                borderRadius: BorderRadius.circular(AppRadius.r10),
                                                                              ),
                                                                              errorBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(color: ColorManager.red),
                                                                                borderRadius: BorderRadius.circular(AppRadius.r10),
                                                                              ),
                                                                            )),
                                                                        onSuggestionSelected: (SupplierList sup) {
                                                                          showBottomSheet = true;
                                                                          readPurchaseServiceProvider!.supplierNameController.text =
                                                                              sup.supName.toString();
                                                                          readPurchaseServiceProvider!.supId = int.parse(sup.supId.toString());
                                                                        },
                                                                        itemBuilder: (context, SupplierList sup) => ListTile(
                                                                          title: Text(
                                                                            sup.supName.toString(),
                                                                            style: getRegularStyle(
                                                                              fontSize: FontSize.s12,
                                                                              color: ColorManager.black,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        suggestionsCallback: getStockSuggestion,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      addStockFromPurchase = true;
                                                                      Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) => const AddSupplierScreen(),
                                                                        ),
                                                                      );
                                                                    },
                                                                    customBorder: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(AppRadius.r10),
                                                                    ),
                                                                    splashColor: ColorManager.grey,
                                                                    child: Container(
                                                                      width: size.width * 0.25,
                                                                      padding: EdgeInsets.symmetric(vertical: AppHeight.h2, horizontal: AppWidth.w2),
                                                                      decoration: BoxDecoration(
                                                                        border: Border.all(
                                                                          color: Colors.black38,
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
                                                                                image: AssetImage("assets/images/addSupplier.png"),
                                                                                fit: BoxFit.fill,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            'Create Suppliers',
                                                                            style: getMediumStyle(fontSize: FontSize.s10, color: ColorManager.black),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: AppHeight.h10),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            SizedBox(
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(
                                                                    height: size.height * 0.06,
                                                                    width: size.width * .3,
                                                                    child: TextFormField(
                                                                      keyboardType: TextInputType.number,
                                                                      style: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                                                      controller: billController,
                                                                      textInputAction: TextInputAction.done,
                                                                      decoration: InputDecoration(
                                                                        fillColor: ColorManager.white,
                                                                        filled: true,
                                                                        contentPadding: EdgeInsets.symmetric(horizontal: AppWidth.w10),
                                                                        enabledBorder: OutlineInputBorder(
                                                                          borderSide: BorderSide(color: ColorManager.blackOpacity54, width: 1),
                                                                          borderRadius: BorderRadius.circular(AppRadius.r5),
                                                                        ),
                                                                        border: OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                            color: ColorManager.blackOpacity38,
                                                                            width: AppWidth.w1,
                                                                          ),
                                                                          borderRadius: BorderRadius.circular(AppRadius.r5),
                                                                        ),
                                                                        hintText: 'Bill',
                                                                        labelText: 'Bill',
                                                                        labelStyle:
                                                                            getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                                                        hintStyle: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                                                      ),
                                                                      onChanged: (value) {
                                                                        readPurchaseServiceProvider!.billName = value;
                                                                      },
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            labelStartDate,
                                                            SizedBox(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  SingleChildScrollView(
                                                                    child: SizedBox(
                                                                      height: size.height * 0.06,
                                                                      width: size.width * 0.3,
                                                                      child: DropdownButtonFormField<String>(
                                                                        validator: (value) {
                                                                          if (value == null) {
                                                                            return '*Required';
                                                                          }
                                                                          return null;
                                                                        },
                                                                        decoration: InputDecoration(
                                                                          contentPadding: EdgeInsets.symmetric(horizontal: AppWidth.w10),
                                                                          fillColor: ColorManager.white,
                                                                          filled: true,
                                                                          hintText: 'Mode',
                                                                          labelText: 'Mode',
                                                                          labelStyle:
                                                                              getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                                                          hintStyle:
                                                                              getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                                                          border: OutlineInputBorder(
                                                                            borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                                                            borderRadius: BorderRadius.circular(AppRadius.r5),
                                                                          ),
                                                                        ),
                                                                        itemHeight: size.height * 0.08,
                                                                        isExpanded: true,
                                                                        icon: const Icon(Icons.arrow_drop_down),
                                                                        iconEnabledColor: ColorManager.skyBlue,
                                                                        iconSize: FontSize.s20,
                                                                        items: paymentType.map((project) {
                                                                          return DropdownMenuItem<String>(
                                                                            value: project['id'],
                                                                            child: Container(
                                                                              margin: EdgeInsets.only(left: AppWidth.w1),
                                                                              padding: EdgeInsets.only(left: AppWidth.w10),
                                                                              height: size.height * 0.08,
                                                                              width: double.infinity,
                                                                              child: Align(
                                                                                alignment: Alignment.centerLeft,
                                                                                child: Text(
                                                                                  project['name'].toString(),
                                                                                  style: getMediumStyle(
                                                                                    fontSize: FontSize.s14,
                                                                                    color: ColorManager.black,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }).toList(),
                                                                        onChanged: (paymentMode) {
                                                                          readPurchaseServiceProvider!.payType = paymentMode!;
                                                                        },
                                                                        value: readPurchaseServiceProvider!.payType,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                child: (readPurchaseServiceProvider!.purchaseItemList.isEmpty)
                                                    ? Container(
                                                        height: size.height * .5,
                                                      )
                                                    : Column(
                                                        children: [
                                                          // Padding(
                                                          //   padding: EdgeInsets.only(top: AppHeight.h10, left: AppHeight.h4),
                                                          //   child: Text(
                                                          //     'Purchase Items: ',
                                                          //     style: getBoldStyle(
                                                          //       fontSize: FontSize.s16,
                                                          //       color: ColorManager.black,
                                                          //     ),
                                                          //   ),
                                                          // ),
                                                          SizedBox(
                                                            height: AppHeight.h10,
                                                          ),
                                                          const EntriesTitleHeadingWidget(),
                                                          SizedBox(
                                                            width: size.width,
                                                            height: size.height * 0.45,
                                                            child: ListView(
                                                              children: [
                                                                DataTable(
                                                                  dataRowColor: MaterialStateProperty.resolveWith((states) => ColorManager.white),
                                                                  columnSpacing: 45.0,
                                                                  headingRowHeight: 0.0,
                                                                  horizontalMargin: 10,
                                                                  columns: _createColumn(),
                                                                  rows: watchPurchaseServiceProvider!.purchaseItemList
                                                                      .map(
                                                                        (purchase) => _purchaseReportRow(purchase, size),
                                                                      )
                                                                      .toList(),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            );
                    }),
                    bottomSheet: Consumer<ConnectivityProvider>(
                      builder: (context, connectivity, child) {
                        return (connectivity.isOnline == false)
                            ? SizedBox(
                                width: size.width,
                                height: size.height * .01,
                              )
                            : showBottomSheet == true
                                ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(AppRadius.r10),
                                        topRight: Radius.circular(AppRadius.r10),
                                      ),
                                      color: ColorManager.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: ColorManager.blackOpacity38,
                                          blurRadius: AppRadius.r25, // soften the shadow
                                          spreadRadius: AppRadius.r4, //extend the shadow
                                          offset: const Offset(
                                            15.0, // Move to right 10  horizontally
                                            15.0, // Move to bottom 10 Vertically
                                          ),
                                        )
                                      ],
                                    ),
                                    child: SizedBox(
                                      height: size.height * .2,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: size.width * .7,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(vertical: AppHeight.h8, horizontal: AppWidth.w8),
                                              child: SizedBox(
                                                width: size.width,
                                                height: size.height * .18,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                                          'Discount  ',
                                                          style: getRegularStyle(
                                                            fontSize: FontSize.s14,
                                                            color: ColorManager.black,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Non-Taxable  ',
                                                          style: getRegularStyle(
                                                            fontSize: FontSize.s14,
                                                            color: ColorManager.black,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Taxable  ',
                                                          style: getRegularStyle(
                                                            fontSize: FontSize.s14,
                                                            color: ColorManager.black,
                                                          ),
                                                        ),
                                                        SingleChildScrollView(
                                                          child: SizedBox(
                                                            width: size.width * 0.22,
                                                            height: size.height * 0.036,
                                                            child: DropdownButtonFormField<String>(
                                                              validator: (value) {
                                                                if (value == null) {
                                                                  return '*Required';
                                                                }
                                                                return null;
                                                              },
                                                              decoration: InputDecoration(
                                                                contentPadding: EdgeInsets.only(left: AppWidth.w4),
                                                                fillColor: ColorManager.white,
                                                                filled: true,
                                                                hintText: 'Transaction',
                                                                hintStyle: getSemiBoldStyle(
                                                                  fontSize: FontSize.s14,
                                                                  color: ColorManager.blackOpacity54,
                                                                ),
                                                                border: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                    color: ColorManager.blackOpacity38,
                                                                    width: AppWidth.w1,
                                                                  ),
                                                                  borderRadius: BorderRadius.circular(AppRadius.r5),
                                                                ),
                                                              ),
                                                              itemHeight: size.height * 0.07,
                                                              isExpanded: true,
                                                              icon: const Icon(Icons.arrow_drop_down),
                                                              iconEnabledColor: ColorManager.skyBlue,
                                                              iconSize: FontSize.s16,
                                                              items: tranMode.map((project) {
                                                                return DropdownMenuItem<String>(
                                                                  value: project['id'],
                                                                  child: SizedBox(
                                                                    height: size.height * 0.07,
                                                                    width: double.infinity,
                                                                    child: Align(
                                                                      alignment: Alignment.centerLeft,
                                                                      child: Text(
                                                                        project['name'].toString(),
                                                                        style: getMediumStyle(
                                                                          fontSize: FontSize.s12,
                                                                          color: ColorManager.black,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              }).toList(),
                                                              onChanged: (transaction) {
                                                                readPurchaseServiceProvider!.transactiontype = transaction!;
                                                                readPurchaseServiceProvider!.calculateTotal(
                                                                    double.parse(readPurchaseServiceProvider!.discountController.text.isEmpty
                                                                        ? 0.toString()
                                                                        : readPurchaseServiceProvider!.discountController.text.toString()),
                                                                    int.parse(readPurchaseServiceProvider!.transactiontype.toString()));

                                                                if (readPurchaseServiceProvider!.transactiontype == '1') {
                                                                  readPurchaseServiceProvider!.purchaseVatAmount = 0.0;
                                                                  readPurchaseServiceProvider!.purchaseTaxableAmount = 0.0;
                                                                }
                                                              },
                                                              value: readPurchaseServiceProvider!.transactiontype,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          'Total  ',
                                                          style: getRegularStyle(
                                                            fontSize: FontSize.s14,
                                                            color: ColorManager.black,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: AppHeight.h4,
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          // '${watchPurchaseByIdServiceProvider.purchaseByIdModel.data!.purSubAmount}',
                                                          watchPurchaseServiceProvider!.purchaseSubTotal.toString(),
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
                                                            controller: readPurchaseServiceProvider!.discountController,
                                                            onChanged: (value) {
                                                              readPurchaseServiceProvider!.calculateTotal(
                                                                  double.parse((readPurchaseServiceProvider!.discountController.text.isEmpty)
                                                                      ? '0'
                                                                      : readPurchaseServiceProvider!.discountController.text),
                                                                  int.parse(readPurchaseServiceProvider!.transactiontype.toString()));
                                                            },
                                                            decoration: InputDecoration(
                                                              hintText: '0.0',
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
                                                          // '${watchPurchaseByIdServiceProvider.purchaseByIdModel.data!.purNonTaxableAmount}',
                                                          readPurchaseServiceProvider!.transactiontype == '1'
                                                              ? watchPurchaseServiceProvider!.purchaseNonTaxableAmount.toString()
                                                              : 0.0.toString(),

                                                          style: getMediumStyle(
                                                            fontSize: FontSize.s12,
                                                            color: ColorManager.black,
                                                          ),
                                                        ),
                                                        Text(
                                                          // '${watchPurchaseByIdServiceProvider.purchaseByIdModel.data!.purTaxableAmount}',
                                                          readPurchaseServiceProvider!.transactiontype == '0'
                                                              ? watchPurchaseServiceProvider!.purchaseTaxableAmount.toString()
                                                              : 0.0.toString(),

                                                          style: getMediumStyle(
                                                            fontSize: FontSize.s12,
                                                            color: ColorManager.black,
                                                          ),
                                                        ),
                                                        Text(
                                                          // '${watchPurchaseByIdServiceProvider.purchaseByIdModel.data!.purTotalAmount}',
                                                          readPurchaseServiceProvider!.transactiontype == '0'
                                                              ? watchPurchaseServiceProvider!.purchaseVatAmount.toStringAsFixed(2)
                                                              : 0.0.toString(),
                                                          style: getMediumStyle(
                                                            fontSize: FontSize.s12,
                                                            color: ColorManager.black,
                                                          ),
                                                        ),
                                                        Text(
                                                          // '${watchPurchaseByIdServiceProvider.purchaseByIdModel.data!.purTotalAmount}',
                                                          watchPurchaseServiceProvider!.purchaseTotalAmount.toStringAsFixed(2),
                                                          style: getBoldStyle(
                                                            fontSize: FontSize.s12,
                                                            color: ColorManager.black,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: AppHeight.h4,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          VerticalDivider(thickness: AppWidth.w1, color: ColorManager.black),
                                          SizedBox(
                                            width: size.width * .25,
                                            height: size.height * .14,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    readPurchaseServiceProvider!.setLoadingTrue();

                                                    createPurchase();
                                                    readPurchaseServiceProvider!.setLoadingFalse();
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor: readPurchaseServiceProvider!.purchaseItemList.isEmpty
                                                        ? MaterialStateProperty.all(Colors.blue.shade200)
                                                        : MaterialStateProperty.all(ColorManager.blueBright),
                                                    padding: MaterialStateProperty.all(
                                                        EdgeInsets.symmetric(horizontal: AppWidth.w10, vertical: AppHeight.h1)),
                                                    textStyle:
                                                        MaterialStateProperty.all(getMediumStyle(fontSize: FontSize.s14, color: ColorManager.white)),
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
                                  )
                                : SizedBox(
                                    width: size.width,
                                    height: size.height * .01,
                                  );
                      },
                    ),
                  ),
                  if (widget.purchaseDetails != null)
                    readPurchaseByIdServiceProvider!.purchaseByIdModel.data == null
                        ? Container(
                            alignment: Alignment.center,
                            color: Colors.white70,
                            child: const SpinKitCubeGrid(
                              color: Colors.indigoAccent,
                              size: 70,
                            ),
                          )
                        : const SizedBox()
                ],
              );
      },
    );
  }

  _createColumn() {
    return <DataColumn>[
      DataColumn(label: Container()),
      DataColumn(label: Container()),
      DataColumn(label: Container()),
      DataColumn(label: Container()),
    ];
  }

  DataRow _purchaseReportRow(PurchaseItemModel purchaseItem, Size size) {
    return DataRow(
      cells: [
        DataCell(
          SizedBox(
            width: size.width * 0.3,
            child: Text(
              purchaseItem.purchaseStkName.toString(),
              style: getMediumStyle(
                fontSize: FontSize.s12,
                color: ColorManager.black,
              ),
            ),
          ),
        ),
        DataCell(
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              double.parse(purchaseItem.purDQty.toString().split('.')[1].toString()) > 0
                  ? purchaseItem.purDQty.toString()
                  : purchaseItem.purDQty.toStringAsFixed(0),
              style: getMediumStyle(
                fontSize: FontSize.s12,
                color: ColorManager.black,
              ),
            ),
          ),
        ),
        DataCell(
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              purchaseItem.purDRate.toString(),
              textAlign: TextAlign.right,
              style: getMediumStyle(
                fontSize: FontSize.s12,
                color: ColorManager.black,
              ),
            ),
          ),
        ),
        DataCell(
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(right: AppWidth.w6),
              child: Text(
                purchaseItem.stkTotal.toString(),
                style: getMediumStyle(
                  fontSize: FontSize.s12,
                  color: ColorManager.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void selectFromDate() async {
    readPurchaseServiceProvider!.setSelectedFromDate(DateTime.parse(readPurchaseServiceProvider!.purchaseDate.toString()));
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: readPurchaseServiceProvider!.selectedFromDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2090),
    );
    if (selected != null && selected != readPurchaseServiceProvider!.selectedFromDate) {
      setState(() {
        readPurchaseServiceProvider!.setSelectedFromDate(selected);
      });
    }
  }

  createPurchase() async {
    if (readPurchaseServiceProvider!.supplierNameController.text.isNotEmpty) {
      if (formKey.currentState!.validate()) {
        if (readPurchaseServiceProvider!.purchaseItemList.isNotEmpty) {
          PurchaseDetails purchaseDetails = PurchaseDetails(
            purId: readPurchaseServiceProvider!.purId ?? 0,
            purType: 1,
            purDate: DateTime.parse(readPurchaseServiceProvider!.purchaseDate.toString()).toIso8601String(),
            purSupId: readPurchaseServiceProvider!.supId,
            purMode: int.parse(readPurchaseServiceProvider!.transactiontype.toString()),
            purCashCredit: int.parse(readPurchaseServiceProvider!.payType.toString()),
            purInsertedDate: DateTime.parse(DateTime.now().toIso8601String().split("T")[0]).toIso8601String(),
            purInsertedBy: int.parse(sharedPref!.getString('staffId').toString()),
            purSubAmount: watchPurchaseServiceProvider!.purchaseSubTotal,
            purDiscAmount: double.parse(
                readPurchaseServiceProvider!.discountController.text.isEmpty ? 0.0.toString() : readPurchaseServiceProvider!.discountController.text),
            purTaxableAmount: watchPurchaseServiceProvider!.purchaseTaxableAmount,
            purNonTaxableAmount: watchPurchaseServiceProvider!.purchaseNonTaxableAmount,
            purVatAmount: watchPurchaseServiceProvider!.purchaseVatAmount,
            purTotalAmount: watchPurchaseServiceProvider!.purchaseTotalAmount,
            purInActive: false,
            supplier: readPurchaseServiceProvider!.supplierNameController.text,
            purBillNo: readPurchaseServiceProvider!.billName,
          );
          CreatePurchase createPurchase = CreatePurchase(
            purchase: purchaseDetails,
            purchasedetail: readPurchaseServiceProvider!.purchaseItemList,
          );

          var response = await context.read<UpdatePurchaseServiceProvider>().updatePurchase(createPurchase);

          if (response['responseType'] == 6) {
            readPurchaseServiceProvider!.purchaseItemList.clear();
            readPurchaseServiceProvider!.duplicatePurchaseItemList.clear();
            Fluttertoast.cancel();
            Fluttertoast.showToast(
              msg: 'Purchase Successful',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: ColorManager.green,
            );
            readPurchaseServiceProvider!.supplierNameController.clear();
            if (!mounted) return;
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const PurchaseEntries(
                    fromPurchase: false,
                  ),
                ),
                (route) => false);
          } else {
            Fluttertoast.cancel();
            Fluttertoast.showToast(
              msg: 'Purchase Failed \n ${response['message']}',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: ColorManager.error,
            );
          }
        } else {
          Fluttertoast.cancel();
          Fluttertoast.showToast(
            msg: 'Item is Empty',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: ColorManager.error,
          );
        }
      }
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: 'Please choose Suppliers',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ColorManager.error,
      );
    }
  }

  List<SupplierList> getStockSuggestion(String query) =>
      List.of(watchTabletSetupServiceProvider!.tabletSetupModel.data!.supplierList!).where((SupplierList sup) {
        final stockNameLower = sup.supName!.toLowerCase();
        final queryLower = query.toLowerCase();
        return stockNameLower.contains(queryLower);
      }).toList();
}
