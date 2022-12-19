// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/drawer/drawer_widget.dart';
import 'package:webshop/view/homepage/home_screen.dart';
import 'package:webshop/view/supplier/model/supplier_statement_model.dart';
import 'package:webshop/view/supplier/provider/supplier_satement_provider.dart';
import 'package:webshop/view/supplier/supplier_page.dart';
import 'package:webshop/widgets/avatar_icon_widget.dart';
import 'package:webshop/widgets/no_data_dialog.dart';
import 'package:webshop/widgets/statement_header_widget.dart';

class SupplierStatementScreen extends StatefulWidget {
  int? supId;
  String? supplierMob;
  bool? isDrawer;
  SupplierStatementScreen({Key? key, this.supId, this.supplierMob, this.isDrawer}) : super(key: key);

  @override
  State<SupplierStatementScreen> createState() => _SupplierStatementScreenState();
}

class _SupplierStatementScreenState extends State<SupplierStatementScreen> {
  SupplierStatementProvider? watchSupplierStatementProvider;

  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    TabletSetupServiceProvider tabletSetupServiceProvider = context.read<TabletSetupServiceProvider>();
    tabletSetupServiceProvider.supplierList = null;
    if (widget.supId != null) {
      context.read<SupplierStatementProvider>().getSupplierStatement(
            int.parse(widget.supId.toString()),
            tabletSetupServiceProvider.tabletSetupModel.data!.fiscalYear!.startDate!.split("T")[0],
            DateTime.now().toIso8601String().split("T")[0],
          );
      tabletSetupServiceProvider.selectSupplier(int.parse(widget.supId.toString()));
    } else {
      context.read<SupplierStatementProvider>().getSupplierStatement(
            -1,
            tabletSetupServiceProvider.tabletSetupModel.data!.fiscalYear!.startDate!.split("T")[0],
            DateTime.now().toIso8601String().split("T")[0],
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    watchSupplierStatementProvider = context.watch<SupplierStatementProvider>();
    TabletSetupServiceProvider watchTabletSetupServiceProvider = context.watch<TabletSetupServiceProvider>();

    watchSupplierStatementProvider!.fromDate = watchSupplierStatementProvider!.selectedFromDate.toString().split(" ")[0].toString();
    watchSupplierStatementProvider!.toDate = watchSupplierStatementProvider!.selectedToDate.toString().split(" ")[0].toString();

    Widget labelFromDate = InkWell(
      onTap: () {
        watchSupplierStatementProvider!.selectFromDate(
          context,
          (widget.supId != null) ? int.parse(widget.supId.toString()) : null,
        );
        //   getSupplierReportApi();
      },
      child: Container(
        height: size.height * 0.05,
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
            watchSupplierStatementProvider!.fromDate.toString(),
            style: getBoldStyle(
              fontSize: FontSize.s14,
              color: ColorManager.white,
            ),
          ),
        ),
      ),
    );

