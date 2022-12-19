import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/homepage/home_screen.dart';
import 'package:webshop/view/sales/model/sales_add_model.dart';
import 'package:webshop/view/sales/widgets/table_header_widget.dart';
import 'package:webshop/view/sales_return/models/get_sales_model.dart';
import 'package:webshop/view/sales_return/provider/get_salesbyid_provider.dart';

import 'provider/post_sales_return.dart';
import 'provider/sales_return_provider.dart';

class SalesReturnEntries extends StatefulWidget {
  const SalesReturnEntries({super.key});

  @override
  State<SalesReturnEntries> createState() => _SalesReturnEntriesState();
}

class _SalesReturnEntriesState extends State<SalesReturnEntries> {
  TextEditingController billNoController = TextEditingController();
  TextEditingController billToController = TextEditingController();
  TextEditingController discountPercentController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController panController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TabletSetupServiceProvider? watchTabletSetupServiceProvider;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    watchTabletSetupServiceProvider = context.watch<TabletSetupServiceProvider>();
    SalesReturnServiceProvider readSalesReturnServiceProvider = context.read<SalesReturnServiceProvider>();
    SalesReturnServiceProvider watchSalesReturnServiceProvider = context.watch<SalesReturnServiceProvider>();
    GetSalesByIdProvider readGetSalesByIdProvider = context.read<GetSalesByIdProvider>();
    GetSalesByIdProvider watchGetSalesByIdProvider = context.watch<GetSalesByIdProvider>();

