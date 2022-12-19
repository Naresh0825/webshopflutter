// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/commons/font_family.dart';
import 'package:webshop/view/drawer/drawer_widget.dart';
import 'package:webshop/view/homepage/home_screen.dart';
import 'package:webshop/view/stock/model/stock_details_page_model.dart';
import 'package:webshop/view/stock/services/stock_details_provider.dart';
import 'package:webshop/view/stock/stock_page.dart';
import 'package:webshop/widgets/no_data_dialog.dart';
import 'package:webshop/widgets/stock_details_header_widget.dart';

class StockDetailReport extends StatefulWidget {
  int? stId;
  final bool? isDrawer;
  StockDetailReport({super.key, this.stId, this.isDrawer});

  @override
  State<StockDetailReport> createState() => _StockDetailReportState();
}

class _StockDetailReportState extends State<StockDetailReport> {
  StockDetailServiceProvider? readStockDetailServiceProvider;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    TabletSetupServiceProvider tabletSetupServiceProvider = context.read<TabletSetupServiceProvider>();
    tabletSetupServiceProvider.stockList = null;

    if (widget.stId != null) {
      context.read<StockDetailServiceProvider>().getStockDetails(
            DateTime.now().subtract(const Duration(days: 7)).toIso8601String().split("T")[0],
            DateTime.now().toIso8601String().split("T")[0],
            int.parse(widget.stId.toString()),
          );
      tabletSetupServiceProvider.selectStock(int.parse(widget.stId.toString()));
    } else {
      context.read<StockDetailServiceProvider>().getStockDetails(
            DateTime.now().subtract(const Duration(days: 7)).toIso8601String().split("T")[0],
            DateTime.now().toIso8601String().split("T")[0],
            null,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    readStockDetailServiceProvider = context.read<StockDetailServiceProvider>();
    StockDetailServiceProvider watchStockDetailServiceProvider = context.watch<StockDetailServiceProvider>();
    TabletSetupServiceProvider watchTabletSetupServiceProvider = context.watch<TabletSetupServiceProvider>();

    readStockDetailServiceProvider!.fromDate = readStockDetailServiceProvider!.selectedFromDate.toString().split(" ")[0].toString();
    readStockDetailServiceProvider!.toDate = readStockDetailServiceProvider!.selectedToDate.toString().split(" ")[0].toString();

    Widget labelStartDate = InkWell(
      onTap: () {
        readStockDetailServiceProvider!.selectStartDate(context);
      },
      child: Container(
        height: size.height * 0.035,
        width: size.width * 0.25,
        padding: EdgeInsets.all(AppHeight.h4),
        decoration: BoxDecoration(
          border: Border.all(
            color: ColorManager.white,
          ),
          borderRadius: BorderRadius.circular(AppRadius.r10),
        ),
        child: Center(
          child: Text(
            readStockDetailServiceProvider!.fromDate.toString(),
            style: getBoldStyle(
              fontSize: FontSize.s10,
              color: ColorManager.white,
            ),
          ),
        ),
      ),
    );
    Widget labelEndDate = InkWell(
      onTap: () {
        readStockDetailServiceProvider!.selectEndDate(context);
      },
      child: Container(
        height: size.height * 0.035,
        width: size.width * 0.25,
        padding: EdgeInsets.all(AppHeight.h4),
        decoration: BoxDecoration(
          border: Border.all(
            color: ColorManager.white,
          ),
          borderRadius: BorderRadius.circular(AppRadius.r10),
        ),
        child: Center(
          child: Text(
            readStockDetailServiceProvider!.toDate.toString(),
            style: getBoldStyle(
              fontSize: FontSize.s10,
              color: ColorManager.white,
            ),
          ),
        ),
      ),
    );

    return Consumer<ConnectivityProvider>(
      builder: (context, connectivity, child) {
        return (connectivity.isOnline == false)
            ? const NoInternet()
            : Scaffold(
                key: scaffoldState,
                drawer: (widget.isDrawer == true) ? const DrawerWidget() : Container(),
                bottomSheet: SizedBox(
                  height: size.height * 0.12,
                  child: Row(
                    children: [
                      const Spacer(),
                      SingleChildScrollView(
                        child: SizedBox(
                          width: size.width * 0.9,
                          height: size.height * 0.08,
                          child: DropdownButtonFormField<StockList>(
                            decoration: InputDecoration(
                              hintText: 'Select Stock',
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
                            items: watchTabletSetupServiceProvider.tabletSetupModel.data!.stockList!.map((item) {
                              return DropdownMenuItem<StockList>(
                                value: item,
                                child: Container(
                                  margin: EdgeInsets.only(left: AppWidth.w1),
                                  padding: EdgeInsets.only(left: AppWidth.w10),
                                  height: size.height * 0.06,
                                  width: double.infinity,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      item.stDes.toString(),
                                      style: getRegularStyle(
                                        fontSize: FontSize.s12,
                                        color: ColorManager.blackOpacity54,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (stock) {
                              watchTabletSetupServiceProvider.stockList = stock;
                              watchStockDetailServiceProvider.stId = watchTabletSetupServiceProvider.stockList!.stId;

                              context.read<StockDetailServiceProvider>().getStockDetails(
                                    DateTime.now().toIso8601String().split("T")[0],
                                    DateTime.now().toIso8601String().split("T")[0],
                                    watchStockDetailServiceProvider.stId,
                                  );
                            },
                            value: watchTabletSetupServiceProvider.stockList,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Spacer(),
                    ],
                  ),
                ),
                body: Consumer<StockDetailServiceProvider>(
                  builder: (context, stock, child) {
                    if (stock.stockDetailModel.data != null) {
                      stock.group = groupBy(stock.stockDetailModel.data!, (val) => val.stDes!);

                      stock.purchaseQtyMap = stock.group.map((key, value) => MapEntry(key, value.fold(0, (a, b) => a + b.stkPqty!)));
                      stock.saleQtyMap = stock.group.map((key, value) => MapEntry(key, value.fold(0, (a, b) => a + b.stkIqty!)));
                      stock.lostQtyMap = stock.group.map((key, value) => MapEntry(key, value.fold(0, (a, b) => a + b.stkLdqty!)));

                      stock.totalRateMap = stock.group.map((key, value) => MapEntry(key, value.fold(0, (a, b) => a + b.stkRate!)));
                    }
                    return CustomScrollView(
                      slivers: <Widget>[
                        SliverAppBar(
                          backgroundColor: Colors.blue.withOpacity(0.7),
                          leading: IconButton(
                            onPressed: () {
                              if (widget.isDrawer == true) {
                                scaffoldState.currentState!.openDrawer();
                              } else {
                                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const StockPage(),
                                  ),
                                  (route) => false,
                                );
                              }
                            },
                            icon: (widget.isDrawer == true) ? const Icon(Icons.menu) : const Icon(Icons.arrow_back),
                          ),
                          pinned: false,
                          expandedHeight: 120,
                          floating: true,
                          flexibleSpace: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  ColorManager.blue,
                                  ColorManager.blueBright,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                tileMode: TileMode.clamp,
                              ),
                            ),
                            child: FlexibleSpaceBar(
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Stock Details',
                                      style: getMediumStyle(
                                        fontSize: FontSize.s18,
                                        color: ColorManager.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: AppHeight.h10,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: AppWidth.w20),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          labelStartDate,
                                          Text(
                                            '-',
                                            style: getMediumStyle(fontSize: FontSize.s20, color: ColorManager.white),
                                          ),
                                          labelEndDate
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              centerTitle: true,
                            ),
                          ),
                          actions: [
                            IconButton(
                              onPressed: () {
                                watchTabletSetupServiceProvider.stockList = null;
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HomeScreen(),
                                    ),
                                    (route) => false);
                              },
                              icon: FaIcon(
                                FontAwesomeIcons.house,
                                size: FontSize.s20,
                              ),
                            ),
                          ],
                        ),
                        (stock.stockDetailModel.data == null)
                            ? SliverToBoxAdapter(
                                child: SizedBox(
                                  height: size.height,
                                  width: size.width,
                                  child: const Center(
                                    child: LoadingBox(),
                                  ),
                                ),
                              )
                            : (stock.stockDetailModel.data!.isEmpty)
                                ? SliverToBoxAdapter(
                                    child: SizedBox(
                                      height: size.height,
                                      width: size.width,
                                      child: const Center(
                                        child: NoDataErrorBox(),
                                      ),
                                    ),
                                  )
                                : SliverToBoxAdapter(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: ColumnWidget(size: size, stock: stock),
                                      ),
                                    ),
                                  ),
                      ],
                    );
                  },
                ),
              );
      },
    );
  }
}

class ColumnWidget extends StatelessWidget {
  final Size size;
  final StockDetailServiceProvider stock;
  const ColumnWidget({super.key, required this.size, required this.stock});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: AppHeight.h2,
        ),
        SizedBox(
          height: size.height * 0.65,
          width: size.width * 2.5,
          child: GroupedListView<DetailsStock, String>(
            elements: stock.stockDetailModel.data!,
            groupBy: (element) => element.stDes!,
            groupSeparatorBuilder: (String value) {
              stock.totalQty = 0.0;
              stock.balance = 0.0;

              log(stock.totalRateMap[value].toString());
              //  stock.totallength = stock.totalRateMap.

              stock.currentQtyMap[value] = stock.purchaseQtyMap[value]! - stock.saleQtyMap[value]! - stock.lostQtyMap[value]!;
              stock.currentRateMap[value] = stock.totalRateMap[value]! / stock.totalRateMap.length;
              stock.currentTotalMap[value] = stock.currentQtyMap[value]! * stock.currentRateMap[value]!;
              return Container(
                width: size.width,
                padding: EdgeInsets.only(top: AppHeight.h10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: AppWidth.w4),
                          child: Text(
                            'Item',
                            style: getBoldStyle(
                              fontSize: FontSize.s12,
                              color: ColorManager.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: AppWidth.w10,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: AppWidth.w4),
                          width: size.width * 0.3,
                          child: Text(
                            value.toUpperCase(),
                            style: TextStyle(
                              fontSize: FontSize.s12,
                              color: ColorManager.black,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeightManager.bold,
                              fontFamily: FontConstants.fontFamily,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppHeight.h10,
                    ),
                    Row(
                      children: [
                        Text(
                          'Current',
                          style: getRegularStyle(
                            fontSize: FontSize.s12,
                            color: ColorManager.black,
                          ),
                        ),
                        SizedBox(
                          width: AppWidth.w10,
                        ),
                        Text(
                          'Qty',
                          style: getRegularStyle(
                            fontSize: FontSize.s12,
                            color: ColorManager.black,
                          ),
                        ),
                        SizedBox(
                          width: AppWidth.w10,
                        ),
                        Text(
                          (stock.currentQtyMap[value] == 0.0) ? '' : '${stock.currentQtyMap[value]}',
                          style: getRegularStyle(
                            fontSize: FontSize.s12,
                            color: ColorManager.black,
                          ),
                        ),
                        SizedBox(
                          width: AppWidth.w10,
                        ),
                        Text(
                          'Rate',
                          style: getRegularStyle(
                            fontSize: FontSize.s12,
                            color: ColorManager.black,
                          ),
                        ),
                        SizedBox(
                          width: AppWidth.w10,
                        ),
                        Text(
                          (stock.currentRateMap[value] == 0.0) ? '' : stock.currentRateMap[value]!.toStringAsFixed(2),
                          style: getRegularStyle(
                            fontSize: FontSize.s12,
                            color: ColorManager.black,
                          ),
                        ),
                        SizedBox(
                          width: AppWidth.w10,
                        ),
                        Text(
                          'Amount',
                          style: getRegularStyle(
                            fontSize: FontSize.s12,
                            color: ColorManager.black,
                          ),
                        ),
                        SizedBox(
                          width: AppWidth.w10,
                        ),
                        Text(
                          (stock.currentTotalMap[value] == 0.0) ? '' : stock.currentTotalMap[value]!.toStringAsFixed(2),
                          style: getRegularStyle(
                            fontSize: FontSize.s12,
                            color: ColorManager.black,
                          ),
                        ),
                        SizedBox(
                          width: AppWidth.w10,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppHeight.h10,
                    ),
                    const StockDetailsHeaderWidget(),
                    // SizedBox(
                    //   height: AppHeight.h10,
                    // ),
                    Container(
                      height: size.height * 0.05,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorManager.black,
                          width: AppWidth.w0,
                        ),
                      ),
                      child: Row(
                        //    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: AppWidth.w4),
                            width: size.width * 0.2,
                          ),
                          VerticalDivider(
                            color: ColorManager.black,
                            thickness: 1.0,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: AppWidth.w2),
                            width: size.width * 0.25,
                          ),
                          VerticalDivider(
                            color: ColorManager.black,
                            thickness: 1.0,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: AppWidth.w2),
                            width: size.width * 0.15,
                          ),
                          VerticalDivider(
                            color: ColorManager.black,
                            thickness: 1.0,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: AppWidth.w2),
                            width: size.width * 0.17,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                (stock.purchaseQtyMap[value] == 0.0) ? '' : stock.purchaseQtyMap[value].toString(),
                                style: getBoldStyle(
                                  fontSize: FontSize.s10,
                                  color: ColorManager.black,
                                ),
                              ),
                            ),
                          ),
                          VerticalDivider(
                            color: ColorManager.black,
                            thickness: 1.0,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: AppWidth.w2),
                            width: size.width * 0.25,
                          ),
                          VerticalDivider(
                            color: ColorManager.black,
                            thickness: 1.0,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: AppWidth.w2),
                            width: size.width * 0.15,
                          ),
                          VerticalDivider(
                            color: ColorManager.black,
                            thickness: 1.0,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: AppWidth.w2),
                            width: size.width * 0.17,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                (stock.saleQtyMap[value] == 0.0) ? '' : stock.saleQtyMap[value].toString(),
                                style: getBoldStyle(
                                  fontSize: FontSize.s10,
                                  color: ColorManager.black,
                                ),
                              ),
                            ),
                          ),
                          VerticalDivider(
                            color: ColorManager.black,
                            thickness: 1.0,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: AppWidth.w2),
                            width: size.width * 0.15,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                (stock.lostQtyMap[value] == 0.0) ? '' : stock.lostQtyMap[value].toString(),
                                style: getBoldStyle(
                                  fontSize: FontSize.s10,
                                  color: ColorManager.black,
                                ),
                              ),
                            ),
                          ),
                          VerticalDivider(
                            color: ColorManager.black,
                            thickness: 1.0,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: AppWidth.w2),
                            width: size.width * 0.2,
                          ),
                          VerticalDivider(
                            color: ColorManager.black,
                            thickness: 1.0,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: AppWidth.w2),
                            width: size.width * 0.2,
                          ),
                          VerticalDivider(
                            color: ColorManager.black,
                            thickness: 1.0,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: AppWidth.w2),
                            width: size.width * 0.2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            itemComparator: (item1, item2) => item1.stkDate!.compareTo(item2.stkDate!),
            groupComparator: (value1, value2) => value1.compareTo(value2),
            itemBuilder: (context, element) {
              stock.calculateTotalQty(element);
              stock.calculateBalance(element);
              return Container(
                height: size.height * 0.05,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ColorManager.black,
                    width: AppWidth.w0,
                  ),
                ),
                child: Row(
                  //    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: AppWidth.w4),
                      width: size.width * 0.2,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          (element.stkDate == null) ? '' : element.stkDate.toString().split("T")[0],
                          style: getMediumStyle(
                            fontSize: FontSize.s10,
                            color: ColorManager.black,
                          ),
                        ),
                      ),
                    ),
                    VerticalDivider(
                      color: ColorManager.black,
                      thickness: 1.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: AppWidth.w2),
                      width: size.width * 0.25,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          element.supplier.toString(),
                          style: getMediumStyle(
                            fontSize: FontSize.s10,
                            color: ColorManager.black,
                          ),
                        ),
                      ),
                    ),
                    VerticalDivider(
                      color: ColorManager.black,
                      thickness: 1.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: AppWidth.w2),
                      width: size.width * 0.15,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          (element.purBillNo == '') ? '' : element.purBillNo.toString(),
                          style: getMediumStyle(
                            fontSize: FontSize.s10,
                            color: ColorManager.black,
                          ),
                        ),
                      ),
                    ),
                    VerticalDivider(
                      color: ColorManager.black,
                      thickness: 1.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: AppWidth.w2),
                      width: size.width * 0.17,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          (element.stkPqty == 0.0) ? '' : element.stkPqty.toString(),
                          style: getMediumStyle(
                            fontSize: FontSize.s10,
                            color: ColorManager.black,
                          ),
                        ),
                      ),
                    ),
                    VerticalDivider(
                      color: ColorManager.black,
                      thickness: 1.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: AppWidth.w2),
                      width: size.width * 0.25,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          (element.customer == '') ? '' : element.customer.toString(),
                          style: getMediumStyle(
                            fontSize: FontSize.s10,
                            color: ColorManager.black,
                          ),
                        ),
                      ),
                    ),
                    VerticalDivider(
                      color: ColorManager.black,
                      thickness: 1.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: AppWidth.w2),
                      width: size.width * 0.15,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          (element.issueNo == '') ? '' : element.issueNo.toString(),
                          style: getMediumStyle(
                            fontSize: FontSize.s10,
                            color: ColorManager.black,
                          ),
                        ),
                      ),
                    ),
                    VerticalDivider(
                      color: ColorManager.black,
                      thickness: 1.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: AppWidth.w2),
                      width: size.width * 0.17,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          (element.stkIqty == 0.0) ? '' : element.stkIqty.toString(),
                          style: getMediumStyle(
                            fontSize: FontSize.s10,
                            color: ColorManager.black,
                          ),
                        ),
                      ),
                    ),
                    VerticalDivider(
                      color: ColorManager.black,
                      thickness: 1.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: AppWidth.w2),
                      width: size.width * 0.15,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          (element.stkLdqty == 0.0) ? '' : element.stkLdqty.toString(),
                          style: getMediumStyle(
                            fontSize: FontSize.s10,
                            color: ColorManager.black,
                          ),
                        ),
                      ),
                    ),
                    VerticalDivider(
                      color: ColorManager.black,
                      thickness: 1.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: AppWidth.w2),
                      width: size.width * 0.2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          stock.totalQty.toString(),
                          style: getMediumStyle(
                            fontSize: FontSize.s10,
                            color: ColorManager.black,
                          ),
                        ),
                      ),
                    ),
                    VerticalDivider(
                      color: ColorManager.black,
                      thickness: 1.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: AppWidth.w2),
                      width: size.width * 0.2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          (element.stkRate == 0.0) ? '' : element.stkRate.toString(),
                          style: getMediumStyle(
                            fontSize: FontSize.s10,
                            color: ColorManager.black,
                          ),
                        ),
                      ),
                    ),
                    VerticalDivider(
                      color: ColorManager.black,
                      thickness: 1.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: AppWidth.w2),
                      width: size.width * 0.2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          (stock.balance == 0.0) ? '' : stock.balance.toString(),
                          style: getMediumStyle(
                            fontSize: FontSize.s10,
                            color: ColorManager.black,
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
    );
  }
}
