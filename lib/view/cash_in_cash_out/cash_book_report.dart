import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/cash_in_cash_out/model/cash_report_model.dart';
import 'package:webshop/view/cash_in_cash_out/provider/cash_book_provider.dart';
import 'package:webshop/view/drawer/drawer_widget.dart';
import 'package:webshop/view/homepage/home_screen.dart';
import 'package:webshop/widgets/cash_report_header.dart';
import 'package:webshop/widgets/no_data_dialog.dart';

class CashBookReport extends StatefulWidget {
  final bool? isDrawer;
  const CashBookReport({super.key, this.isDrawer});

  @override
  State<CashBookReport> createState() => _CashBookReportState();
}

class _CashBookReportState extends State<CashBookReport> {
  CashBookReportServiceProvider? readCashBookReportServiceProvider;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    readCashBookReportServiceProvider = context.read<CashBookReportServiceProvider>();

    readCashBookReportServiceProvider!.getCashReport(
      readCashBookReportServiceProvider!.selectedFromDate.toIso8601String().split("T")[0],
      readCashBookReportServiceProvider!.selectedToDate.toIso8601String().split("T")[0],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    CashBookReportServiceProvider watchCashBookReportServiceProvider = context.watch<CashBookReportServiceProvider>();

    readCashBookReportServiceProvider!.fromDate = watchCashBookReportServiceProvider.selectedFromDate.toString().split(" ")[0].toString();
    readCashBookReportServiceProvider!.toDate = watchCashBookReportServiceProvider.selectedToDate.toString().split(" ")[0].toString();

    Widget labelStartDate = InkWell(
      onTap: () {
        readCashBookReportServiceProvider!.selectStartDate(context);
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
            watchCashBookReportServiceProvider.fromDate.toString(),
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
        readCashBookReportServiceProvider!.selectEndDate(context);
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
            watchCashBookReportServiceProvider.toDate.toString(),
            style: getBoldStyle(
              fontSize: FontSize.s10,
              color: ColorManager.white,
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      key: scaffoldState,
      drawer: (widget.isDrawer == true) ? const DrawerWidget() : Container(),
      bottomSheet: Container(
        height: size.height * 0.08,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ColorManager.blue,
              ColorManager.blueBright,
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'CashIn: ',
                  style: getBoldStyle(
                    fontSize: FontSize.s14,
                    color: ColorManager.white,
                  ),
                ),
                Text(
                  watchCashBookReportServiceProvider.cashInTotal.toStringAsFixed(2),
                  style: getMediumStyle(
                    fontSize: FontSize.s12,
                    color: ColorManager.white,
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  'CashOut: ',
                  style: getMediumStyle(
                    fontSize: FontSize.s14,
                    color: ColorManager.white,
                  ),
                ),
                Text(
                  watchCashBookReportServiceProvider.cashOutTotal.toStringAsFixed(2),
                  style: getMediumStyle(
                    fontSize: FontSize.s12,
                    color: ColorManager.white,
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  'Balance: ',
                  style: getBoldStyle(
                    fontSize: FontSize.s14,
                    color: ColorManager.white,
                  ),
                ),
                Text(
                  watchCashBookReportServiceProvider.cashTotal.toStringAsFixed(2),
                  style: getMediumStyle(
                    fontSize: FontSize.s12,
                    color: ColorManager.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Consumer<CashBookReportServiceProvider>(
        builder: (context, cash, child) {
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
                              'CashBook Report',
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
                (cash.cashReportModel.data == null)
                    ? SliverToBoxAdapter(
                        child: SizedBox(
                          height: size.height,
                          width: size.width,
                          child: const Center(
                            child: LoadingBox(),
                          ),
                        ),
                      )
                    : (cash.cashReportModel.data!.isEmpty)
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: AppHeight.h2,
                                  ),
                                  const CashReportHeader(),
                                  SizedBox(
                                    height: size.height * 0.65,
                                    width: size.width * 1.6,
                                    child: SingleChildScrollView(
                                      child: DataTable(
                                        dataRowHeight: 50.0,
                                        headingRowHeight: 0.0,
                                        columnSpacing: 0.0,
                                        horizontalMargin: 0,
                                        dataRowColor: MaterialStateProperty.resolveWith((states) => ColorManager.white),
                                        columns: _createColumn(),
                                        rows: cash.cashReportModel.data!
                                            .map(
                                              (cash) => _cashBookReportRow(cash, size),
                                            )
                                            .toList(),
                                      ),
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
  }

  DataRow _cashBookReportRow(CashReport cash, Size size) {
    return DataRow(
      cells: [
        DataCell(
          Container(
            width: size.width * 0.2,
            padding: EdgeInsets.only(left: AppWidth.w4),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                cash.billDate.toString().split("T")[0],
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
            width: size.width * 0.15,
            padding: EdgeInsets.only(left: AppWidth.w4),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                cash.billNo.toString(),
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
              alignment: Alignment.center,
              child: Text(
                cash.billDescription.toString(),
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
            width: size.width * 0.3,
            padding: EdgeInsets.only(left: AppWidth.w4),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                cash.bdName.toString(),
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
              alignment: Alignment.centerRight,
              child: Text(
                (cash.billCashIn == 0.0) ? '' : cash.billCashIn!.toStringAsFixed(2),
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
              alignment: Alignment.centerRight,
              child: Text(
                (cash.billCashOut == 0.0) ? '' : cash.billCashOut!.toStringAsFixed(2),
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
                cash.bdCode.toString(),
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