    return Consumer<ConnectivityProvider>(builder: (context, connectivity, child) {
      return (connectivity.isOnline == false)
          ? const NoInternet()
          : Scaffold(
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
                  'Sales Return Entries',
                  style: getMediumStyle(fontSize: FontSize.s18, color: ColorManager.white),
                ),
                leading: IconButton(
                  onPressed: () {
                    readGetSalesByIdProvider.clearCancelList();

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
                      onPressed: () async {
                        if (readGetSalesByIdProvider.salesReturnCancelList.isNotEmpty) {
                          Sales salesReturnDetails = Sales(
                            traId: watchSalesReturnServiceProvider.searchSalesByBillNoModel.data!.traId!,
                            traDate: DateTime.parse(DateTime.now().toIso8601String().split("T")[0]).toIso8601String(),
                            traType: 2,
                            traAgtId: 0,
                            traBillNo: billNoController.text,
                            traInsertedBy: int.parse(sharedPref!.getString('staffId').toString()),
                            traDiscPercent: double.parse((discountPercentController.text == '') ? 0.toString() : discountPercentController.text),
                            traDiscAmount: double.parse(discountController.text.isEmpty ? 0.0.toString() : discountController.text),
                            traSubAmount: watchGetSalesByIdProvider.salesReturnSubTotal,
                            traTotalAmount: watchGetSalesByIdProvider.salesReturnTotalAmount,
                            traRemark: remarksController.text,
                            traInActive: false,
                            traInsertedStaff: sharedPref!.getString('userType').toString(),
                            traCustomerName: billToController.text,
                            traCustomerPanNo: panController.text,
                            traCustomerAddress: addressController.text,
                            traCustomerMobileNo: phoneController.text,
                            billPModeDes: paymentType[1]['id'].toString(),
                          );

                          readGetSalesByIdProvider.business = watchGetSalesByIdProvider.business;
                          SalesModel getSaleById =
                              SalesModel(sales: salesReturnDetails, tradeSaledetail: readGetSalesByIdProvider.salesReturnCancelList, businesslist: readGetSalesByIdProvider.business);

                          var response = await context.read<PostSaleReturnProvider>().postSalesReturn(getSaleById);
                          log(response.toString(), name: 'response');

                          if (response['responseType'] == 6) {
                            readGetSalesByIdProvider.clearCancelList();
                            Fluttertoast.cancel();
                            Fluttertoast.showToast(
                              msg: 'Sales Return Successful',
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: ColorManager.black,
                            );
                            if (!mounted) return;
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                                (route) => false);
                          } else {
                            Fluttertoast.cancel();
                            Fluttertoast.showToast(
                              msg: 'Sales Return Failed',
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
                      },
                      child: Text(
                        'Save',
                        style: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.white),
                      ),
                    ),
                  )
                ],
              ),
              body: Consumer(
                builder: (context, salesDetails, child) {
                  return GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: SingleChildScrollView(
                      child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 0, horizontal: AppWidth.w4),
                              decoration: BoxDecoration(
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
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(vertical: AppHeight.h4),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: size.height * 0.06,
                                              width: size.width * .32,
                                              child: TextFormField(
                                                controller: billNoController,
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h10, horizontal: AppWidth.w13),
                                                  border: OutlineInputBorder(
                                                    borderSide: const BorderSide(width: 1.5, color: Colors.blue),
                                                    borderRadius: BorderRadius.circular(AppRadius.r5),
                                                  ),
                                                  labelText: 'Bill No.',
                                                  hintText: 'Bill No',
                                                ),
                                                onChanged: (value) async {
                                                  await readSalesReturnServiceProvider.getSalesByBillNo(value.isEmpty ? int.parse(0.toString()) : int.parse(value));
                                                },
                                              ),
                                            ),
                                            ElevatedButton(
                                                onPressed: () async {
                                                  readGetSalesByIdProvider.isChecked.clear();
                                                  billToController.clear();
                                                  GetSalesByIdModel res = await readGetSalesByIdProvider.getSalesById(watchSalesReturnServiceProvider.searchSalesByBillNoModel.data!.traId!);

                                                  if (res.success == true) {
                                                    if (readGetSalesByIdProvider.getSalesByIdModel.data != null) {
                                                      List<TradeSaleDetailDtoList> tradeSaleDetailDtoListMode = readGetSalesByIdProvider.getSalesByIdModel.data!.tradeSaleDetailDtoList!;

                                                      readGetSalesByIdProvider.addToList(tradeSaleDetailDtoListMode);

                                                      readGetSalesByIdProvider.addBool(List<bool>.generate(watchGetSalesByIdProvider.initialSalesReturnList.length, (index) => false));
                                                    }
                                                    if (watchSalesReturnServiceProvider.searchSalesByBillNoModel.data!.traCustomerName != null) {
                                                      billToController.text = watchSalesReturnServiceProvider.searchSalesByBillNoModel.data!.traCustomerName.toString();
                                                      panController.text = watchSalesReturnServiceProvider.searchSalesByBillNoModel.data!.traCustomerPanNo ?? "";
                                                      discountPercentController.text = watchSalesReturnServiceProvider.searchSalesByBillNoModel.data!.traDiscPercent.toString();

                                                      discountController.text = ((double.parse(discountPercentController.text.isEmpty ? 0.toString() : discountPercentController.text.toString())) /
                                                              100 *
                                                              readGetSalesByIdProvider.salesReturnSubTotal)
                                                          .toStringAsFixed(2);

                                                      phoneController.text = watchSalesReturnServiceProvider.searchSalesByBillNoModel.data!.traCustomerMobileNo ?? "";
                                                      addressController.text = watchSalesReturnServiceProvider.searchSalesByBillNoModel.data!.traCustomerAddress ?? '';
                                                    }
                                                  }
                                                },
                                                child: const Text('search')),
                                            SizedBox(
                                              height: size.height * 0.06,
                                              width: size.width * .4,
                                              child: TextFormField(
                                                controller: billToController,
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h10, horizontal: AppWidth.w13),
                                                  border: OutlineInputBorder(
                                                    borderSide: const BorderSide(width: 1.5, color: Colors.blue),
                                                    borderRadius: BorderRadius.circular(AppRadius.r5),
                                                  ),
                                                  labelText: 'Bill To.',
                                                  hintText: 'Bill To',
                                                ),
                                              ),
                                            ),
                                          ],
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
                                          width: size.width * .61,
                                          child: TextFormField(
                                            controller: panController,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h4, horizontal: AppWidth.w10),
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(width: 1.5, color: Colors.blue),
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              labelText: 'Pan No',
                                              hintText: 'Pan No',
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: size.width * .35,
                                          child: TextFormField(
                                            controller: phoneController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h4, horizontal: AppWidth.w10),
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(width: 1.5, color: Colors.blue),
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              labelText: 'Phone No',
                                              hintText: 'Phone No',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: AppHeight.h4, top: AppHeight.h4),
                                    child: SizedBox(
                                      child: TextFormField(
                                        controller: addressController,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h4, horizontal: AppWidth.w10),
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(width: 1.5, color: Colors.blue),
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                          labelText: 'Address',
                                          hintText: 'Address',
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: AppHeight.h6,
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: ColorManager.grey2,
                              thickness: AppHeight.h1,
                            ),
                            (watchGetSalesByIdProvider.initialSalesReturnList.isEmpty)
                                ? const SizedBox()
                                : Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Sales Return:',
                                      style: getBoldStyle(
                                        fontSize: FontSize.s16,
                                        color: ColorManager.black,
                                      ),
                                    ),
                                  ),
                            (watchGetSalesByIdProvider.initialSalesReturnList.isNotEmpty)
                                ? GestureDetector(
                                    onTap: () {
                                      FocusScope.of(context).requestFocus(FocusNode());
                                    },
                                    child: SizedBox(
                                      height: size.height * 0.7,
                                      child: Column(
                                        children: [
                                          TableSalesHeaderWidget(
                                            color: ColorManager.red,
                                          ),
                                          Container(
                                              color: ColorManager.grey.withOpacity(.05),
                                              width: size.width,
                                              height: size.height * 0.65,
                                              child: ListView.separated(
                                                separatorBuilder: (BuildContext context, int index) {
                                                  return Divider(
                                                    color: ColorManager.black,
                                                  );
                                                },
                                                itemCount: watchGetSalesByIdProvider.initialSalesReturnList.length,
                                                itemBuilder: (context, index) {
                                                  var itemData = watchGetSalesByIdProvider.initialSalesReturnList[index];
                                                  if (watchGetSalesByIdProvider.cancelQty[itemData.traDStkId!] == null) {
                                                    watchGetSalesByIdProvider.cancelQty[itemData.traDStkId!] = watchGetSalesByIdProvider.initialSalesReturnList[index].traDQty!;
                                                  } else {
                                                    watchGetSalesByIdProvider.cancelQty[itemData.traDStkId!];
                                                  }

                                                  watchGetSalesByIdProvider.canQty = readGetSalesByIdProvider.cancelQty[itemData.traDStkId]!;

                                                  watchGetSalesByIdProvider.totalAmount = itemData.traDRate! * double.parse(watchGetSalesByIdProvider.canQty.toString());
                                                  SalesItemModel cancelItemsModel = SalesItemModel(
                                                      traDId: itemData.traDId,
                                                      traDStkId: itemData.traDStkId,
                                                      traDRate: itemData.traDRate,
                                                      traDQty: double.parse(watchGetSalesByIdProvider.canQty.toString()),
                                                      traDAmount: watchGetSalesByIdProvider.totalAmount,
                                                      traDStkName: itemData.stDes);
                                                  watchGetSalesByIdProvider.deleteSalesReturnItem(cancelItemsModel);

                                                  if (watchGetSalesByIdProvider.isChecked[index] == true) {
                                                    if (watchGetSalesByIdProvider.checkDuplicate(cancelItemsModel) == false) {
                                                      watchGetSalesByIdProvider.addToCancelList(cancelItemsModel);
                                                    }
                                                  }

                                                  return Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets.all(AppHeight.h2),
                                                        width: size.width * 0.06,
                                                        child: Center(
                                                          child: Checkbox(
                                                            value: watchGetSalesByIdProvider.isChecked[index],
                                                            activeColor: ColorManager.pink,
                                                            side: MaterialStateBorderSide.resolveWith(
                                                              (states) => BorderSide(width: 1.0, color: ColorManager.black),
                                                            ),
                                                            onChanged: (value) {
                                                              readGetSalesByIdProvider.changeBool(value!, index);
                                                              if (readGetSalesByIdProvider.getSalesByIdModel.data != null) {
                                                                if (watchGetSalesByIdProvider.isChecked[index] == true) {
                                                                  if (watchGetSalesByIdProvider.checkDuplicate(cancelItemsModel) == false) {
                                                                    watchGetSalesByIdProvider.addToCancelList(cancelItemsModel);
                                                                  }
                                                                } else {
                                                                  watchGetSalesByIdProvider.deleteSalesReturnItem(cancelItemsModel);
                                                                }
                                                              }

                                                              watchGetSalesByIdProvider.calculateSalesReturnSubTotal(
                                                                  discount: double.parse(discountPercentController.text.isEmpty ? 0.toString() : discountPercentController.text.toString()));
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: size.width * 0.3,
                                                        child: Text(
                                                          "${itemData.stDes} (${itemData.traDQty})",
                                                          style: getRegularStyle(
                                                            color: ColorManager.black,
                                                            fontSize: FontSize.s12,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: size.width * 0.2,
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: <Widget>[
                                                            GestureDetector(
                                                              onTap: (watchGetSalesByIdProvider.canQty >= itemData.traDQty!)
                                                                  ? () => {
                                                                        Fluttertoast.cancel(),
                                                                        Fluttertoast.showToast(
                                                                          msg: "Return cannot be more than total quantity",
                                                                          toastLength: Toast.LENGTH_LONG,
                                                                          gravity: ToastGravity.BOTTOM,
                                                                          backgroundColor: ColorManager.error,
                                                                        )
                                                                      }
                                                                  : () {
                                                                      watchGetSalesByIdProvider.itemIncreament(itemData);
                                                                      watchGetSalesByIdProvider.canQty = readGetSalesByIdProvider.cancelQty[itemData.traDStkId]!;
                                                                      watchGetSalesByIdProvider.totalAmount = itemData.traDRate! * double.parse(watchGetSalesByIdProvider.canQty.toString());

                                                                      SalesItemModel cancelItems = SalesItemModel(
                                                                          traDId: 0,
                                                                          traDStkId: itemData.traDStkId,
                                                                          traDRate: itemData.traDRate,
                                                                          traDQty: double.parse(watchGetSalesByIdProvider.canQty.toString()),
                                                                          traDAmount: watchGetSalesByIdProvider.totalAmount,
                                                                          traDStkName: itemData.stDes);
                                                                      watchGetSalesByIdProvider.deleteSalesReturnItem(cancelItems);
                                                                      if (watchGetSalesByIdProvider.checkDuplicate(cancelItems) == false) {
                                                                        watchGetSalesByIdProvider.addToCancelList(cancelItems);
                                                                      }
                                                                      if (watchGetSalesByIdProvider.isChecked[index] == true) {
                                                                        watchGetSalesByIdProvider.calculateSalesReturnSubTotal(
                                                                            discount: double.parse(discountPercentController.text.isEmpty ? 0.toString() : discountPercentController.text.toString()));
                                                                      }
                                                                    },
                                                              child: CircleAvatar(
                                                                radius: AppRadius.r10,
                                                                backgroundColor: (watchGetSalesByIdProvider.canQty >= itemData.traDQty!) ? ColorManager.red : ColorManager.amber,
                                                                child: Icon(
                                                                  Icons.add,
                                                                  color: ColorManager.white,
                                                                  size: FontSize.s14,
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              width: size.width * 0.06,
                                                              height: size.height * 0.03,
                                                              margin: EdgeInsets.only(top: AppHeight.h4, bottom: AppHeight.h4),
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.all(
                                                                  Radius.circular(AppRadius.r10),
                                                                ),
                                                                color: ColorManager.white,
                                                                border: Border.all(
                                                                  color: ColorManager.black,
                                                                ),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  watchGetSalesByIdProvider.canQty.toString(),
                                                                  style: getSemiBoldStyle(
                                                                    color: ColorManager.black,
                                                                    fontSize: FontSize.s10,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: (watchGetSalesByIdProvider.canQty == 1.0)
                                                                  ? () => {
                                                                        Fluttertoast.cancel(),
                                                                        Fluttertoast.showToast(
                                                                          msg: "Item Cannot be Less Then 1",
                                                                          toastLength: Toast.LENGTH_LONG,
                                                                          gravity: ToastGravity.BOTTOM,
                                                                          backgroundColor: ColorManager.error,
                                                                        )
                                                                      }
                                                                  : () {
                                                                      readGetSalesByIdProvider.itemDecrement(itemData);
                                                                      watchGetSalesByIdProvider.canQty = readGetSalesByIdProvider.cancelQty[itemData.traDStkId]!;
                                                                      watchGetSalesByIdProvider.totalAmount = itemData.traDRate! * double.parse(watchGetSalesByIdProvider.canQty.toString());

                                                                      SalesItemModel cancelItems = SalesItemModel(
                                                                          traDId: 0,
                                                                          traDStkId: itemData.traDStkId,
                                                                          traDRate: itemData.traDRate,
                                                                          traDQty: double.parse(watchGetSalesByIdProvider.canQty.toString()),
                                                                          traDAmount: watchGetSalesByIdProvider.totalAmount,
                                                                          traDStkName: itemData.stDes);
                                                                      watchGetSalesByIdProvider.deleteSalesReturnItem(cancelItems);
                                                                      if (watchGetSalesByIdProvider.checkDuplicate(cancelItems) == false) {
                                                                        watchGetSalesByIdProvider.addToCancelList(cancelItems);
                                                                      }
                                                                      if (watchGetSalesByIdProvider.isChecked[index] == true) {
                                                                        watchGetSalesByIdProvider.calculateSalesReturnSubTotal(
                                                                            discount: double.parse(discountPercentController.text.isEmpty ? 0.toString() : discountPercentController.text.toString()));
                                                                      }
                                                                    },
                                                              child: CircleAvatar(
                                                                radius: AppRadius.r10,
                                                                backgroundColor: (watchGetSalesByIdProvider.canQty == 1.0) ? ColorManager.red : ColorManager.amber,
                                                                child: Icon(
                                                                  Icons.remove,
                                                                  color: ColorManager.white,
                                                                  size: FontSize.s14,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: size.height * 0.08,
                                                        child: Center(
                                                          child: Text(
                                                            itemData.traDRate.toString(),
                                                            style: getRegularStyle(
                                                              color: ColorManager.black,
                                                              fontSize: FontSize.s12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: size.height * 0.09,
                                                        child: Center(
                                                          child: Text(
                                                            watchGetSalesByIdProvider.totalAmount.toString(),
                                                            style: getRegularStyle(
                                                              color: ColorManager.black,
                                                              fontSize: FontSize.s12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              )),
                                        ],
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      FocusScope.of(context).requestFocus(FocusNode());
                                    },
                                    child: SizedBox(
                                      height: size.height * 0.5,
                                      width: size.width,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              bottomSheet: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(AppRadius.r10), topRight: Radius.circular(AppRadius.r10)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: ColorManager.blackOpacity38,
                        blurRadius: 25.0, // soften the shadow
                        spreadRadius: 5.0, //extend the shadow
                        offset: const Offset(
                          15.0, // Move to right 10  horizontally
                          15.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: AppHeight.h10, left: AppWidth.w10, right: AppWidth.w10),
                    child: SizedBox(
                      width: size.width,
                      height: size.height * .14,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Subtotal  ',
                                    style: getRegularStyle(
                                      fontSize: FontSize.s14,
                                      color: ColorManager.black,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Discount (%)',
                                        style: getRegularStyle(
                                          fontSize: FontSize.s14,
                                          color: ColorManager.black,
                                        ),
                                      ),
                                      SizedBox(
                                        width: size.width * .2,
                                        height: size.height * .03,
                                        child: TextField(
                                          textAlign: TextAlign.end,
                                          keyboardType: TextInputType.number,
                                          controller: discountPercentController,
                                          onChanged: (value) {
                                            discountController.text =
                                                ((double.parse(value.isEmpty ? 0.toString() : value.toString())) / 100 * readGetSalesByIdProvider.salesReturnSubTotal).toStringAsFixed(2);
                                          },
                                          decoration: InputDecoration(
                                            hintText: 'Discount (%)',
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
                                    ],
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    watchGetSalesByIdProvider.salesReturnSubTotal.toString(),
                                    style: getRegularStyle(
                                      fontSize: FontSize.s12,
                                      color: ColorManager.black,
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.width * .15,
                                    height: size.height * .03,
                                    child: TextField(
                                      textAlign: TextAlign.end,
                                      keyboardType: TextInputType.number,
                                      controller: discountController,
                                      onChanged: (value) {
                                        // if (watchSalesServiceProvider.salesSubTotal > 0) {
                                        //   readSalesServiceProvider!.calculateSalesSubTotal(
                                        //       discount: double.parse((readSalesServiceProvider!.discountController.text.isEmpty) ? '0' : readSalesServiceProvider!.discountController.text));

                                        //   readSalesServiceProvider!.discountPercentController.text =
                                        //       ((double.parse(readSalesServiceProvider!.discountController.text.isEmpty ? 0.toString() : readSalesServiceProvider!.discountController.text) * 100.0) /
                                        //               watchSalesServiceProvider.salesSubTotal)
                                        //           .toString();
                                        // }
                                        discountPercentController.text =
                                            ((double.parse(value.isEmpty ? 0.toString() : value.toString())) / readGetSalesByIdProvider.salesReturnSubTotal * 100).toStringAsFixed(2);

                                        watchGetSalesByIdProvider.calculateSalesReturnSubTotal(
                                            discount: double.parse(discountPercentController.text.isEmpty ? 0.toString() : discountPercentController.text.toString()));
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
                                    // '${watchPurchaseByIdServiceProvider.purchaseByIdModel.data!.purTotalAmount}',
                                    // watchSalesServiceProvider.salesTotalAmount.toString(),
                                    watchGetSalesByIdProvider.salesReturnTotalAmount.toString(),
                                    style: getBoldStyle(
                                      fontSize: FontSize.s12,
                                      color: ColorManager.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: size.width * 0.93,
                                height: size.height * 0.06,
                                child: TextFormField(
                                  controller: remarksController,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h10, horizontal: AppWidth.w10),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: ColorManager.blackOpacity54, width: AppWidth.w1),
                                      borderRadius: BorderRadius.circular(AppRadius.r10),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: ColorManager.blueBright, width: AppWidth.w2),
                                      borderRadius: BorderRadius.circular(AppRadius.r10),
                                    ),
                                    labelText: 'Remark',
                                    labelStyle: getMediumStyle(fontSize: FontSize.s12, color: ColorManager.blackOpacity38),
                                    hintText: 'Remark',
                                    hintStyle: getMediumStyle(fontSize: FontSize.s12, color: ColorManager.blackOpacity38),
                                  ),
                                  onChanged: (value) {},
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
    });
  }
}
