import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/sales/model/sales_add_model.dart';
import 'package:webshop/view/sales_return/provider/get_salesbyid_provider.dart';
import 'package:webshop/view/sales/services/sales_service.dart';
import 'package:webshop/view/sales/widgets/sales_list.dart';
import 'package:webshop/view/stock/model/stock_list_model.dart';
import 'package:webshop/view/stock/services/get_stock_detail_provider.dart';

class AddSales extends StatefulWidget {
  final TextEditingController discountController;
  const AddSales({super.key, required this.discountController});

  @override
  State<AddSales> createState() => _AddSalesState();
}

class _AddSalesState extends State<AddSales> {
  TextEditingController barCodeController = TextEditingController();
  TextEditingController stockListController = TextEditingController();
  TextEditingController quantityController = TextEditingController(text: '1');
  TextEditingController rateController = TextEditingController();

  ScrollController scrollController = ScrollController();

  FocusNode brandFocusNode = FocusNode();
  FocusNode stockFocusNode = FocusNode();
  FocusNode qtyFocusNode = FocusNode();
  FocusNode rateFocusNode = FocusNode();
  int? brandId;

  @override
  void initState() {
    context.read<GetStockListProvider>().getStockList(brandId);
    scrollController.addListener(() {
      setState(() {
        const SalesList();
      });
    });
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

  TabletSetupServiceProvider? watchTabletSetupServiceProvider;
  GetStockListProvider? watchGetStockListProvider;
  SalesServiceProvider? readSalesServiceProvider;

  Future<void> refresh() async {
    await context.read<TabletSetupServiceProvider>().getTabletSetup();
  }

  @override
  Widget build(BuildContext context) {
    watchTabletSetupServiceProvider = context.watch<TabletSetupServiceProvider>();
    watchGetStockListProvider = context.watch<GetStockListProvider>();
    readSalesServiceProvider = context.read<SalesServiceProvider>();
    SalesServiceProvider watchSalesServiceProvider = context.watch<SalesServiceProvider>();

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
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
                blurRadius: 5,
                offset: const Offset(0.0, 1.0),
                color: ColorManager.grey,
              )
            ],
          ),
        ),
        centerTitle: false,
        elevation: 1,
        backgroundColor: ColorManager.white,
        title: Text(
          'Add Sales',
          style: getMediumStyle(fontSize: FontSize.s18, color: ColorManager.white),
        ),
        actions: [
          watchSalesServiceProvider.salesItemList.isEmpty
              ? Container()
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextButton(
                    onPressed: () {
                      readSalesServiceProvider!.calculateSalesSubTotal(discount: double.parse(widget.discountController.text.isEmpty ? 0.toString() : widget.discountController.text));

                      Navigator.pop(context);
                    },
                    child: Text(
                      'Confirm',
                      style: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.white),
                    ),
                  ),
                )
        ],
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          final ScrollDirection direction = notification.direction;

          if (direction == ScrollDirection.reverse) {
            readSalesServiceProvider!.setShowBottomFalse();
          } else if (direction == ScrollDirection.forward) {
            readSalesServiceProvider!.setShowBottomTrue();
          }
          log(readSalesServiceProvider!.showBottom.toString());

          return true;
        },
        child: Consumer<ConnectivityProvider>(builder: (context, connectivity, child) {
          return (connectivity.isOnline == false)
              ? const NoInternet()
              : Consumer<GetSalesByIdProvider>(
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
                                child: Padding(
                                  padding: EdgeInsets.all(AppHeight.h4),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: AppHeight.h6,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: AppHeight.h6),
                                        child: SizedBox(
                                          height: size.height * .07,
                                          child: SingleChildScrollView(
                                            child: DropdownButtonFormField<BrandList>(
                                              validator: (value) {
                                                if (value == null) {
                                                  return '*Required';
                                                }
                                                return null;
                                              },
                                              focusNode: brandFocusNode,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.symmetric(horizontal: AppWidth.w10, vertical: AppHeight.h10),
                                                hintText: 'Select brand',
                                                hintStyle: getMediumStyle(
                                                  fontSize: FontSize.s16,
                                                  color: ColorManager.black,
                                                ),
                                                labelText: 'Select brand',
                                                labelStyle: getMediumStyle(
                                                  fontSize: FontSize.s16,
                                                  color: ColorManager.black,
                                                ),
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
                                                        padding: EdgeInsets.symmetric(horizontal: AppWidth.w10),
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
                                                watchTabletSetupServiceProvider!.brandList = group;

                                                watchTabletSetupServiceProvider!.brandId = group!.brandId;

                                                // fieldFocusChange(context, brandFocusNode, stockFocusNode);
                                                setState(() {});
                                              },
                                              value: watchTabletSetupServiceProvider!.brandList,
                                            ),
                                          ),
                                        ),
                                      ),
                                      TypeAheadFormField<StockDetailList>(
                                        autovalidateMode: AutovalidateMode.disabled,
                                        textFieldConfiguration: TextFieldConfiguration(
                                          controller: stockListController,
                                          focusNode: stockFocusNode,
                                          decoration: InputDecoration(
                                            suffixIcon: (stockListController.text == "")
                                                ? Icon(
                                                    Icons.arrow_downward,
                                                    size: FontSize.s20,
                                                  )
                                                : IconButton(
                                                    icon: const Icon(Icons.close_outlined),
                                                    iconSize: FontSize.s20,
                                                    onPressed: () {
                                                      stockListController.clear();
                                                      FocusScope.of(context).requestFocus(FocusNode());

                                                      watchSalesServiceProvider.salesAmount = 0.0;

                                                      quantityController.clear();
                                                      rateController.clear();
                                                    },
                                                  ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.circular(AppRadius.r4),
                                            ),
                                            fillColor: ColorManager.white,
                                            filled: true,
                                            hintText: 'Select Item',
                                            hintStyle: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                            labelText: 'Select Item',
                                            labelStyle: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                            floatingLabelBehavior: FloatingLabelBehavior.always,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: ColorManager.blackOpacity38),
                                              borderRadius: BorderRadius.circular(AppRadius.r4),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: ColorManager.blueBright),
                                              borderRadius: BorderRadius.circular(AppRadius.r4),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: ColorManager.red),
                                              borderRadius: BorderRadius.circular(AppRadius.r4),
                                            ),
                                          ),
                                        ),
                                        onSuggestionSelected: (StockDetailList stock) {
                                          readSalesServiceProvider!.setSalesStockId(int.parse(stock.stId.toString()));
                                          quantityController.text = "1";
                                          rateController.text = stock.stSalesRate.toString();

                                          calculateTotal();
                                          stockListController.text = stock.stDes.toString();
                                          readSalesServiceProvider!.setSalesStockId(int.parse(stock.stId.toString()));
                                          fieldFocusChange(context, stockFocusNode, qtyFocusNode);
                                        },
                                        itemBuilder: (context, StockDetailList stock) => ListTile(
                                          title: Text(
                                            stock.stDes.toString(),
                                            style: getRegularStyle(
                                              fontSize: FontSize.s12,
                                              color: ColorManager.black,
                                            ),
                                          ),
                                        ),
                                        suggestionsCallback: (watchTabletSetupServiceProvider!.brandId == null) ? getStockSuggestion : getStockSuggestionWithBrand,
                                      ),
                                      SizedBox(
                                        height: AppHeight.h6,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: AppHeight.h6),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              color: ColorManager.white,
                                              width: size.width * 0.2,
                                              child: TextFormField(
                                                style: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                                textInputAction: TextInputAction.done,
                                                onChanged: (_) {
                                                  calculateTotal();
                                                },
                                                controller: quantityController,
                                                keyboardType: TextInputType.number,
                                                focusNode: qtyFocusNode,
                                                onSaved: (newValue) {
                                                  fieldFocusChange(context, qtyFocusNode, rateFocusNode);
                                                },
                                                onEditingComplete: () {
                                                  fieldFocusChange(context, qtyFocusNode, rateFocusNode);
                                                },
                                                onFieldSubmitted: (value) {
                                                  fieldFocusChange(context, qtyFocusNode, rateFocusNode);
                                                },
                                                decoration: InputDecoration(
                                                    contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                                                    border: OutlineInputBorder(
                                                      borderSide: const BorderSide(width: 1.5, color: Colors.blue),
                                                      borderRadius: BorderRadius.circular(AppRadius.r4),
                                                    ),
                                                    labelText: 'Qty',
                                                    labelStyle: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                                    hintText: 'Qty',
                                                    hintStyle: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                                    floatingLabelBehavior: FloatingLabelBehavior.always),
                                              ),
                                            ),
                                            Container(
                                              color: ColorManager.white,
                                              width: size.width * 0.33,
                                              child: TextFormField(
                                                focusNode: rateFocusNode,
                                                onChanged: (_) {
                                                  calculateTotal();
                                                },
                                                controller: rateController,
                                                onTap: () {
                                                  if (rateController.text == '0.0') {
                                                    rateController.clear();
                                                  }
                                                },
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                    contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                                                    border: OutlineInputBorder(
                                                      borderSide: const BorderSide(width: 1.5, color: Colors.blue),
                                                      borderRadius: BorderRadius.circular(AppRadius.r4),
                                                    ),
                                                    labelText: 'Rate',
                                                    labelStyle: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                                    hintText: 'Rate',
                                                    hintStyle: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                                    floatingLabelBehavior: FloatingLabelBehavior.always),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(color: ColorManager.grey3, borderRadius: BorderRadius.circular(AppRadius.r4)),
                                              height: size.height * 0.07,
                                              width: size.width * 0.4,
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
                                                    watchSalesServiceProvider.salesAmount.toString(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: AppHeight.h6,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  (watchSalesServiceProvider.salesItemList.isEmpty)
                                      ? const SizedBox()
                                      : Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Sales Items',
                                            style: getBoldStyle(fontSize: FontSize.s18, color: ColorManager.black),
                                          ),
                                        ),
                                  Padding(
                                    padding: EdgeInsets.only(right: AppWidth.w6),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (stockListController.text.isNotEmpty && quantityController.text.isNotEmpty && rateController.text.isNotEmpty) {
                                          _onAddSales(readSalesServiceProvider!);
                                          watchTabletSetupServiceProvider!.brandId = null;
                                          watchTabletSetupServiceProvider!.brandList = null;
                                          barCodeController.clear();
                                          stockListController.clear();
                                          quantityController.clear();
                                          rateController.clear();
                                          readSalesServiceProvider!.salesAmount = 0.0;
                                          setState(() {});
                                        }

                                        FocusScope.of(context).requestFocus(FocusNode());
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            (stockListController.text.isNotEmpty && quantityController.text.isNotEmpty && rateController.text.isNotEmpty) ? Colors.green : Colors.green.shade200,
                                      ),
                                      child: Text(
                                        watchSalesServiceProvider.isAdd ? 'Add' : 'Update',
                                        style: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                },
                                child: SingleChildScrollView(
                                  child: SalesList(
                                    barCodeController: barCodeController,
                                    stockListController: stockListController,
                                    quantityController: quantityController,
                                    rateController: rateController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
        }),
      ),
      bottomSheet: readSalesServiceProvider!.showBottom
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
                        if (watchSalesServiceProvider.salesItemList.isNotEmpty) {
                          readSalesServiceProvider!.calculateSalesSubTotal(discount: double.parse(widget.discountController.text.isEmpty ? 0.toString() : widget.discountController.text));
                          Navigator.pop(context);
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
                        backgroundColor: MaterialStateProperty.all(watchSalesServiceProvider.salesItemList.isEmpty ? ColorManager.greenInActive : ColorManager.green),
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
          : SizedBox(height: AppHeight.h10, width: size.width),
    );
  }

  static void fieldFocusChange(BuildContext context, FocusNode currentFocusNode, FocusNode nextFocusNode) {
    currentFocusNode.unfocus();
    FocusScope.of(context).requestFocus(nextFocusNode);
  }

  void calculateTotal() {
    double rate = rateController.text.isEmpty ? 0.0 : double.parse(rateController.text);

    double qty = (quantityController.text.isEmpty) ? 0.0 : double.parse(quantityController.text);

    readSalesServiceProvider!.calculateTotalSalesAmount(qty, rate);
  }

  List<StockDetailList> getStockSuggestionWithBrand(String query) =>
      List.of(watchGetStockListProvider!.getStockListModel.data!).where((element) => element.stBrandId == watchTabletSetupServiceProvider!.brandId).where((StockDetailList stock) {
        final stockNameLower = stock.stDes!.toLowerCase();
        final queryLower = query.toLowerCase();
        return stockNameLower.contains(queryLower);
      }).toList();
  List<StockDetailList> getStockSuggestion(String query) => List.of(watchGetStockListProvider!.getStockListModel.data!).where((StockDetailList stock) {
        final stockNameLower = stock.stDes!.toLowerCase();
        final queryLower = query.toLowerCase();
        return stockNameLower.contains(queryLower);
      }).toList();

  _onAddSales(SalesServiceProvider readSalesServiceProvider) {
    SalesItemModel salesItemModel = SalesItemModel(
        traDStkId: readSalesServiceProvider.salesStockId!,
        traDStkName: stockListController.text,
        traDQty: double.parse(quantityController.text),
        traDRate: double.parse(rateController.text),
        traDAmount: readSalesServiceProvider.salesAmount);

    if (readSalesServiceProvider.salesStockId != null) {
      if (readSalesServiceProvider.isAdd == true) {
        if (readSalesServiceProvider.checkDuplicate(salesItemModel) == true) {
          Fluttertoast.cancel();
          Fluttertoast.showToast(
            msg: 'Item Already Added',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: ColorManager.error,
          );
        } else {
          readSalesServiceProvider.onAddSAles(salesItemModel);
          Fluttertoast.cancel();
          Fluttertoast.showToast(
            msg: 'Item Added',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: ColorManager.green,
          );
        }
      } else {
        readSalesServiceProvider.onUpdateSales(salesItemModel);
        Fluttertoast.cancel();
        Fluttertoast.showToast(
          msg: 'Item Updated',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: ColorManager.amber,
        );
      }
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: 'Stock Not Available',
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: ColorManager.error,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}
