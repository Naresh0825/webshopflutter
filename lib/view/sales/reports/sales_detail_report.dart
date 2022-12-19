import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/drawer/drawer_widget.dart';
import 'package:webshop/view/homepage/home_screen.dart';
import 'package:webshop/view/sales/model/sales_report_model.dart';
import 'package:webshop/view/sales/services/sales_report_service.dart';
import 'package:webshop/widgets/no_data_dialog.dart';
import 'package:webshop/widgets/sales_detail_header.dart';

class SalesDetailReport extends StatefulWidget {
  final bool? isDrawer;
  const SalesDetailReport({super.key, this.isDrawer});

  @override
  State<SalesDetailReport> createState() => _SalesDetailReportState();
}

class _SalesDetailReportState extends State<SalesDetailReport> {
  SalesReportServiceProvider? readSalesReportServiceProvider;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    readSalesReportServiceProvider = context.read<SalesReportServiceProvider>();

    readSalesReportServiceProvider!.getSalesReport(
      readSalesReportServiceProvider!.selectedFromDate,
      readSalesReportServiceProvider!.selectedToDate,
      null,
      null,
    );

    TabletSetupServiceProvider readTabletSetupServiceProvider = context.read<TabletSetupServiceProvider>();
    readTabletSetupServiceProvider.agentList = null;
    readTabletSetupServiceProvider.stockList = null;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    SalesReportServiceProvider watchSalesReportServiceProvider = context.watch<SalesReportServiceProvider>();
    TabletSetupServiceProvider watchTabletSetupServiceProvider = context.watch<TabletSetupServiceProvider>();

    watchSalesReportServiceProvider.fromDate = watchSalesReportServiceProvider.selectedFromDate.toString().split(" ")[0].toString();
    watchSalesReportServiceProvider.toDate = watchSalesReportServiceProvider.selectedToDate.toString().split(" ")[0].toString();

