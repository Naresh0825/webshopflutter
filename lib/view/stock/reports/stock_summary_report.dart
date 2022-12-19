import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/drawer/drawer_widget.dart';
import 'package:webshop/view/homepage/home_screen.dart';
import 'package:webshop/view/stock/model/stock_model.dart';
import 'package:webshop/view/stock/widgets/stock_summary_header_widget.dart';
import 'package:webshop/widgets/no_data_dialog.dart';

import 'providers/stock_summary_provider.dart';

class StockSummaryReport extends StatefulWidget {
  final bool? isDrawer;
  const StockSummaryReport({super.key, this.isDrawer});

  @override
  State<StockSummaryReport> createState() => _StockSummaryReportState();
}

class _StockSummaryReportState extends State<StockSummaryReport> {
  StockSummaryServiceProvider? readStockSummaryServiceProvider;
  TabletSetupServiceProvider? tabletSetupServiceProvider;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    tabletSetupServiceProvider = context.read<TabletSetupServiceProvider>();
    tabletSetupServiceProvider!.groupName = null;
    context.read<StockSummaryServiceProvider>().getStockSummary(
          DateTime.now().toIso8601String().split("T")[0],
          DateTime.now().toIso8601String().split("T")[0],
          0,
        );
  }

  @override
  Widget build(BuildContext context) {
    readStockSummaryServiceProvider = context.read<StockSummaryServiceProvider>();
    StockSummaryServiceProvider watchStockServiceProvider = context.watch<StockSummaryServiceProvider>();
    TabletSetupServiceProvider watchTabletSetupServiceProvider = context.watch<TabletSetupServiceProvider>();

    Size size = MediaQuery.of(context).size;

    readStockSummaryServiceProvider!.fromDate = readStockSummaryServiceProvider!.selectedFromDate.toString().split(" ")[0].toString();
    readStockSummaryServiceProvider!.toDate = readStockSummaryServiceProvider!.selectedToDate.toString().split(" ")[0].toString();

    Widget labelStartDate = InkWell(
      onTap: () {
        readStockSummaryServiceProvider!.selectStartDate(context);
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
            readStockSummaryServiceProvider!.fromDate.toString(),
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
        readStockSummaryServiceProvider!.selectEndDate(context);
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
            readStockSummaryServiceProvider!.toDate.toString(),
            style: getBoldStyle(
              fontSize: FontSize.s10,
              color: ColorManager.white,
            ),
          ),
        ),
      ),
    );
    return Consumer<ConnectivityProvider>(builder: (context, connectivity, child) {
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
                        child: DropdownButtonFormField<ItemGroupList>(
                          decoration: InputDecoration(
                            hintText: 'Select Item Group',
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
                          items: watchTabletSetupServiceProvider.tabletSetupModel.data!.itemGroupList!.map((item) {
                            return DropdownMenuItem<ItemGroupList>(
                              value: item,
                              child: Container(
                                margin: EdgeInsets.only(left: AppWidth.w1),
                                padding: EdgeInsets.only(left: AppWidth.w10),
                                height: size.height * 0.06,
                                width: double.infinity,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    item.itemGroupName.toString(),
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
                            watchTabletSetupServiceProvider.groupName = stock;
                            watchStockServiceProvider.stItemGroupId = watchTabletSetupServiceProvider.groupName!.itemGroupId;

                            context.read<StockSummaryServiceProvider>().getStockSummary(
                                  readStockSummaryServiceProvider!.fromDate.toString(),
                                  readStockSummaryServiceProvider!.toDate.toString(),
                                  int.parse(watchStockServiceProvider.stItemGroupId.toString()),
                                );
                          },
                          value: watchTabletSetupServiceProvider.groupName,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Spacer(),
                  ],
                ),
              ),
              body: Consumer<StockSummaryServiceProvider>(
                builder: (context, stock, child) {
                  if (stock.stockReportModel.data != null) {
                    watchStockServiceProvider.group = groupBy(stock.stockReportModel.data!, (val) => val.itemGroupName!);

                    watchStockServiceProvider.openBal =
                        watchStockServiceProvider.group.map((key, value) => MapEntry(key, value.fold(0, (a, b) => a + b.stkOVAL!)));
                    watchStockServiceProvider.purBal =
                        watchStockServiceProvider.group.map((key, value) => MapEntry(key, value.fold(0, (a, b) => a + b.stkPVAL!)));
                    watchStockServiceProvider.saleBal =
                        watchStockServiceProvider.group.map((key, value) => MapEntry(key, value.fold(0, (a, b) => a + b.stkIVAL!)));
                    watchStockServiceProvider.lossBal =
                        watchStockServiceProvider.group.map((key, value) => MapEntry(key, value.fold(0, (a, b) => a + b.stkLDVAL!)));
                    watchStockServiceProvider.closeBal =
                        watchStockServiceProvider.group.map((key, value) => MapEntry(key, value.fold(0, (a, b) => a + b.stkCVAL!)));
                  }

                  return SizedBox(
                    child: CustomScrollView(
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
                                    builder: (context) => const HomeScreen(),
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
                                      'Stock Summary',
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
                                watchTabletSetupServiceProvider.groupName = null;
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
                        (stock.stockReportModel.data == null)
                            ? SliverToBoxAdapter(
                                child: SizedBox(
                                  height: size.height,
                                  width: size.width,
                                  child: const Center(
                                    child: LoadingBox(),
                                  ),
                                ),
                              )
                            : (stock.stockReportModel.data!.isEmpty)
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
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: AppHeight.h2,
                                            ),
                                            Container(
                                              width: size.width * 2.6,
                                              height: size.height * 0.05,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: ColorManager.black,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    padding: EdgeInsets.only(left: AppWidth.w4),
                                                    width: size.width * 0.3,
                                                    child: Text(
                                                      'Grand Total:',
                                                      style: getBoldStyle(
                                                        fontSize: FontSize.s12,
                                                        color: ColorManager.black,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(left: AppWidth.w4),
                                                    width: size.width * 0.3,
                                                    child: Align(
                                                      alignment: Alignment.centerRight,
                                                      child: Text(
                                                        (watchStockServiceProvider.opTotal == 0.0)
                                                            ? ''
                                                            : watchStockServiceProvider.opTotal.toStringAsFixed(2),
                                                        style: getMediumStyle(
                                                          fontSize: FontSize.s12,
                                                          color: ColorManager.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(left: AppWidth.w4),
                                                    width: size.width * 0.3,
                                                    child: Align(
                                                      alignment: Alignment.centerRight,
                                                      child: Text(
                                                        (watchStockServiceProvider.purchaseTotal == 0.0)
                                                            ? ''
                                                            : watchStockServiceProvider.purchaseTotal.toStringAsFixed(2),
                                                        style: getMediumStyle(
                                                          fontSize: FontSize.s12,
                                                          color: ColorManager.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(left: AppWidth.w4),
                                                    width: size.width * 0.3,
                                                    child: Align(
                                                      alignment: Alignment.centerRight,
                                                      child: Text(
                                                        (watchStockServiceProvider.salesTotal == 0.0)
                                                            ? ''
                                                            : watchStockServiceProvider.salesTotal.toStringAsFixed(2),
                                                        style: getMediumStyle(
                                                          fontSize: FontSize.s12,
                                                          color: ColorManager.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(left: AppWidth.w4),
                                                    width: size.width * 0.3,
                                                    child: Align(
                                                      alignment: Alignment.centerRight,
                                                      child: Text(
                                                        (watchStockServiceProvider.lostTotal == 0.0)
                                                            ? ''
                                                            : watchStockServiceProvider.lostTotal.toString(),
                                                        style: getMediumStyle(
                                                          fontSize: FontSize.s12,
                                                          color: ColorManager.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(left: AppWidth.w4),
                                                    width: size.width * 0.3,
                                                    child: Align(
                                                      alignment: Alignment.centerRight,
                                                      child: Text(
                                                        (watchStockServiceProvider.closeTotal == 0.0)
                                                            ? ''
                                                            : watchStockServiceProvider.closeTotal.toStringAsFixed(2),
                                                        style: getMediumStyle(
                                                          fontSize: FontSize.s12,
                                                          color: ColorManager.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: size.width * 0.3,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const StockSummaryHeaderWidget(
                                              headerName: 'Stock',
                                            ),
                                            SizedBox(
                                              height: size.height * 0.55,
                                              width: size.width * 2.6,
                                              child: GroupedListView<StockDetail, String>(
                                                elements: stock.stockReportModel.data!,
                                                groupBy: (element) => element.itemGroupName!,
                                                groupSeparatorBuilder: (String value) => Container(
                                                  width: size.width * 2.6,
                                                  padding: EdgeInsets.all(AppWidth.w10),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets.only(left: AppWidth.w4),
                                                        width: size.width * 0.3,
                                                        child: Text(
                                                          value.toUpperCase(),
                                                          style: getBoldStyle(
                                                            fontSize: FontSize.s12,
                                                            color: ColorManager.black,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: size.width * 0.3,
                                                        padding: EdgeInsets.only(left: AppWidth.w4),
                                                        child: Align(
                                                          alignment: Alignment.centerRight,
                                                          child: Text(
                                                            (watchStockServiceProvider.openBal[value] == 0.0)
                                                                ? ''
                                                                : watchStockServiceProvider.openBal[value]!.toStringAsFixed(2).toUpperCase(),
                                                            style: getBoldStyle(
                                                              fontSize: FontSize.s10,
                                                              color: ColorManager.black,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: size.width * 0.3,
                                                        padding: EdgeInsets.only(left: AppWidth.w4),
                                                        child: Align(
                                                          alignment: Alignment.centerRight,
                                                          child: Text(
                                                            (watchStockServiceProvider.purBal[value] == 0.0)
                                                                ? ''
                                                                : watchStockServiceProvider.purBal[value]!.toStringAsFixed(2).toUpperCase(),
                                                            style: getBoldStyle(
                                                              fontSize: FontSize.s10,
                                                              color: ColorManager.black,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: size.width * 0.3,
                                                        padding: EdgeInsets.only(left: AppWidth.w4),
                                                        child: Align(
                                                          alignment: Alignment.centerRight,
                                                          child: Text(
                                                            (watchStockServiceProvider.saleBal[value] == 0.0)
                                                                ? ''
                                                                : watchStockServiceProvider.saleBal[value]!.toStringAsFixed(2).toUpperCase(),
                                                            style: getBoldStyle(
                                                              fontSize: FontSize.s10,
                                                              color: ColorManager.black,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: size.width * 0.3,
                                                        padding: EdgeInsets.only(left: AppWidth.w4),
                                                        child: Align(
                                                          alignment: Alignment.centerRight,
                                                          child: Text(
                                                            (watchStockServiceProvider.lossBal[value] == 0.0)
                                                                ? ''
                                                                : watchStockServiceProvider.lossBal[value]!.toStringAsFixed(2).toUpperCase(),
                                                            style: getBoldStyle(
                                                              fontSize: FontSize.s10,
                                                              color: ColorManager.black,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: size.width * 0.3,
                                                        padding: EdgeInsets.only(left: AppWidth.w4),
                                                        child: Align(
                                                          alignment: Alignment.centerRight,
                                                          child: Text(
                                                            (watchStockServiceProvider.closeBal[value] == 0.0)
                                                                ? ''
                                                                : watchStockServiceProvider.closeBal[value]!.toStringAsFixed(2).toUpperCase(),
                                                            style: getBoldStyle(
                                                              fontSize: FontSize.s10,
                                                              color: ColorManager.black,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: size.width * 0.3,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                itemComparator: (item1, item2) => item1.stDes!.compareTo(item2.stDes!),
                                                groupComparator: (value1, value2) => value1.compareTo(value2),
                                                itemBuilder: (context, element) {
                                                  return Container(
                                                    height: size.height * 0.05,
                                                    padding: EdgeInsets.only(left: AppWidth.w4),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: ColorManager.black,
                                                        width: AppWidth.w0,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: <Widget>[
                                                        Container(
                                                          padding: EdgeInsets.only(left: AppWidth.w4),
                                                          width: size.width * 0.3,
                                                          child: Text(
                                                            element.stDes.toString(),
                                                            style: getMediumStyle(
                                                              fontSize: FontSize.s10,
                                                              color: ColorManager.black,
                                                            ),
                                                          ),
                                                        ),
                                                        VerticalDivider(
                                                          color: ColorManager.black,
                                                          thickness: 1.0,
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.only(left: AppWidth.w2),
                                                          width: size.width * 0.1,
                                                          child: Align(
                                                            alignment: Alignment.centerRight,
                                                            child: Text(
                                                              (element.stkOBAL == 0.0) ? '' : element.stkOBAL.toString(),
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
                                                              (element.stkOVAL == 0.0) ? '' : element.stkOVAL.toString(),
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
                                                          width: size.width * 0.1,
                                                          child: Align(
                                                            alignment: Alignment.centerRight,
                                                            child: Text(
                                                              (element.stkPQTY == 0.0) ? '' : element.stkPQTY.toString(),
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
                                                              (element.stkPVAL == 0.0) ? '' : element.stkPVAL!.toStringAsFixed(2),
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
                                                          width: size.width * 0.1,
                                                          child: Align(
                                                            alignment: Alignment.centerRight,
                                                            child: Text(
                                                              (element.stkIQTY == 0.0) ? '' : element.stkIQTY.toString(),
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
                                                          width: size.width * 0.22,
                                                          child: Align(
                                                            alignment: Alignment.centerRight,
                                                            child: Text(
                                                              (element.stkIVAL == 0.0) ? '' : element.stkIVAL!.toStringAsFixed(2),
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
                                                          width: size.width * 0.1,
                                                          child: Align(
                                                            alignment: Alignment.centerRight,
                                                            child: Text(
                                                              (element.stkLDQTY == 0.0) ? '' : element.stkLDQTY.toString(),
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
                                                              (element.stkLDVAL == 0.0) ? '' : element.stkLDVAL!.toStringAsFixed(2),
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
                                                          width: size.width * 0.1,
                                                          child: Align(
                                                            alignment: Alignment.centerRight,
                                                            child: Text(
                                                              (element.stkCBAL == 0.0) ? '' : element.stkCBAL.toString(),
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
                                                              (element.stkCVAL == 0.0) ? '' : element.stkCVAL!.toStringAsFixed(2),
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
                                                          width: size.width * 0.3,
                                                          child: Text(
                                                            (element.stkRate == 0.0) ? '' : element.stkRate!.toStringAsFixed(2),
                                                            style: getMediumStyle(
                                                              fontSize: FontSize.s10,
                                                              color: ColorManager.black,
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
                                      ),
                                    ),
                                  ),
                      ],
                    ),
                  );
                },
              ),
            );
    });
  }
}
