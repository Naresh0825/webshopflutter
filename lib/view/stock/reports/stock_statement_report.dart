import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/drawer/drawer_widget.dart';
import 'package:webshop/view/homepage/home_screen.dart';
import 'package:webshop/view/stock/model/stock_model.dart';
import 'package:webshop/view/stock/widgets/stock_summary_header_widget.dart';
import 'package:webshop/widgets/no_data_dialog.dart';

import 'providers/stock_statement_provider.dart';

class StockStatementReport extends StatefulWidget {
  final bool? isDrawer;
  const StockStatementReport({super.key, this.isDrawer});

  @override
  State<StockStatementReport> createState() => _StockStatementReportState();
}

class _StockStatementReportState extends State<StockStatementReport> {
  StockStatementServiceProvider? readStockStatementServiceProvider;
  TabletSetupServiceProvider? tabletSetupServiceProvider;

  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    tabletSetupServiceProvider = context.read<TabletSetupServiceProvider>();
    tabletSetupServiceProvider!.groupName = null;
    tabletSetupServiceProvider!.stockList = null;

    context.read<StockStatementServiceProvider>().getStockStatement(
          DateTime.now().toIso8601String().split("T")[0],
          DateTime.now().toIso8601String().split("T")[0],
          null,
          null,
        );
  }

  Future<void> refresh() async {
    readStockStatementServiceProvider!.fromDate = DateTime.now().toIso8601String().split("T")[0];
    readStockStatementServiceProvider!.toDate = DateTime.now().toIso8601String().split("T")[0];
    readStockStatementServiceProvider!.stId = null;
    readStockStatementServiceProvider!.stItemGroupId = null;

    tabletSetupServiceProvider!.groupName = null;
    tabletSetupServiceProvider!.stockList = null;
    await context.read<StockStatementServiceProvider>().getStockStatement(
          DateTime.now().toIso8601String().split("T")[0],
          DateTime.now().toIso8601String().split("T")[0],
          null,
          null,
        );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    readStockStatementServiceProvider = context.read<StockStatementServiceProvider>();
    StockStatementServiceProvider watchStockStatementServiceProvider = context.watch<StockStatementServiceProvider>();
    TabletSetupServiceProvider watchTabletSetupServiceProvider = context.watch<TabletSetupServiceProvider>();

    readStockStatementServiceProvider!.fromDate = readStockStatementServiceProvider!.selectedFromDate.toString().split(" ")[0].toString();
    readStockStatementServiceProvider!.toDate = readStockStatementServiceProvider!.selectedToDate.toString().split(" ")[0].toString();

    Widget labelStartDate = InkWell(
      onTap: () {
        readStockStatementServiceProvider!.selectStartDate(context);
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
            readStockStatementServiceProvider!.fromDate.toString(),
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
        readStockStatementServiceProvider!.selectEndDate(context);
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
            readStockStatementServiceProvider!.toDate.toString(),
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SingleChildScrollView(
                      child: SizedBox(
                        width: size.width * 0.45,
                        height: size.height * 0.08,
                        child: DropdownButtonFormField<ItemGroupList>(
                          decoration: InputDecoration(
                            hintText: 'Select Group',
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
                            watchStockStatementServiceProvider.stItemGroupId = watchTabletSetupServiceProvider.groupName!.itemGroupId;

                            context.read<StockStatementServiceProvider>().getStockStatement(
                                  watchStockStatementServiceProvider.fromDate.toString(),
                                  watchStockStatementServiceProvider.toDate.toString(),
                                  watchStockStatementServiceProvider.stId,
                                  watchStockStatementServiceProvider.stItemGroupId,
                                );
                          },
                          value: watchTabletSetupServiceProvider.groupName,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: SizedBox(
                        width: size.width * 0.45,
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
                            watchStockStatementServiceProvider.stId = watchTabletSetupServiceProvider.stockList!.stId;

                            context.read<StockStatementServiceProvider>().getStockStatement(
                                  watchStockStatementServiceProvider.fromDate.toString(),
                                  watchStockStatementServiceProvider.toDate.toString(),
                                  watchStockStatementServiceProvider.stId,
                                  watchStockStatementServiceProvider.stItemGroupId,
                                );
                          },
                          value: watchTabletSetupServiceProvider.stockList,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              body: Consumer<StockStatementServiceProvider>(
                builder: (context, stock, child) {
                  if (stock.stockReportModel.data != null) {
                    if (watchStockStatementServiceProvider.boolValue == 'i') {
                      watchStockStatementServiceProvider.group = groupBy(stock.stockReportModel.data!, (val) => val.stDes!);
                    } else if (watchStockStatementServiceProvider.boolValue == 'd') {
                      watchStockStatementServiceProvider.group = groupBy(stock.stockReportModel.data!, (val) => val.stkDate!);
                    }

                    watchStockStatementServiceProvider.openBal =
                        watchStockStatementServiceProvider.group.map((key, value) => MapEntry(key, value.fold(0, (a, b) => a + b.stkOVAL!)));
                    watchStockStatementServiceProvider.purBal =
                        watchStockStatementServiceProvider.group.map((key, value) => MapEntry(key, value.fold(0, (a, b) => a + b.stkPVAL!)));
                    watchStockStatementServiceProvider.saleBal =
                        watchStockStatementServiceProvider.group.map((key, value) => MapEntry(key, value.fold(0, (a, b) => a + b.stkIVAL!)));
                    watchStockStatementServiceProvider.lossBal =
                        watchStockStatementServiceProvider.group.map((key, value) => MapEntry(key, value.fold(0, (a, b) => a + b.stkLDVAL!)));
                    watchStockStatementServiceProvider.closeBal =
                        watchStockStatementServiceProvider.group.map((key, value) => MapEntry(key, value.fold(0, (a, b) => a + b.stkCVAL!)));
                  }
                  return SizedBox(
                    child: RefreshIndicator(
                      onRefresh: refresh,
                      child: CustomScrollView(
                        slivers: [
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
                            actions: [
                              IconButton(
                                onPressed: () {
                                  watchTabletSetupServiceProvider.groupName = null;
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
                              PopupMenuButton(
                                icon: Icon(
                                  Icons.more_vert,
                                  size: FontSize.s20,
                                  color: ColorManager.white,
                                ),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: Text(
                                      'Choose any Options',
                                      style: getBoldStyle(
                                        fontSize: FontSize.s16,
                                        color: ColorManager.black,
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    child: Divider(
                                      color: ColorManager.black,
                                    ),
                                  ),
                                  PopupMenuItem(
                                    child: ListTile(
                                      title: Text(
                                        'View Date Wise',
                                        style: getRegularStyle(
                                          fontSize: FontSize.s14,
                                          color: ColorManager.black,
                                        ),
                                      ),
                                      leading: Radio(
                                        value: 'd',
                                        groupValue: watchStockStatementServiceProvider.boolValue,
                                        onChanged: (value) {
                                          watchStockStatementServiceProvider.changeBoolValue(value.toString());
                                          Navigator.pop(context);
                                        },
                                        activeColor: Colors.green,
                                        toggleable: true,
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    child: ListTile(
                                      title: Text(
                                        'View Item Wise',
                                        style: getRegularStyle(
                                          fontSize: FontSize.s14,
                                          color: ColorManager.black,
                                        ),
                                      ),
                                      leading: Radio(
                                        value: 'i',
                                        groupValue: watchStockStatementServiceProvider.boolValue,
                                        onChanged: (value) {
                                          watchStockStatementServiceProvider.changeBoolValue(value.toString());
                                          Navigator.pop(context);
                                        },
                                        activeColor: Colors.green,
                                        toggleable: true,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
                                        'Stock Statement',
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
                                                          (watchStockStatementServiceProvider.opTotal == 0.0)
                                                              ? ''
                                                              : watchStockStatementServiceProvider.opTotal.toStringAsFixed(2),
                                                          style: getMediumStyle(
                                                            fontSize: FontSize.s10,
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
                                                          (watchStockStatementServiceProvider.purchaseTotal == 0.0)
                                                              ? ''
                                                              : watchStockStatementServiceProvider.purchaseTotal.toStringAsFixed(2),
                                                          style: getMediumStyle(
                                                            fontSize: FontSize.s10,
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
                                                          (watchStockStatementServiceProvider.salesTotal == 0.0)
                                                              ? ''
                                                              : watchStockStatementServiceProvider.salesTotal.toStringAsFixed(2),
                                                          style: getMediumStyle(
                                                            fontSize: FontSize.s10,
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
                                                          (watchStockStatementServiceProvider.lostTotal == 0.0)
                                                              ? ''
                                                              : watchStockStatementServiceProvider.lostTotal.toStringAsFixed(2),
                                                          style: getMediumStyle(
                                                            fontSize: FontSize.s10,
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
                                                          (watchStockStatementServiceProvider.closeTotal == 0.0)
                                                              ? ''
                                                              : watchStockStatementServiceProvider.closeTotal.toStringAsFixed(2),
                                                          style: getMediumStyle(
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
                                              StockSummaryHeaderWidget(
                                                headerName: (watchStockStatementServiceProvider.boolValue == 'i') ? 'Date' : 'Stock',
                                              ),
                                              SizedBox(
                                                height: size.height * 0.55,
                                                width: size.width * 2.6,
                                                child: GroupedListView<StockDetail, String>(
                                                  elements: stock.stockReportModel.data!,
                                                  groupBy: (element) =>
                                                      (watchStockStatementServiceProvider.boolValue == 'i') ? element.stDes! : element.stkDate,
                                                  groupSeparatorBuilder: (String value) => Container(
                                                    width: size.width,
                                                    padding: EdgeInsets.all(AppWidth.w10),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.only(left: AppWidth.w4),
                                                          width: size.width * 0.3,
                                                          child: Text(
                                                            (watchStockStatementServiceProvider.boolValue == 'i')
                                                                ? value.toUpperCase()
                                                                : value.toUpperCase().split("T")[0],
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
                                                              (watchStockStatementServiceProvider.openBal[value] == 0.0)
                                                                  ? ''
                                                                  : '${watchStockStatementServiceProvider.openBal[value]}',
                                                              style: getBoldStyle(
                                                                fontSize: FontSize.s12,
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
                                                              (watchStockStatementServiceProvider.purBal[value] == 0.0)
                                                                  ? ''
                                                                  : '${watchStockStatementServiceProvider.purBal[value]}',
                                                              style: getBoldStyle(
                                                                fontSize: FontSize.s12,
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
                                                              (watchStockStatementServiceProvider.saleBal[value] == 0.0)
                                                                  ? ''
                                                                  : '${watchStockStatementServiceProvider.saleBal[value]}',
                                                              style: getBoldStyle(
                                                                fontSize: FontSize.s12,
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
                                                              (watchStockStatementServiceProvider.lossBal[value] == 0.0)
                                                                  ? ''
                                                                  : '${watchStockStatementServiceProvider.lossBal[value]}',
                                                              style: getBoldStyle(
                                                                fontSize: FontSize.s12,
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
                                                              (watchStockStatementServiceProvider.closeBal[value] == 0.0)
                                                                  ? ''
                                                                  : '${watchStockStatementServiceProvider.closeBal[value]}',
                                                              style: getBoldStyle(
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
                                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: <Widget>[
                                                          Container(
                                                            padding: EdgeInsets.only(left: AppWidth.w4),
                                                            width: size.width * 0.28,
                                                            child: Text(
                                                              (watchStockStatementServiceProvider.boolValue == 'd')
                                                                  ? element.stDes.toString()
                                                                  : element.stkDate.toString().split("T")[0],
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
                                                            width: size.width * 0.22,
                                                            child: Align(
                                                              alignment: Alignment.centerRight,
                                                              child: Text(
                                                                (element.stkOVAL == 0.0) ? '' : element.stkOVAL!.toStringAsFixed(2),
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
                                                            width: size.width * 0.22,
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
                                                            width: size.width * 0.28,
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
                                    )
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
    });
  }
}
