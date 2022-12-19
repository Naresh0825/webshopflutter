import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/homepage/home_screen.dart';
import 'package:webshop/view/supplier/model/supplier_due_model.dart';
import 'package:webshop/view/supplier/model/supplier_model.dart';
import 'package:webshop/view/supplier/screens/add_supplier_screen.dart';
import 'package:webshop/view/supplier/screens/supplier_cash_payment_dialogue_screen.dart';
import 'package:webshop/view/supplier/screens/supplier_statement_screen.dart';
import 'package:webshop/widgets/item_widgets.dart';
import 'package:webshop/widgets/no_data_dialog.dart';
import 'package:webshop/widgets/search_widgets.dart';

import 'provider/get_supplier_due.dart';
import 'provider/supplier_satement_provider.dart';

class SupplierPage extends StatefulWidget {
  const SupplierPage({super.key});

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  bool switchSelected = false;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    refresh();
    super.initState();
  }

  TextEditingController searchController = TextEditingController();

  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  Future<void> refresh() async {
    await context.read<SupplierDueServiceProvider>().getSupplierDue();

    if (sharedPref!.getBool('switchSelected') == null) {
      sharedPref!.setBool('switchSelected', switchSelected);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    SupplierDueServiceProvider watchSupplierDueServiceProvider = context.watch<SupplierDueServiceProvider>();
    SupplierStatementProvider watchSupplierStatementProvider = context.watch<SupplierStatementProvider>();
    TabletSetupServiceProvider readTabletSetupServiceProvider = context.read<TabletSetupServiceProvider>();

    return WillPopScope(
      onWillPop: () async {
        if (isDialOpen.value) {
          isDialOpen.value = false;
          return false;
        } else {
          return true;
        }
      },
      child: Consumer<ConnectivityProvider>(
        builder: (context, connectivity, child) {
          return (connectivity.isOnline == false)
              ? const NoInternet()
              : Scaffold(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  body: SingleChildScrollView(
                    child: SafeArea(
                      child: Column(
                        children: [
                          // SupplierAppBarWidget(
                          //   searchController: searchController,
                          // ),
                          Container(
                            margin: EdgeInsets.only(bottom: AppHeight.h10),
                            padding: EdgeInsets.all(AppHeight.h14),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  ColorManager.blue,
                                  ColorManager.blueBright,
                                ],
                              ),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(AppRadius.r10),
                                bottomRight: Radius.circular(AppRadius.r10),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pushAndRemoveUntil(
                                            MaterialPageRoute(
                                              builder: (context) => const HomeScreen(),
                                            ),
                                            (route) => false);
                                      },
                                      icon: Icon(
                                        Icons.arrow_back,
                                        color: ColorManager.white,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      'Supplier',
                                      style: getBoldStyle(
                                        fontSize: FontSize.s20,
                                        color: ColorManager.white,
                                      ),
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        sharedPref!.getBool('switchSelected') == true
                                            ? Text(
                                                'Due Only',
                                                style: getMediumStyle(
                                                  fontSize: FontSize.s14,
                                                  color: ColorManager.white,
                                                ),
                                              )
                                            : Text(
                                                'Show All',
                                                style: getMediumStyle(
                                                  fontSize: FontSize.s14,
                                                  color: ColorManager.white,
                                                ),
                                              ),
                                        Switch(
                                          activeColor: ColorManager.darkGreen,
                                          value: sharedPref!.getBool('switchSelected') ?? switchSelected,
                                          onChanged: (value) {
                                            setState(() {
                                              switchSelected = value;
                                              sharedPref!.setBool('switchSelected', switchSelected);
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                SearchWidget(
                                  searchTextEditingController: searchController,
                                  onChanged: (value) {
                                    watchSupplierDueServiceProvider.searchSupplier(value);

                                    (sharedPref!.getBool('switchSelected') == true)
                                        ? readTabletSetupServiceProvider.searchSupplierListShowall(value)
                                        : watchSupplierDueServiceProvider.searchSupplier(value);
                                  },
                                  onPressed: () {
                                    searchController.clear();
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    watchSupplierDueServiceProvider.searchSupplier('');
                                    readTabletSetupServiceProvider.searchSupplierListShowall('');
                                  },
                                ),
                              ],
                            ),
                          ),
                          Consumer<ConnectivityProvider>(
                            builder: (context, connectivity, child) {
                              return (connectivity.isOnline == false)
                                  ? const NoInternet()
                                  : Consumer<SupplierDueServiceProvider>(
                                      builder: (context, supplierDue, child) {
                                        return supplierDue.supplierDueModel.data == null
                                            ? SizedBox(
                                                height: size.height * .75,
                                                width: size.width,
                                                child: const Center(
                                                  child: LoadingBox(),
                                                ),
                                              )
                                            : RefreshIndicator(
                                                onRefresh: refresh,
                                                child: SingleChildScrollView(
                                                  child: SizedBox(
                                                    height: size.height * .75,
                                                    width: size.width,
                                                    child: ListView.builder(
                                                      itemCount: (searchController.text.isNotEmpty)
                                                          ? supplierDue.searchSupplierList.length
                                                          : supplierDue.supplierDueModel.data!.length,
                                                      itemBuilder: (BuildContext context, int index) {
                                                        SupplierDue data;
                                                        var newsearchData = supplierDue.searchSupplierList
                                                          ..sort(
                                                            (a, b) => a.supName.toString().toLowerCase().compareTo(
                                                                  b.supName.toString().toLowerCase(),
                                                                ),
                                                          );
                                                        var newData = supplierDue.supplierDueModel.data!
                                                          ..sort(
                                                            (a, b) => a.supName.toString().toLowerCase().compareTo(
                                                                  b.supName.toString().toLowerCase(),
                                                                ),
                                                          );

                                                        (searchController.text.isNotEmpty) ? data = newsearchData[index] : data = newData[index];

                                                        return (sharedPref!.getBool('switchSelected') == true && data.supAmount! <= 0.0)
                                                            ? Container()
                                                            : gestureDetectorSupplierMethod(
                                                                context, data, watchSupplierStatementProvider, readTabletSetupServiceProvider);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              );
                                      },
                                    );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  bottomSheet: Consumer<ConnectivityProvider>(
                    builder: (context, connectivity, child) {
                      return Container(
                        height: size.height * 0.05,
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Total: ',
                              style: getRegularStyle(
                                fontSize: FontSize.s15,
                                color: ColorManager.white,
                              ),
                            ),
                            (connectivity.isOnline == false)
                                ? Icon(
                                    Icons.signal_wifi_connected_no_internet_4,
                                    color: ColorManager.white,
                                  )
                                : Text(
                                    watchSupplierDueServiceProvider.creditorTotal.toStringAsFixed(2),
                                    style: getRegularStyle(
                                      fontSize: FontSize.s15,
                                      color: ColorManager.white,
                                    ),
                                  ),
                          ],
                        ),
                      );
                    },
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => const AddSupplierScreen(),
                            fullscreenDialog: true,
                          ));
                    },
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.add),
                  ),
                );
        },
      ),
    );
  }

  gestureDetectorSupplierMethod(BuildContext context, SupplierDue data, SupplierStatementProvider watchSupplierStatementProvider,
      TabletSetupServiceProvider tabletSetupServiceProvider) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.6,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              SupplierModel supplierModel = SupplierModel(
                supId: data.supId!,
                supName: data.supName!,
                supVat: data.supVatNo ?? 0,
                supAddress: data.supAddress.toString(),
                supMobile: data.supMobile.toString(),
                supPhone: data.supPhone.toString(),
                supOpDate: data.supOpDate.toString(),
                supOpAmt: data.supOpAmount!,
                supAmt: data.supAmount!,
                supInActive: data.supInActive!,
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddSupplierScreen(
                    supplierModel: supplierModel,
                  ),
                  fullscreenDialog: true,
                ),
              );
            },
            backgroundColor: const Color(0xFF21B7CA),
            foregroundColor: ColorManager.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (context) {
              watchSupplierStatementProvider.setFromDate(DateTime.parse(tabletSetupServiceProvider.tabletSetupModel.data!.fiscalYear!.startDate!));
              watchSupplierStatementProvider.selectedToDate = DateTime.now();
              watchSupplierStatementProvider.balance = 0.0;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SupplierStatementScreen(
                    supId: int.parse(
                      data.supId.toString(),
                    ),
                  ),
                ),
              );
            },
            backgroundColor: ColorManager.grey,
            foregroundColor: ColorManager.white,
            icon: Icons.history,
            label: 'History',
          ),
          SlidableAction(
            onPressed: (context) {
              showDialog(
                context: context,
                builder: (context) => SupplierCashPaymentDialogueScreen(
                  supId: int.parse(
                    data.supId.toString(),
                  ),
                  billDescription: data.supName.toString(),
                ),
              );
            },
            backgroundColor: ColorManager.amber,
            foregroundColor: ColorManager.white,
            icon: Icons.receipt,
            label: 'Payment',
          ),
        ],
      ),
      child: Column(
        children: [
          ItemWidget(
            code: data.supId.toString(),
            productName: data.supName.toString(),
            productAddress: data.supAddress.toString(),
            price: double.parse(data.supAmount.toString()),
            onTap: () {},
            phoneNumber: data.supMobile.toString(),
            date: data.supOpDate.toString().split("T")[0],
            type: 'Supplier',
          ),
          Divider(
            height: AppHeight.h1,
            color: ColorManager.black,
          )
        ],
      ),
    );
  }
}