    Widget labelToDate = InkWell(
      onTap: () {
        watchSupplierStatementProvider!.selectToDate(
          context,
          (widget.supId != null) ? int.parse(widget.supId.toString()) : null,
        );
        //   getSupplierReportApi();
      },
      child: Container(
        height: size.height * 0.05,
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
            watchSupplierStatementProvider!.toDate.toString(),
            style: getBoldStyle(
              fontSize: FontSize.s14,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Divider(
                        color: ColorManager.blackOpacity38,
                      ),
                      SingleChildScrollView(
                        child: SizedBox(
                          width: size.width * 0.9,
                          height: size.height * 0.08,
                          child: DropdownButtonFormField<SupplierList>(
                            decoration: InputDecoration(
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
                                  height: size.height * 0.06,
                                  width: double.infinity,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      supplier.supName.toString(),
                                      style: getRegularStyle(
                                        fontSize: FontSize.s12,
                                        color: ColorManager.blackOpacity54,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (supplier) {
                              watchTabletSetupServiceProvider.supplierList = supplier;
                              widget.supId = watchTabletSetupServiceProvider.supplierList!.supId;
                              widget.supplierMob = watchTabletSetupServiceProvider.supplierList!.supMobile;

                              context.read<SupplierStatementProvider>().getSupplierStatement(
                                    int.parse(widget.supId.toString()),
                                    watchSupplierStatementProvider!.fromDate.toString(),
                                    watchSupplierStatementProvider!.toDate.toString(),
                                  );
                            },
                            value: watchTabletSetupServiceProvider.supplierList,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: AppHeight.h10,
                      ),
                    ],
                  ),
                ),
                body: SafeArea(
                  child: NestedScrollView(
                    floatHeaderSlivers: true,
                    headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
                      SliverAppBar(
                        toolbarHeight: size.height * 0.15,
                        forceElevated: true,
                        elevation: 10,
                        leading: IconButton(
                          onPressed: () {
                            if (widget.isDrawer == true) {
                              scaffoldState.currentState!.openDrawer();
                            } else {
                              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const SupplierPage(),
                                  ),
                                  (route) => false);
                            }
                          },
                          icon: (widget.isDrawer == true) ? const Icon(Icons.menu) : const Icon(Icons.arrow_back),
                        ),
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
                          ),
                        ),
                        floating: true,
                        snap: true,
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Supplier Statement',
                              style: getBoldStyle(
                                fontSize: FontSize.s16,
                                color: ColorManager.white,
                              ),
                            ),
                            SizedBox(
                              height: AppHeight.h20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                labelFromDate,
                                Text(
                                  '  -  ',
                                  style: getBoldStyle(
                                    fontSize: FontSize.s18,
                                    color: ColorManager.white,
                                  ),
                                ),
                                labelToDate,
                              ],
                            ),
                            SizedBox(
                              height: AppHeight.h10,
                            ),
                          ],
                        ),
                        actions: [
                          IconButton(
                            onPressed: () {
                              watchTabletSetupServiceProvider.supplierList = null;
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
                    ],
                    body: Consumer<SupplierStatementProvider>(
                      builder: (context, statement, child) {
                        statement.balance = 0.0;
                        return (statement.supplierStatementModel.data == null || statement.supplierStatementModel.data!.isEmpty)
                            ? SizedBox(
                                height: size.height,
                                width: size.width,
                                child: const NoDataErrorBox(),
                              )
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: AppWidth.w8, vertical: AppHeight.h14),
                                      child: Container(
                                        height: size.height * .11,
                                        width: size.width * 1.5,
                                        decoration: BoxDecoration(
                                          color: ColorManager.white,
                                          borderRadius: BorderRadius.circular(AppRadius.r10),
                                          border: Border.all(color: ColorManager.blackOpacity38),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: AppWidth.w10, vertical: AppHeight.h12),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      Text(
                                                        'Purchase',
                                                        style: getBoldStyle(
                                                          fontSize: FontSize.s16,
                                                          color: ColorManager.black,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: AppHeight.h10,
                                                      ),
                                                      Text(
                                                        watchSupplierStatementProvider!.purchaseTotal.toStringAsFixed(2),
                                                        style: getBoldStyle(
                                                          fontSize: FontSize.s12,
                                                          color: ColorManager.error,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      Text(
                                                        'Payment',
                                                        style: getBoldStyle(
                                                          fontSize: FontSize.s16,
                                                          color: ColorManager.black,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: AppHeight.h10,
                                                      ),
                                                      Text(
                                                        watchSupplierStatementProvider!.paymentTotal.toStringAsFixed(2),
                                                        style: getBoldStyle(
                                                          fontSize: FontSize.s12,
                                                          color: ColorManager.error,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      Text(
                                                        'Total',
                                                        style: getBoldStyle(
                                                          fontSize: FontSize.s16,
                                                          color: ColorManager.black,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: AppHeight.h10,
                                                      ),
                                                      Text(
                                                        statement.payable.toStringAsFixed(2),
                                                        style: getBoldStyle(
                                                          fontSize: FontSize.s12,
                                                          color: ColorManager.error,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      AvatarIconWidget(
                                                        onTap: (widget.supplierMob == "") ? () {} : () => launch('tel:${widget.supplierMob}'),
                                                        icon: Icons.phone_outlined,
                                                        name: 'Call',
                                                      ),
                                                      SizedBox(
                                                        width: AppWidth.w10,
                                                      ),
                                                      AvatarIconWidget(
                                                        onTap: (widget.supplierMob == "")
                                                            ? () {}
                                                            : () => launch('https://wa.me/+977${widget.supplierMob}'),
                                                        icon: Icons.whatsapp_outlined,
                                                        name: 'WhatsApp',
                                                      ),
                                                      SizedBox(
                                                        width: AppWidth.w10,
                                                      ),
                                                      AvatarIconWidget(
                                                        onTap: () {},
                                                        icon: Icons.share,
                                                        name: 'Share',
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const StatementHeaderWidget(isCustomer: false),
                                    SizedBox(
                                      height: size.height * 0.65,
                                      width: size.width * 1.5,
                                      child: ListView(
                                        children: [
                                          DataTable(
                                            columnSpacing: 0.0,
                                            headingRowHeight: 0.0,
                                            horizontalMargin: 0.0,
                                            columns: _createColumn(),
                                            rows: statement.supplierStatementModel.data!.map(
                                              (statement) {
                                                watchSupplierStatementProvider!.calculateTotalBalance(statement);
                                                return _supplierStatementRow(statement, size);
                                              },
                                            ).toList(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                      },
                    ),
                  ),
                ),
              );
      },
    );
  }

  DataRow _supplierStatementRow(SupplierStatement statement, Size size) {
    return DataRow(
      cells: [
        DataCell(
          Container(
            padding: EdgeInsets.only(left: AppWidth.w4),
            width: size.width * 0.25,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                statement.billDate.toString().split("T")[0],
                style: getRegularStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.black,
                ),
              ),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: size.width * 0.25,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                statement.billNsDate.toString(),
                style: getRegularStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.black,
                ),
              ),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: size.width * 0.2,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                statement.billNo.toString(),
                style: getRegularStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.black,
                ),
              ),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: size.width * 0.35,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                statement.billDescription.toString(),
                style: getRegularStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.black,
                ),
              ),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: size.width * 0.23,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                (statement.billCredit == 0.0) ? '' : statement.billCredit!.toStringAsFixed(2),
                style: getRegularStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.black,
                ),
              ),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: size.width * 0.22,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                (statement.billCashIn == 0.0) ? '' : statement.billCashIn!.toStringAsFixed(2),
                style: getRegularStyle(
                  fontSize: FontSize.s14,
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
    ];
  }
}
