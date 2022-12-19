// ignore_for_file: must_be_immutable, deprecated_member_use

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/agent/agent_page.dart';
import 'package:webshop/view/agent/model/agent_statement_model.dart';
import 'package:webshop/view/agent/provider/agent_statement_provider.dart';
import 'package:webshop/view/drawer/drawer_widget.dart';
import 'package:webshop/view/homepage/home_screen.dart';
import 'package:webshop/widgets/avatar_icon_widget.dart';
import 'package:webshop/widgets/no_data_dialog.dart';
import 'package:webshop/widgets/statement_header_widget.dart';

class AgentStatementScreen extends StatefulWidget {
  int? agtId;
  String? agtMob;
  bool? isDrawer;
  AgentStatementScreen({super.key, this.agtId, this.agtMob, this.isDrawer});

  @override
  State<AgentStatementScreen> createState() => _AgentStatementScreenState();
}

class _AgentStatementScreenState extends State<AgentStatementScreen> {
  AgentStatementProvider? watchAgentStatementProvider;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    TabletSetupServiceProvider tabletSetupServiceProvider = context.read<TabletSetupServiceProvider>();
    tabletSetupServiceProvider.agentList = null;
    if (widget.agtId != null) {
      context.read<AgentStatementProvider>().getAgentStatement(
            int.parse(widget.agtId.toString()),
            tabletSetupServiceProvider.tabletSetupModel.data!.fiscalYear!.startDate!.split("T")[0],
            DateTime.now().toIso8601String().split("T")[0],
          );
      tabletSetupServiceProvider.selectAgent(int.parse(widget.agtId.toString()));
    } else {
      context.read<AgentStatementProvider>().getAgentStatement(
            -1,
            tabletSetupServiceProvider.tabletSetupModel.data!.fiscalYear!.startDate!.split("T")[0],
            DateTime.now().toIso8601String().split("T")[0],
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    watchAgentStatementProvider = context.watch<AgentStatementProvider>();
    TabletSetupServiceProvider watchTabletSetupServiceProvider = context.watch<TabletSetupServiceProvider>();

    watchAgentStatementProvider!.fromDate = watchAgentStatementProvider!.selectedFromDate.toString().split(" ")[0].toString();
    watchAgentStatementProvider!.toDate = watchAgentStatementProvider!.selectedToDate.toString().split(" ")[0].toString();

    Widget labelFromDate = InkWell(
      onTap: () {
        watchAgentStatementProvider!.selectFromDate(
          context,
          (widget.agtId != null) ? int.parse(widget.agtId.toString()) : null,
        );
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
            watchAgentStatementProvider!.fromDate.toString(),
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
        watchAgentStatementProvider!.selectToDate(
          context,
          (widget.agtId != null) ? int.parse(widget.agtId.toString()) : null,
        );
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
            watchAgentStatementProvider!.toDate.toString(),
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
                            items: watchTabletSetupServiceProvider.tabletSetupModel.data!.agentList!
                                .where((element) => element.agtCategory == 1)
                                .map((agent) {
                              return DropdownMenuItem<AgentList>(
                                value: agent,
                                child: Container(
                                  margin: EdgeInsets.only(left: AppWidth.w1),
                                  padding: EdgeInsets.only(left: AppWidth.w10),
                                  height: size.height * 0.06,
                                  width: double.infinity,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      agent.agtCompany.toString(),
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
                              widget.agtId = watchTabletSetupServiceProvider.agentList!.agtId;
                              widget.agtMob = watchTabletSetupServiceProvider.agentList!.agtMobile;

                              context.read<AgentStatementProvider>().getAgentStatement(
                                    int.parse(widget.agtId.toString()),
                                    watchAgentStatementProvider!.fromDate.toString(),
                                    watchAgentStatementProvider!.toDate.toString(),
                                  );
                            },
                            value: watchTabletSetupServiceProvider.agentList,
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
                            watchTabletSetupServiceProvider.agentList = null;
                            if (widget.isDrawer == true) {
                              scaffoldState.currentState!.openDrawer();
                            } else {
                              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const AgentPage(),
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
                              'Customer Statement',
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
                              watchTabletSetupServiceProvider.agentList = null;
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
                    body: Consumer<AgentStatementProvider>(
                      builder: (context, statement, child) {
                        statement.balance = 0.0;
                        return (statement.agentStatementModel.data == null || statement.agentStatementModel.data!.isEmpty)
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
                                      padding: EdgeInsets.symmetric(vertical: AppHeight.h16),
                                      child: Container(
                                        height: size.height * .12,
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
                                                        'Sales',
                                                        style: getBoldStyle(
                                                          fontSize: FontSize.s16,
                                                          color: ColorManager.black,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: AppHeight.h10,
                                                      ),
                                                      Text(
                                                        watchAgentStatementProvider!.purchaseTotal.toStringAsFixed(2),
                                                        style: getBoldStyle(
                                                          fontSize: FontSize.s12,
                                                          color: ColorManager.blue,
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
                                                        watchAgentStatementProvider!.paymentTotal.toStringAsFixed(2),
                                                        style: getBoldStyle(
                                                          fontSize: FontSize.s12,
                                                          color: ColorManager.blue,
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
                                                        statement.receiveable.toStringAsFixed(2),
                                                        style: getBoldStyle(
                                                          fontSize: FontSize.s12,
                                                          color: ColorManager.blue,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      AvatarIconWidget(
                                                        onTap: (widget.agtMob == "") ? () {} : () => launch('tel:${widget.agtMob}'),
                                                        icon: Icons.phone_outlined,
                                                        name: 'Call',
                                                      ),
                                                      SizedBox(
                                                        width: AppWidth.w10,
                                                      ),
                                                      AvatarIconWidget(
                                                        onTap: (widget.agtMob == "") ? () {} : () => launch('https://wa.me/+977${widget.agtMob}'),
                                                        icon: Icons.whatsapp_outlined,
                                                        name: 'WhatsApp',
                                                      ),
                                                      SizedBox(
                                                        width: AppWidth.w10,
                                                      ),
                                                      AvatarIconWidget(
                                                        onTap: () async {
                                                          final pdf = pw.Document();

                                                          await screenshotController
                                                              .capture(delay: const Duration(milliseconds: 10))
                                                              .then((Uint8List? image) async {
                                                            if (image != null) {
                                                              final directory = await getApplicationDocumentsDirectory();
                                                              final imagePath = await File('${directory.path}/image.png').create();
                                                              await imagePath.writeAsBytes(image);

                                                              final imageMemory = pw.MemoryImage(File(imagePath.path).readAsBytesSync());
                                                              pdf.addPage(
                                                                pw.Page(
                                                                  build: (pw.Context context) {
                                                                    return pw.Column(
                                                                      children: [
                                                                        pw.Image(imageMemory),
                                                                      ],
                                                                    ); // Center
                                                                  },
                                                                ),
                                                              );
                                                              final output = await getTemporaryDirectory();
                                                              final file = File("${output.path}/statementName.pdf");

                                                              await file.writeAsBytes(await pdf.save());

                                                              await Share.shareFiles([file.path]);
                                                            }
                                                          }).catchError((onError) {
                                                            log(onError.toString(), name: 'screenshot error');
                                                          });
                                                        },
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
                                    Screenshot(
                                      controller: screenshotController,
                                      child: Column(
                                        children: [
                                          const StatementHeaderWidget(
                                            isCustomer: true,
                                          ),
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
                                                  rows: statement.agentStatementModel.data!.map(
                                                    (statement) {
                                                      return _agentStatementRow(statement, size);
                                                    },
                                                  ).toList(),
                                                ),
                                              ],
                                            ),
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

  DataRow _agentStatementRow(AgentStatement statement, Size size) {
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
