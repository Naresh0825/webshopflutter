import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/provider/valid_mac_service.dart';
import 'package:webshop/view/agent/provider/agent_statement_provider.dart';
import 'package:webshop/view/agent/screens/agent_statement_screen.dart';
import 'package:webshop/view/cash_in_cash_out/cash_book_report.dart';
import 'package:webshop/view/cash_in_cash_out/cash_in_cash_out_page.dart';
import 'package:webshop/view/homepage/home_screen.dart';
import 'package:webshop/view/login/screens/login_screen.dart';
import 'package:webshop/view/sales/reports/sales_detail_report.dart';
import 'package:webshop/view/sales/reports/sales_summary_report.dart';
import 'package:webshop/view/settings_page/settings_page.dart';
import 'package:webshop/view/stock/reports/stock_detail_report.dart';
import 'package:webshop/view/stock/reports/stock_statement_report.dart';
import 'package:webshop/view/stock/reports/stock_summary_report.dart';
import 'package:webshop/view/supplier/provider/supplier_satement_provider.dart';
import 'package:webshop/view/supplier/screens/supplier_statement_screen.dart';


class DrawerWidget extends StatefulWidget {
  const DrawerWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  TextEditingController printerIpController = TextEditingController();
  TextEditingController macIdTextEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TabletSetupServiceProvider watchTabletSetupServiceProvider = context.watch<TabletSetupServiceProvider>();
    AgentStatementProvider watchAgentStatementProvider = context.watch<AgentStatementProvider>();
    SupplierStatementProvider watchSupplierStatementProvider = context.watch<SupplierStatementProvider>();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: size.height * 0.2,
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
            child: Image.asset('assets/images/logo.png'),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                  (route) => false);
            },
            child: ListTile(
              leading: FaIcon(
                FontAwesomeIcons.house,
                color: ColorManager.black,
                size: FontSize.s18,
              ),
              title: Text(
                'Home',
                style: getMediumStyle(fontSize: FontSize.s16, color: ColorManager.black),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsPage(),
                ),
              );
            },
            child: ListTile(
              leading: FaIcon(
                Icons.settings,
                color: ColorManager.black,
                size: FontSize.s18,
              ),
              title: Text(
                'Settings',
                style: getMediumStyle(
                  fontSize: FontSize.s16,
                  color: ColorManager.black,
                ),
              ),
            ),
          ),
          Divider(
            color: ColorManager.blackOpacity54,
            thickness: AppHeight.h1,
          ),
          InkWell(
            onTap: () {
              watchAgentStatementProvider
                  .setSelectedFromDate(DateTime.parse(watchTabletSetupServiceProvider.tabletSetupModel.data!.fiscalYear!.startDate!));
              watchAgentStatementProvider.selectedToDate = DateTime.now();
              watchAgentStatementProvider.balance = 0.0;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AgentStatementScreen(
                    isDrawer: true,
                  ),
                ),
              );
            },
            child: ListTile(
              leading: FaIcon(
                FontAwesomeIcons.noteSticky,
                color: ColorManager.black,
                size: FontSize.s18,
              ),
              title: Text(
                'Customer Statement',
                style: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              watchSupplierStatementProvider
                  .setFromDate(DateTime.parse(watchTabletSetupServiceProvider.tabletSetupModel.data!.fiscalYear!.startDate!));
              watchSupplierStatementProvider.selectedToDate = DateTime.now();
              watchSupplierStatementProvider.balance = 0.0;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SupplierStatementScreen(
                    isDrawer: true,
                  ),
                ),
              );
            },
            child: ListTile(
              leading: Icon(
                FontAwesomeIcons.noteSticky,
                color: ColorManager.black,
                size: FontSize.s18,
              ),
              title: Text(
                'Supplier Statement',
                style: getMediumStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.black,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StockSummaryReport(
                    isDrawer: true,
                  ),
                ),
              );
            },
            child: ListTile(
              leading: Icon(
                Icons.inventory,
                color: ColorManager.black,
                size: FontSize.s20,
              ),
              title: Text(
                'Stock Summary',
                style: getMediumStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.black,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StockStatementReport(
                    isDrawer: true,
                  ),
                ),
              );
            },
            child: ListTile(
              leading: Icon(
                Icons.inventory,
                color: ColorManager.black,
                size: FontSize.s20,
              ),
              title: Text(
                'Stock Statement',
                style: getMediumStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.black,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StockDetailReport(
                    isDrawer: true,
                  ),
                ),
              );
            },
            child: ListTile(
              leading: Icon(
                Icons.inventory,
                color: ColorManager.black,
                size: FontSize.s20,
              ),
              title: Text(
                'Stock Detail',
                style: getMediumStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.black,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SalesSummaryReport(
                    isDrawer: true,
                  ),
                ),
              );
            },
            child: ListTile(
              leading: FaIcon(
                Icons.sell,
                color: ColorManager.black,
                size: FontSize.s20,
              ),
              title: Text(
                'Sales Summary',
                style: getMediumStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.black,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SalesDetailReport(
                    isDrawer: true,
                  ),
                ),
              );
            },
            child: ListTile(
              leading: Icon(
                Icons.sell,
                color: ColorManager.black,
                size: FontSize.s20,
              ),
              title: Text(
                'Sales Detail',
                style: getMediumStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.black,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CashBookReport(
                    isDrawer: true,
                  ),
                ),
              );
            },
            child: ListTile(
              leading: Icon(
                Icons.money,
                color: ColorManager.black,
                size: FontSize.s20,
              ),
              title: Text(
                'Cash Book',
                style: getMediumStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.black,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CashInCashOutPage(
                    isDrawer: true,
                  ),
                ),
              );
            },
            child: ListTile(
              leading: Icon(
                Icons.money,
                color: ColorManager.black,
                size: FontSize.s20,
              ),
              title: Text(
                'CashIn/Out',
                style: getMediumStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.black,
                ),
              ),
            ),
          ),
          Divider(color: ColorManager.blackOpacity54),
          InkWell(
            onTap: () {
              logout();
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (route) => false);
            },
            child: ListTile(
              leading: Icon(
                Icons.logout,
                color: ColorManager.black,
                size: FontSize.s20,
              ),
              title: Text(
                'Logout',
                style: getMediumStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.black,
                ),
              ),
            ),
          ),
          Divider(color: ColorManager.blackOpacity54),
        ],
      ),
    );
  }

  void printerIpPopUp(BuildContext context, Size size, TextEditingController printerIpController) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: ColorManager.white,
          insetPadding: const EdgeInsets.all(10),
          child: SizedBox(
            width: size.width,
            height: size.height * .35,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(AppRadius.r6), topRight: Radius.circular(AppRadius.r6)),
                    color: ColorManager.cadiumBlue,
                  ),
                  width: size.width,
                  height: size.height * 0.06,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          left: AppHeight.h8,
                        ),
                        child: Text(
                          'Add Printer'.toUpperCase(),
                          style: getBoldStyle(
                            color: ColorManager.white,
                            fontSize: FontSize.s14,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(
                          AppHeight.h10,
                        ),
                        child: CircleAvatar(
                          radius: AppRadius.r14,
                          backgroundColor: ColorManager.white,
                          child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(Icons.remove)),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // padding: EdgeInsets.only(top: AppHeight.h10),
                  padding: EdgeInsets.only(left: AppWidth.w20, right: AppWidth.w20, top: AppHeight.h10),
                  height: size.height * 0.2,
                  width: size.width,
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Printer Ip',
                          style: getBoldStyle(fontSize: FontSize.s16, color: ColorManager.black),
                        ),
                        SizedBox(
                          height: AppHeight.h10,
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: AppHeight.h10),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.characters,
                            controller: printerIpController,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h20, horizontal: AppWidth.w10),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                  borderRadius: BorderRadius.circular(AppRadius.r10),
                                ),
                                labelText: 'Add Printer Ip',
                                labelStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                hintText: 'Add Printer Ip',
                                hintStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                floatingLabelBehavior: FloatingLabelBehavior.always),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '*Required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(AppHeight.h10),
                    backgroundColor: ColorManager.green,
                  ),
                  onPressed: () {
                    onAddPrinterIp(printerIpController);
                    printerIpController.clear();
                  },
                  child: Text(
                    'Add Ip',
                    style: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void addMacId(
      BuildContext context, Size size, TextEditingController macIdTextEditingController, ValidMacAddressProvider readValidMacAddressProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: ColorManager.white,
          insetPadding: const EdgeInsets.all(10),
          child: SizedBox(
            width: size.width,
            height: size.height * .35,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(AppRadius.r6), topRight: Radius.circular(AppRadius.r6)),
                    color: ColorManager.cadiumBlue,
                  ),
                  width: size.width,
                  height: size.height * 0.06,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          left: AppHeight.h8,
                        ),
                        child: Text(
                          'Add Mac'.toUpperCase(),
                          style: getBoldStyle(
                            color: ColorManager.white,
                            fontSize: FontSize.s14,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(
                          AppHeight.h10,
                        ),
                        child: CircleAvatar(
                          radius: AppRadius.r14,
                          backgroundColor: ColorManager.white,
                          child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(Icons.remove)),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // padding: EdgeInsets.only(top: AppHeight.h10),
                  padding: EdgeInsets.only(left: AppWidth.w20, right: AppWidth.w20, top: AppHeight.h10),
                  height: size.height * 0.15,
                  width: size.width,
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mac Id',
                          style: getBoldStyle(fontSize: FontSize.s16, color: ColorManager.black),
                        ),
                        SizedBox(
                          height: AppHeight.h10,
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: AppHeight.h10),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.characters,
                            controller: macIdTextEditingController,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h20, horizontal: AppWidth.w10),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                  borderRadius: BorderRadius.circular(AppRadius.r10),
                                ),
                                labelText: 'Add Mac Id',
                                labelStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                hintText: 'Add Mac Id',
                                hintStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                floatingLabelBehavior: FloatingLabelBehavior.always),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '*Required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(AppHeight.h10),
                    backgroundColor: ColorManager.green,
                  ),
                  onPressed: () {
                    onAddMacId(readValidMacAddressProvider, macIdTextEditingController);
                  },
                  child: Text(
                    'Add Mac',
                    style: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  onAddPrinterIp(TextEditingController printerIpController) async {
    if (formKey.currentState!.validate()) {
      String ip = printerIpController.text;
      await sharedPref!.setString('printer_ip', printerIpController.text);

      if (sharedPref!.getString('printer_ip') == ip) {
        printIp = sharedPref!.getString('printer_ip');
        Fluttertoast.showToast(
          msg: 'Printer Ip Added',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: ColorManager.green,
        );
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
      } else {
        Fluttertoast.cancel();
        return Fluttertoast.showToast(
          msg: 'Error occured',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: ColorManager.error,
        );
      }
    }
  }

  onAddMacId(ValidMacAddressProvider validMacAddressProvider, TextEditingController macIdTextEditingController) async {
    if (formKey.currentState!.validate()) {
      var response = await validMacAddressProvider.addMacID(macIdTextEditingController.text);

      if (response != null) {
        if (response["responseType"] == 6) {
          Fluttertoast.showToast(
            msg: 'Mac Id Added Successfully',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: ColorManager.green,
          );
          if (!mounted) return;
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
        } else {
          Fluttertoast.cancel();
          return Fluttertoast.showToast(
            msg: 'Cannot Add Mac Error',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: ColorManager.error,
          );
        }
      } else {
        Fluttertoast.cancel();
        return Fluttertoast.showToast(
          msg: 'Error occured',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: ColorManager.error,
        );
      }
    }
  }

  logout() {
    sharedPref!.remove('token');
    sharedPref!.remove('staffId');
    sharedPref!.remove('switchSelected');
    sharedPref!.remove('switch_selected');
    sharedPref!.remove('printer_ip');
    sharedPref!.remove('userType');
  }
}
