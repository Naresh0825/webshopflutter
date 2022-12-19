import 'package:flutter/material.dart';

import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/agent/agent_page.dart';
import 'package:webshop/view/cash_in_cash_out/cash_in_cash_out_page.dart';
import 'package:webshop/view/drawer/drawer_widget.dart';
import 'package:webshop/view/purchase/purchase_entries.dart';
import 'package:webshop/view/purchase/purchase_page.dart';
import 'package:webshop/view/purchase/services/purchase_service.dart';
import 'package:webshop/view/purchase_return/purchase_return_entries.dart';
import 'package:webshop/view/recieve_payment/receive_and_payment.dart';
import 'package:webshop/view/sales/sales_entries.dart';
import 'package:webshop/view/sales/sales_page.dart';
import 'package:webshop/view/sales/services/find_sale_service.dart';
import 'package:webshop/view/sales/services/sales_service.dart';
import 'package:webshop/view/sales_return/provider/get_salesbyid_provider.dart';
import 'package:webshop/view/sales_return/sale_return.dart';
import 'package:webshop/view/stock/stock_page.dart';
import 'package:webshop/view/supplier/supplier_page.dart';
import 'package:webshop/widgets/no_data_dialog.dart';

import 'widgets/home_option_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future<void> refresh() async {
    await context.read<TabletSetupServiceProvider>().getTabletSetup();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    PurchaseServiceProvider readPurchaseServiceProvider = context.read<PurchaseServiceProvider>();
    SalesServiceProvider readSalesServiceProvider = context.read<SalesServiceProvider>();

    return Scaffold(
      key: _scaffoldKey,
      drawer: const DrawerWidget(),
      backgroundColor: Theme.of(context).colorScheme.background,
      bottomSheet: SizedBox(
        width: double.infinity,
        height: size.height * 0.055,
        child: Container(
          color: ColorManager.darkBlue,
          padding: const EdgeInsets.only(top: 4.0),
          height: 30,
          child: Column(
            children: [
              Text(
                'Powered by Webbook  © 2022',
                textAlign: TextAlign.center,
                style: getRegularStyle(
                  fontSize: FontSize.s12,
                  color: ColorManager.white,
                ),
              ),
              Text(
                'Phone : 014168260 / 014168040',
                textAlign: TextAlign.center,
                style: getRegularStyle(
                  fontSize: FontSize.s12,
                  color: ColorManager.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Consumer<ConnectivityProvider>(
        builder: (context, connectivity, child) {
          return (connectivity.isOnline == false)
              ? const NoInternet()
              : Consumer<TabletSetupServiceProvider>(
                  builder: (context, tablet, child) {
                    return (tablet.tabletSetupModel.data == null)
                        ? SizedBox(
                            height: size.height,
                            width: size.width,
                            child: const Center(
                              child: LoadingBox(),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: refresh,
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                              child: SafeArea(
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(AppRadius.r20),
                                                bottomLeft: Radius.circular(AppRadius.r20),
                                              ),
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  ColorManager.blue,
                                                  ColorManager.blueBright,
                                                ],
                                              )),
                                          height: size.height * 0.22,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: size.height * .08,
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Text(
                                              tablet.tabletSetupModel.data!.company!.name.toString().toUpperCase(),
                                              style: getBoldStyle(
                                                fontSize: FontSize.s25,
                                                color: ColorManager.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: size.width * .6,
                                          height: size.height * .05,
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Card(
                                            elevation: 5,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(AppRadius.r10),
                                            ),
                                            child: Container(
                                              height: size.height * .15,
                                              width: size.width * .9,
                                              padding: EdgeInsets.only(
                                                top: AppHeight.h8,
                                                left: AppWidth.w18,
                                                right: AppWidth.w10,
                                              ),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: size.height * .12,
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              InkWell(
                                                                highlightColor: ColorManager.orange,
                                                                splashColor: Colors.green.withOpacity(0.5),
                                                                onTap: () {
                                                                  readSalesServiceProvider.clearSalesItemList();
                                                                  readSalesServiceProvider.duplicateSalesItemList.clear();
                                                                  readSalesServiceProvider.business.clear();
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder: (context) => const SalesEntries(),
                                                                      ));
                                                                },
                                                                child: Container(
                                                                  width: size.width * 0.38,
                                                                  height: size.height * 0.11,
                                                                  decoration: BoxDecoration(
                                                                      color: ColorManager.orange,
                                                                      borderRadius: BorderRadius.all(Radius.circular(AppRadius.r5)),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Colors.black.withOpacity(0.5),
                                                                          spreadRadius: 0,
                                                                          blurRadius: 8,
                                                                          offset: const Offset(0, 5),
                                                                        )
                                                                      ]),
                                                                  child: Center(
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        Container(
                                                                          height: size.height * .065,
                                                                          width: size.width * .14,
                                                                          decoration: const BoxDecoration(
                                                                            image: DecorationImage(
                                                                              image: AssetImage("assets/images/sell.png"),
                                                                              fit: BoxFit.fill,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          'Sales Entries',
                                                                          style: getBoldStyle(
                                                                            fontSize: FontSize.s14,
                                                                            color: ColorManager.white,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: AppWidth.w4,
                                                        ),
                                                        VerticalDivider(
                                                          color: ColorManager.grey3,
                                                        ),
                                                        SizedBox(
                                                          width: AppWidth.w4,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              InkWell(
                                                                highlightColor: ColorManager.orange,
                                                                splashColor: Colors.green.withOpacity(0.5),
                                                                onTap: () {
                                                                  readPurchaseServiceProvider.isAddPurchase = true;
                                                                  readPurchaseServiceProvider.toggleIsAddPurchase(true);
                                                                  readPurchaseServiceProvider.purchaseItemList = [];
                                                                  readPurchaseServiceProvider.tempPurchaseItemList = [];
                                                                  readPurchaseServiceProvider.duplicatePurchaseItemList = [];
                                                                  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) => const PurchaseEntries(
                                                                        fromPurchase: false,
                                                                      ),
                                                                      fullscreenDialog: true,
                                                                    ),
                                                                  );
                                                                },
                                                                child: Container(
                                                                  width: size.width * 0.38,
                                                                  height: size.height * 0.11,
                                                                  decoration: BoxDecoration(
                                                                      color: ColorManager.orange,
                                                                      borderRadius: BorderRadius.all(Radius.circular(AppRadius.r5)),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Colors.black.withOpacity(0.5),
                                                                          spreadRadius: 1,
                                                                          blurRadius: 8,
                                                                          offset: const Offset(0, 5),
                                                                        )
                                                                      ]),
                                                                  child: Center(
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        Container(
                                                                          height: size.height * .065,
                                                                          width: size.width * .14,
                                                                          decoration: const BoxDecoration(
                                                                            image: DecorationImage(
                                                                              image: AssetImage("assets/images/buy.png"),
                                                                              fit: BoxFit.fill,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          'Purchase Entries',
                                                                          style: getBoldStyle(
                                                                            fontSize: FontSize.s14,
                                                                            color: ColorManager.white,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: size.height * .02),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: EdgeInsets.only(left: AppWidth.w15, right: AppWidth.w15),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.background,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              padding: EdgeInsets.symmetric(horizontal: AppHeight.h4, vertical: AppHeight.h4),
                                              height: size.height * 0.39,
                                              width: size.width * 0.9,
                                              child: GridView(
                                                physics: const NeverScrollableScrollPhysics(),
                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisSpacing: size.width * 0.01,
                                                  mainAxisSpacing: size.height * 0.01,
                                                  childAspectRatio: 3 / 2,
                                                  crossAxisCount: 4,
                                                  mainAxisExtent: size.height * 0.12,
                                                ),
                                                children: [
                                                  HomeOptions(
                                                    imageLink: "assets/images/customer.png",
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => const AgentPage(),
                                                          ));
                                                    },
                                                    text: 'Customers',
                                                    size: size,
                                                    icon: Icons.people_outlined,
                                                  ),
                                                  HomeOptions(
                                                    imageLink: "assets/images/supplier.png",
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => const SupplierPage(),
                                                          ));
                                                    },
                                                    text: 'Suppliers',
                                                    size: size,
                                                    icon: Icons.credit_card_rounded,
                                                  ),
                                                  HomeOptions(
                                                    imageLink: "assets/images/salesList.png",
                                                    onTap: () {
                                                      context.read<SaleSummaryServiceProvider>().findSaleModel.data = null;
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => const SalesPage(isSalesReturn: false),
                                                          ));
                                                    },
                                                    text: 'Sales List',
                                                    size: size,
                                                    icon: Icons.point_of_sale_outlined,
                                                  ),
                                                  HomeOptions(
                                                    imageLink: "assets/images/salesList.png",
                                                    onTap: () {
                                                      context.read<SaleSummaryServiceProvider>().findSaleModel.data = null;

                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => const SalesPage(isSalesReturn: true),
                                                          ));
                                                    },
                                                    text: 'Sales Return List',
                                                    size: size,
                                                    icon: Icons.point_of_sale_outlined,
                                                  ),
                                                  HomeOptions(
                                                    imageLink: "assets/images/purchaseList.png",
                                                    onTap: () {
                                                      tablet.supplierList = null;
                                                      context.read<PurchaseServiceProvider>().purchaseModel.data = null;
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => const PurchasePage(
                                                              isPurchaseReturn: false,
                                                            ),
                                                          ));
                                                    },
                                                    text: 'Purchase List',
                                                    size: size,
                                                    icon: Icons.add_shopping_cart_outlined,
                                                  ),
                                                  HomeOptions(
                                                    imageLink: "assets/images/purchaseList.png",
                                                    onTap: () {
                                                      tablet.supplierList = null;
                                                      context.read<PurchaseServiceProvider>().purchaseModel.data = null;
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => const PurchasePage(
                                                              isPurchaseReturn: true,
                                                            ),
                                                          ));
                                                    },
                                                    text: 'Purchase Return List',
                                                    size: size,
                                                    icon: Icons.add_shopping_cart_outlined,
                                                  ),
                                                  HomeOptions(
                                                    imageLink: "assets/images/stockicon.png",
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => const StockPage(),
                                                          ));
                                                    },
                                                    text: 'Stock',
                                                    size: size,
                                                    icon: Icons.store_outlined,
                                                  ),
                                                  HomeOptions(
                                                    imageLink: "assets/images/sales_return.png",
                                                    onTap: () {
                                                      context.read<GetSalesByIdProvider>().initialSalesReturnList.clear();
                                                      context.read<GetSalesByIdProvider>().salesReturnCancelList.clear();
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => const SalesReturnEntries(),
                                                        ),
                                                      );
                                                    },
                                                    text: 'Sales Return',
                                                    size: size,
                                                    icon: Icons.people_outlined,
                                                  ),
                                                  HomeOptions(
                                                    imageLink: "assets/images/purchase_return.png",
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => const PurchaseReturnEntries(),
                                                        ),
                                                      );
                                                    },
                                                    text: 'Purchase Return',
                                                    size: size,
                                                    icon: Icons.credit_card_rounded,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: AppWidth.w15, right: AppWidth.w15),
                                          child: Row(
                                            children: [
                                              Text(
                                                'Other Activities',
                                                style: getSemiBoldStyle(fontSize: FontSize.s18, color: ColorManager.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: size.height * .01),
                                        Padding(
                                          padding: EdgeInsets.only(left: AppWidth.w15, right: AppWidth.w15),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.background,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            padding: EdgeInsets.symmetric(horizontal: AppHeight.h4, vertical: AppHeight.h4),
                                            height: size.height * 0.15,
                                            width: size.width * 0.9,
                                            child: GridView(
                                              physics: const NeverScrollableScrollPhysics(),
                                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisSpacing: size.width * 0.01,
                                                mainAxisSpacing: size.height * 0.01,
                                                childAspectRatio: 3 / 2,
                                                crossAxisCount: 4,
                                                mainAxisExtent: size.height * 0.12,
                                              ),
                                              children: [
                                                HomeOptions(
                                                  imageLink: "assets/images/payment-method.png",
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => const CashInCashOutPage(),
                                                      ),
                                                    );
                                                  },
                                                  text: 'CashIn/Out',
                                                  size: size,
                                                  icon: Icons.money,
                                                ),
                                                HomeOptions(
                                                  imageLink: "assets/images/money_in.png",
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) => const RecieveAndPaymentPage(
                                                                isReceive: true,
                                                              ),
                                                          fullscreenDialog: true),
                                                    );
                                                  },
                                                  text: 'Recieve',
                                                  size: size,
                                                  icon: Icons.credit_card_rounded,
                                                ),
                                                HomeOptions(
                                                  imageLink: "assets/images/money_out.png",
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) => const RecieveAndPaymentPage(
                                                                isReceive: false,
                                                              ),
                                                          fullscreenDialog: true),
                                                    );
                                                  },
                                                  text: 'Payment',
                                                  size: size,
                                                  icon: Icons.people_outlined,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      top: size.height * 0.01,
                                      left: size.width * 0.02,
                                      child: IconButton(
                                        onPressed: () {
                                          _scaffoldKey.currentState!.openDrawer();
                                        },
                                        icon: Icon(
                                          Icons.menu,
                                          color: ColorManager.white,
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
        },
      ),
    );
  }
}
