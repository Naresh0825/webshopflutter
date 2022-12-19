import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/provider/valid_mac_service.dart';
import 'package:webshop/view/homepage/home_screen.dart';
import 'package:webshop/view/login/screens/login_screen.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController printerIpController = TextEditingController();
  TextEditingController macIdTextEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    ValidMacAddressProvider readValidMacAddressProvider = context.read<ValidMacAddressProvider>();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: getMediumStyle(
            fontSize: FontSize.s18,
            color: ColorManager.white,
          ),
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
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SettingsListTile(
                icon: Icons.print,
                onTap: () {
                  printerIpPopUp(context, size, printerIpController);
                },
                heading: 'Add Printer Ip',
              ),
              (sharedPref!.getString('user_name') == "webbookmgmt")
                  ? SettingsListTile(
                      icon: Icons.add_outlined,
                      onTap: () {
                        addMacId(context, size, macIdTextEditingController, readValidMacAddressProvider);
                      },
                      heading: 'Add Mac Id',
                    )
                  : Container(),
              SettingsListTile(
                icon: Icons.logout,
                onTap: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text(
                        'LogOut',
                        style: getMediumStyle(fontSize: FontSize.s20, color: ColorManager.black),
                      ),
                      content: Text(
                        'Are you sure you want to log Out?',
                        style: getRegularStyle(fontSize: FontSize.s16, color: ColorManager.black),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            logout();
                            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                                (route) => false);
                          },
                          child: const Text('Yes'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('No'),
                        ),
                      ],
                    ),
                  );
                },
                heading: 'Log Out',
              ),
            ],
          ),
        ),
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

class SettingsListTile extends StatelessWidget {
  final String heading;
  final String? subHeading;
  final Function() onTap;
  final IconData? icon;
  const SettingsListTile({
    Key? key,
    required this.onTap,
    required this.heading,
    this.subHeading,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        child: ListTile(
          title: Text(
            heading,
            style: getMediumStyle(fontSize: FontSize.s18, color: ColorManager.black),
          ),
          trailing: Icon(
            icon ?? Icons.arrow_forward_ios,
            color: ColorManager.grey,
            size: FontSize.s25,
          ),
        ),
      ),
    );
  }
}
