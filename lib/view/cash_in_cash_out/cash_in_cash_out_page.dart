import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/cash_in_cash_out/tabs/credit_tab.dart';
import 'package:webshop/view/drawer/drawer_widget.dart';
import 'package:webshop/view/homepage/home_screen.dart';

import 'provider/cash_in_cash_out_provider.dart';
import 'tabs/all_data_page.dart';
import 'tabs/cash_in_tab.dart';
import 'tabs/cash_out_tab.dart';

class CashInCashOutPage extends StatefulWidget {
  final bool? isDrawer;
  const CashInCashOutPage({super.key, this.isDrawer});

  @override
  State<CashInCashOutPage> createState() => _CashInCashOutPageState();
}

class _CashInCashOutPageState extends State<CashInCashOutPage> {
  String? fromDate, toDate;
  CashInCashOutProvider? readCashInCashOutProvider;
  int _currentIndex = 0;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getApiCall();
  }

  @override
  Widget build(BuildContext context) {
    readCashInCashOutProvider = context.read<CashInCashOutProvider>();

    CashInCashOutProvider watchCashInCashOutProvider = context.watch<CashInCashOutProvider>();

    Size size = MediaQuery.of(context).size;
    fromDate = readCashInCashOutProvider!.selectedFromDate.toString().split(" ")[0].toString();
    toDate = readCashInCashOutProvider!.selectedToDate.toString().split(" ")[0].toString();

    Widget labelStartDate = InkWell(
      onTap: () {
        selectFromDate();
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
            fromDate.toString(),
            style: getBoldStyle(
              fontSize: FontSize.s12,
              color: ColorManager.white,
            ),
          ),
        ),
      ),
    );
    Widget labelEndDate = InkWell(
      onTap: () {
        selectEndDate();
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
            toDate.toString(),
            style: getBoldStyle(
              fontSize: FontSize.s12,
              color: ColorManager.white,
            ),
          ),
        ),
      ),
    );

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        key: scaffoldState,
        drawer: (widget.isDrawer == true) ? const DrawerWidget() : Container(),
        appBar: AppBar(
          toolbarHeight: 100,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorManager.blue,
                  ColorManager.blueBright,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          bottom: TabBar(
            onTap: (index) {
              setState(() {
                _currentIndex = index;
                readCashInCashOutProvider!.cashInCashOutModel.data = null;
              });
            },
            tabs: [
              Tab(
                child: Text(
                  'All',
                  style: getMediumStyle(
                    fontSize: FontSize.s15,
                    color: _currentIndex == 0 ? ColorManager.darkBlue : ColorManager.white,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Cash In',
                  style: getMediumStyle(
                    fontSize: FontSize.s15,
                    color: _currentIndex == 1 ? ColorManager.darkBlue : ColorManager.white,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Credit',
                  style: getMediumStyle(
                    fontSize: FontSize.s15,
                    color: _currentIndex == 2 ? ColorManager.darkBlue : ColorManager.white,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Cash Out',
                  style: getMediumStyle(
                    fontSize: FontSize.s15,
                    color: _currentIndex == 3 ? ColorManager.darkBlue : ColorManager.white,
                  ),
                ),
              ),
            ],
          ),
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      if (widget.isDrawer == true) {
                        scaffoldState.currentState!.openDrawer();
                      } else {
                        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                            (route) => false);
                      }
                    },
                    icon: (widget.isDrawer == true) ? const Icon(Icons.menu) : const Icon(Icons.arrow_back),
                  ),
                  const Spacer(),
                  Text(
                    'Cash In/Out',
                    style: getMediumStyle(
                      fontSize: FontSize.s22,
                      color: ColorManager.white,
                    ),
                  ),
                  const Spacer(),
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
              SizedBox(
                height: AppHeight.h6,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      readCashInCashOutProvider!.setSelectedFromDate(readCashInCashOutProvider!.selectedFromDate.subtract(const Duration(days: 1)));
                      readCashInCashOutProvider!.setSelectedToDate(readCashInCashOutProvider!.selectedToDate.subtract(const Duration(days: 1)));
                      getApiCall();
                    },
                    icon: Icon(
                      Icons.arrow_circle_left_rounded,
                      color: ColorManager.white,
                      size: FontSize.s30,
                    ),
                  ),
                  labelStartDate,
                  Text(
                    ' - ',
                    style: getMediumStyle(fontSize: FontSize.s30, color: ColorManager.white),
                  ),
                  labelEndDate,
                  IconButton(
                    onPressed: () {
                      readCashInCashOutProvider!.setSelectedFromDate(readCashInCashOutProvider!.selectedFromDate.add(const Duration(days: 1)));
                      readCashInCashOutProvider!.setSelectedToDate(readCashInCashOutProvider!.selectedToDate.add(const Duration(days: 1)));
                      getApiCall();
                    },
                    icon: Icon(
                      Icons.arrow_circle_right_rounded,
                      color: ColorManager.white,
                      size: FontSize.s30,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            final ScrollDirection direction = notification.direction;

            if (direction == ScrollDirection.reverse) {
              readCashInCashOutProvider!.setShowBottomFalse();
            } else if (direction == ScrollDirection.forward) {
              readCashInCashOutProvider!.setShowBottomTrue();
            }

            return true;
          },
          child: const TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              AllTab(),
              CashInTab(),
              CreditTab(),
              CashOutTab(),
            ],
          ),
        ),
        bottomSheet: readCashInCashOutProvider!.showBottom
            ? Container(
                height: size.height * 0.06,
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
                          (watchCashInCashOutProvider.cashIn != null)
                              ? watchCashInCashOutProvider.cashIn!.toStringAsFixed(2)
                              : watchCashInCashOutProvider.cashIn.toString(),
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
                          'Credit: ',
                          style: getBoldStyle(
                            fontSize: FontSize.s14,
                            color: ColorManager.white,
                          ),
                        ),
                        Text(
                          (watchCashInCashOutProvider.creditAmt != null)
                              ? watchCashInCashOutProvider.creditAmt!.toStringAsFixed(2)
                              : watchCashInCashOutProvider.creditAmt.toString(),
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
                          (watchCashInCashOutProvider.cashOut != null)
                              ? watchCashInCashOutProvider.cashOut!.toStringAsFixed(2)
                              : watchCashInCashOutProvider.cashOut.toString(),
                          style: getMediumStyle(
                            fontSize: FontSize.s12,
                            color: ColorManager.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : SizedBox(width: size.width, height: AppHeight.h1),
      ),
    );
  }

  getApiCall() async {
    await context.read<CashInCashOutProvider>().getCashInCashOut(context.read<CashInCashOutProvider>().billPMode,
        context.read<CashInCashOutProvider>().selectedFromDate, context.read<CashInCashOutProvider>().selectedToDate);

    readCashInCashOutProvider!.setCashIn(readCashInCashOutProvider!.cashInCashOutModel.data!.businessTotal!.cashInTotal!);
    readCashInCashOutProvider!.setCreditAmt(readCashInCashOutProvider!.cashInCashOutModel.data!.businessTotal!.creditTotal!);
    readCashInCashOutProvider!.setCashOut(readCashInCashOutProvider!.cashInCashOutModel.data!.businessTotal!.cashOutTotal!);
  }

  void selectFromDate() async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: readCashInCashOutProvider!.selectedFromDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2090),
    );
    if (selected != null && selected != readCashInCashOutProvider!.selectedFromDate) {
      readCashInCashOutProvider!.setSelectedFromDate(selected);
      getApiCall();
      setState(() {});
    }
  }

  void selectEndDate() async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: readCashInCashOutProvider!.selectedToDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2090),
    );
    if (selected != null && selected != readCashInCashOutProvider!.selectedToDate) {
      readCashInCashOutProvider!.setSelectedToDate(selected);
      getApiCall();
      setState(() {});
    }
  }
}
