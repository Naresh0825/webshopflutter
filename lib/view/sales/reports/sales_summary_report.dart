import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/drawer/drawer_widget.dart';
import 'package:webshop/view/homepage/home_screen.dart';
import 'package:webshop/view/sales/model/find_sale_model.dart';
import 'package:webshop/view/sales/services/find_sale_service.dart';
import 'package:webshop/widgets/no_data_dialog.dart';
import 'package:webshop/widgets/sales_summary_report_header.dart';

class SalesSummaryReport extends StatefulWidget {
  final bool? isDrawer;
  const SalesSummaryReport({super.key, this.isDrawer});

  @override
  State<SalesSummaryReport> createState() => _SalesSummaryReportState();
}

class _SalesSummaryReportState extends State<SalesSummaryReport> {
  SaleSummaryServiceProvider? readSaleSummaryServiceProvider;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    readSaleSummaryServiceProvider = context.read<SaleSummaryServiceProvider>();
    readSaleSummaryServiceProvider!.getSaleSummary(
      readSaleSummaryServiceProvider!.selectedFromDate,
      readSaleSummaryServiceProvider!.selectedToDate,
      null,
      traType: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    SaleSummaryServiceProvider watchSaleSummaryServiceProvider = context.watch<SaleSummaryServiceProvider>();

    readSaleSummaryServiceProvider!.fromDate = readSaleSummaryServiceProvider!.selectedFromDate.toString().split(" ")[0].toString();
    readSaleSummaryServiceProvider!.toDate = readSaleSummaryServiceProvider!.selectedToDate.toString().split(" ")[0].toString();

    Widget labelStartDate = InkWell(
      onTap: () {
        readSaleSummaryServiceProvider!.selectStartDate(context);
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
            readSaleSummaryServiceProvider!.fromDate.toString(),
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
        readSaleSummaryServiceProvider!.selectEndDate(context);
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
            readSaleSummaryServiceProvider!.toDate.toString(),
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
                body: Consumer<SaleSummaryServiceProvider>(
                  builder: (context, sales, child) {
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
                                        'Sales Summary',
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
                          (sales.findSaleModel.data == null)
                              ? SliverToBoxAdapter(
                                  child: SizedBox(
                                    height: size.height,
                                    width: size.width,
                                    child: const Center(
                                      child: LoadingBox(),
                                    ),
                                  ),
                                )
                              : (sales.findSaleModel.data!.isEmpty)
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
                                        scrollDirection: Axis.horizontal,
                                        child: Column(
                                          children: <Widget>[
                                            SizedBox(
                                              height: AppHeight.h2,
                                            ),
                                            const SalesSummaryReportHeader(),
                                            SizedBox(
                                              height: size.height * 0.6,
                                              width: size.width * 1.7,
                                              child: SingleChildScrollView(
                                                child: DataTable(
                                                  dataRowHeight: 50.0,
                                                  headingRowHeight: 0.0,
                                                  columnSpacing: 0.0,
                                                  horizontalMargin: 0,
                                                  dataRowColor: MaterialStateProperty.resolveWith((states) => ColorManager.white),
                                                  columns: _createColumn(),
                                                  rows: sales.findSaleModel.data!
                                                      .map(
                                                        (sale) => _salesReportRow(sale, size),
                                                      )
                                                      .toList(),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: size.width * 1.7,
                                              height: size.height * 0.05,
                                              decoration: BoxDecoration(
                                                color: ColorManager.white,
                                                border: Border.all(color: ColorManager.grey3),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    width: size.width * 0.2,
                                                  ),
                                                  Container(
                                                    width: size.width * 0.15,
                                                  ),
                                                  Container(
                                                    width: size.width * 0.35,
                                                    padding: EdgeInsets.only(left: AppWidth.w4),
                                                    child: Align(
                                                      alignment: Alignment.centerRight,
                                                      child: Text(
                                                        'Total:',
                                                        style: getSemiBoldStyle(
                                                          fontSize: FontSize.s14,
                                                          color: ColorManager.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: size.width * 0.25,
                                                    padding: EdgeInsets.only(left: AppWidth.w4),
                                                    child: Align(
                                                      alignment: Alignment.centerRight,
                                                      child: Text(
                                                        watchSaleSummaryServiceProvider.totalSum.toStringAsFixed(2),
                                                        style: getSemiBoldStyle(
                                                          fontSize: FontSize.s12,
                                                          color: ColorManager.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: size.width * 0.25,
                                                    padding: EdgeInsets.only(left: AppWidth.w4),
                                                    child: Align(
                                                      alignment: Alignment.centerRight,
                                                      child: Text(
                                                        watchSaleSummaryServiceProvider.cashTotal.toStringAsFixed(2),
                                                        style: getSemiBoldStyle(
                                                          fontSize: FontSize.s12,
                                                          color: ColorManager.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: size.width * 0.25,
                                                    padding: EdgeInsets.only(left: AppWidth.w4),
                                                    child: Align(
                                                      alignment: Alignment.centerRight,
                                                      child: Text(
                                                        (watchSaleSummaryServiceProvider.creditTotal.toString().split(".")[1] == "0")
                                                            ? watchSaleSummaryServiceProvider.creditTotal.toString().split(".")[0]
                                                            : watchSaleSummaryServiceProvider.creditTotal.toStringAsFixed(2),
                                                        style: getSemiBoldStyle(
                                                          fontSize: FontSize.s12,
                                                          color: ColorManager.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: size.width * 0.15,
                                                  ),
                                                ],
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
              );
      },
    );
  }

  DataRow _salesReportRow(FindSale sale, Size size) {
    return DataRow(
      cells: [
        DataCell(
          Container(
            width: size.width * 0.2,
            padding: EdgeInsets.only(left: AppWidth.w4),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                sale.traDate.toString().split("T")[0],
                style: getRegularStyle(
                  fontSize: FontSize.s12,
                  color: ColorManager.black,
                ),
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            width: size.width * 0.2,
            padding: EdgeInsets.only(left: AppWidth.w4),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                sale.traBillNo.toString(),
                style: getRegularStyle(
                  fontSize: FontSize.s12,
                  color: ColorManager.black,
                ),
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            width: size.width * 0.35,
            padding: EdgeInsets.only(left: AppWidth.w4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                sale.traCustomerName.toString(),
                style: getRegularStyle(
                  fontSize: FontSize.s12,
                  color: ColorManager.black,
                ),
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            width: size.width * 0.25,
            padding: EdgeInsets.only(left: AppWidth.w4),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                sale.traTotalAmount!.toStringAsFixed(2),
                style: getRegularStyle(
                  fontSize: FontSize.s12,
                  color: ColorManager.black,
                ),
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            width: size.width * 0.25,
            padding: EdgeInsets.only(left: AppWidth.w4),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                (sale.salesAmount == 0.0) ? '' : sale.salesAmount.toString(),
                style: getRegularStyle(
                  fontSize: FontSize.s12,
                  color: ColorManager.black,
                ),
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            width: size.width * 0.25,
            padding: EdgeInsets.only(left: AppWidth.w4),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                (sale.creditAmt == 0.0) ? '' : sale.creditAmt.toString(),
                style: getRegularStyle(
                  fontSize: FontSize.s12,
                  color: ColorManager.black,
                ),
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            width: size.width * 0.2,
            padding: EdgeInsets.only(left: AppWidth.w4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                sale.traRemark.toString(),
                style: getRegularStyle(
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

  _createColumn() {
    return <DataColumn>[
      DataColumn(label: Container()),
      DataColumn(label: Container()),
      DataColumn(label: Container()),
      DataColumn(label: Container()),
      DataColumn(label: Container()),
      DataColumn(label: Container()),
      DataColumn(label: Container()),
    ];
  }
}