    Widget labelStartDate = InkWell(
      onTap: () {
        readSalesReportServiceProvider!.selectStartDate(context);
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
            watchSalesReportServiceProvider.fromDate.toString(),
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
        readSalesReportServiceProvider!.selectEndDate(context);
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
            watchSalesReportServiceProvider.toDate.toString(),
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
              body: Consumer<SalesReportServiceProvider>(
                builder: (context, report, child) {
                  if (report.salesDetailReportModel.data != null) {
                    watchSalesReportServiceProvider.group = groupBy(report.salesDetailReportModel.data!, (val) => val.traDate!.split("T")[0]);

                    watchSalesReportServiceProvider.totalQty =
                        watchSalesReportServiceProvider.group.map((key, value) => MapEntry(key, value.fold(0, (a, b) => a + b.traDQty!)));
                    watchSalesReportServiceProvider.totalSales =
                        watchSalesReportServiceProvider.group.map((key, value) => MapEntry(key, value.fold(0, (a, b) => a + b.traDAmount!)));
                    watchSalesReportServiceProvider.totalCost =
                        watchSalesReportServiceProvider.group.map((key, value) => MapEntry(key, value.fold(0, (a, b) => a + b.traDCostAmount!)));
                  }
                  return SizedBox(
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
                                      'Sales Detail Report',
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
                                watchTabletSetupServiceProvider.agentList = null;
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
                        (report.salesDetailReportModel.data == null)
                            ? SliverToBoxAdapter(
                                child: SizedBox(
                                  height: size.height * 0.6,
                                  width: size.width,
                                  child: const Center(
                                    child: LoadingBox(),
                                  ),
                                ),
                              )
                            : (report.salesDetailReportModel.data!.isEmpty)
                                ? SliverToBoxAdapter(
                                    child: SizedBox(
                                      height: size.height * 0.6,
                                      width: size.width,
                                      child: const Center(
                                        child: NoDataErrorBox(),
                                      ),
                                    ),
                                  )
                                : SliverToBoxAdapter(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(
                                            height: AppHeight.h2,
                                          ),
                                          const SalesDetailHeaderWidget(),
                                          SizedBox(
                                            height: size.height * 0.58,
                                            width: size.width * 1.4,
                                            child: GroupedListView<SalesData, String>(
                                              elements: report.salesDetailReportModel.data!,
                                              groupBy: (element) => element.traDate.toString().split("T")[0],
                                              groupSeparatorBuilder: (String value) => Container(
                                                width: size.width * 1.4,
                                                padding: EdgeInsets.all(AppWidth.w10),
                                                child: Row(
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
                                                      width: size.width * 0.12,
                                                      padding: EdgeInsets.only(left: AppWidth.w4),
                                                      child: Align(
                                                        alignment: Alignment.centerRight,
                                                        child: Text(
                                                          (watchSalesReportServiceProvider.totalQty[value] == 0.0)
                                                              ? ''
                                                              : watchSalesReportServiceProvider.totalQty[value]!.toStringAsFixed(2).toUpperCase(),
                                                          style: getBoldStyle(
                                                            fontSize: FontSize.s10,
                                                            color: ColorManager.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: size.width * 0.2,
                                                    ),
                                                    Container(
                                                      width: size.width * 0.15,
                                                      padding: EdgeInsets.only(left: AppWidth.w4),
                                                      child: Align(
                                                        alignment: Alignment.centerRight,
                                                        child: Text(
                                                          (watchSalesReportServiceProvider.totalSales[value] == 0.0)
                                                              ? ''
                                                              : watchSalesReportServiceProvider.totalSales[value]!.toStringAsFixed(2).toUpperCase(),
                                                          style: getBoldStyle(
                                                            fontSize: FontSize.s10,
                                                            color: ColorManager.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: size.width * 0.08,
                                                    ),
                                                    Container(
                                                      width: size.width * 0.15,
                                                      padding: EdgeInsets.only(left: AppWidth.w4),
                                                      child: Align(
                                                        alignment: Alignment.centerRight,
                                                        child: Text(
                                                          (watchSalesReportServiceProvider.totalCost[value] == 0.0)
                                                              ? ''
                                                              : watchSalesReportServiceProvider.totalCost[value]!.toStringAsFixed(2).toUpperCase(),
                                                          style: getBoldStyle(
                                                            fontSize: FontSize.s10,
                                                            color: ColorManager.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: size.width * 0.15,
                                                    ),
                                                    Container(
                                                      width: size.width * 0.15,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              itemComparator: (item1, item2) =>
                                                  item1.traDate.toString().split("T")[0].compareTo(item2.traDate.toString().split("T")[0]),
                                              groupComparator: (value1, value2) => value1.compareTo(value2),
                                              itemBuilder: (context, element) {
                                                watchSalesReportServiceProvider.calculateProfit(
                                                    double.parse(element.traDAmount.toString()), double.parse(element.traDCostAmount.toString()));
                                                watchSalesReportServiceProvider.calculateProfitPercent(
                                                    double.parse(watchSalesReportServiceProvider.profit.toString()),
                                                    double.parse(element.traDCostAmount.toString()));
                                                return Container(
                                                  height: size.height * 0.05,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: ColorManager.black,
                                                      width: AppWidth.w0,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        padding: EdgeInsets.only(left: AppWidth.w4),
                                                        width: size.width * 0.3,
                                                        child: Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: Text(
                                                            element.stDes.toString(),
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
                                                        padding: EdgeInsets.only(left: AppWidth.w4),
                                                        width: size.width * 0.1,
                                                        child: Align(
                                                          alignment: Alignment.centerRight,
                                                          child: Text(
                                                            element.traDQty!.toDouble().toString(),
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
                                                        padding: EdgeInsets.only(left: AppWidth.w4),
                                                        width: size.width * 0.15,
                                                        child: Align(
                                                          alignment: Alignment.centerRight,
                                                          child: Text(
                                                            element.traBillNo.toString(),
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
                                                        padding: EdgeInsets.only(left: AppWidth.w4),
                                                        width: size.width * 0.15,
                                                        child: Align(
                                                          alignment: Alignment.centerRight,
                                                          child: Text(
                                                            element.traDAmount.toString(),
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
                                                        padding: EdgeInsets.only(left: AppWidth.w4),
                                                        width: size.width * 0.15,
                                                        child: Align(
                                                          alignment: Alignment.centerRight,
                                                          child: Text(
                                                            (element.traDCostAmount == 0.0) ? '' : element.traDCostAmount.toString(),
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
                                                        padding: EdgeInsets.only(left: AppWidth.w4),
                                                        width: size.width * 0.15,
                                                        child: Align(
                                                          alignment: Alignment.centerRight,
                                                          child: Text(
                                                            (watchSalesReportServiceProvider.profit == 0.0)
                                                                ? ''
                                                                : watchSalesReportServiceProvider.profit.toStringAsFixed(2),
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
                                                        padding: EdgeInsets.only(left: AppWidth.w4),
                                                        width: size.width * 0.15,
                                                        child: Align(
                                                          alignment: Alignment.centerRight,
                                                          child: Text(
                                                            (watchSalesReportServiceProvider.profitPer == 0.0)
                                                                ? ''
                                                                : watchSalesReportServiceProvider.profitPer.toStringAsFixed(2),
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
                                      ),
                                    ),
                                  ),
                      ],
                    ),
                  );
                },
              ),
              bottomSheet: SizedBox(
                height: size.height * 0.12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SingleChildScrollView(
                      child: SizedBox(
                        width: size.width * 0.45,
                        height: size.height * 0.08,
                        child: DropdownButtonFormField<AgentList>(
                          decoration: InputDecoration(
                            hintText: 'Select Customer',
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
                          items: watchTabletSetupServiceProvider.tabletSetupModel.data!.agentList!.map((item) {
                            return DropdownMenuItem<AgentList>(
                              value: item,
                              child: Container(
                                margin: EdgeInsets.only(left: AppWidth.w1),
                                padding: EdgeInsets.only(left: AppWidth.w10),
                                height: size.height * 0.06,
                                width: double.infinity,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    item.agtCompany.toString(),
                                    style: getRegularStyle(
                                      fontSize: FontSize.s12,
                                      color: ColorManager.blackOpacity54,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (agent) {
                            watchTabletSetupServiceProvider.agentList = agent;
                            watchSalesReportServiceProvider.agtId = watchTabletSetupServiceProvider.agentList!.agtId;

                            context.read<SalesReportServiceProvider>().getSalesReport(
                                  DateTime.parse(watchSalesReportServiceProvider.fromDate.toString()),
                                  DateTime.parse(watchSalesReportServiceProvider.toDate.toString()),
                                  watchSalesReportServiceProvider.agtId,
                                  watchSalesReportServiceProvider.traDStkId,
                                );
                          },
                          value: watchTabletSetupServiceProvider.agentList,
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
                            watchSalesReportServiceProvider.traDStkId = watchTabletSetupServiceProvider.stockList!.stId;

                            context.read<SalesReportServiceProvider>().getSalesReport(
                                  DateTime.parse(watchSalesReportServiceProvider.fromDate.toString()),
                                  DateTime.parse(watchSalesReportServiceProvider.toDate.toString()),
                                  watchSalesReportServiceProvider.agtId,
                                  watchSalesReportServiceProvider.traDStkId,
                                );
                          },
                          value: watchTabletSetupServiceProvider.stockList,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
    });
  }
}
