import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import 'package:webshop/commons/exporter.dart';
import 'package:webshop/provider/valid_mac_service.dart';
import 'package:webshop/view/Homepage/home_screen.dart';
import 'package:webshop/view/Login/models/user_info_model.dart';
import 'package:webshop/view/Login/widgets/fade_animation.dart';
import 'package:webshop/view/login/services/login_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginServiceProvider? readLoginServiceProvider;

  @override
  void initState() {
    super.initState();
    readLoginServiceProvider = context.read<LoginServiceProvider>();

    readLoginServiceProvider!.initPlatformState();
    getSharedPreference();
  }

  getSharedPreference() async {
    readLoginServiceProvider!.serverTextController = TextEditingController(text: sharedPref?.getString("webshop_url") ?? Strings.webShopUrl);
    readLoginServiceProvider!.userNameTextController = TextEditingController(text: sharedPref?.getString('user_name'));
    readLoginServiceProvider!.serverNameTextController = TextEditingController(text: sharedPref?.getString("server_text") ?? 'webshop');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    LoginServiceProvider watchLoginServiceProvider = context.watch<LoginServiceProvider>();
    ValidMacAddressProvider validMacAddressProvider = context.read<ValidMacAddressProvider>();

    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(93, 142, 155, 1.0),
        bottomSheet: Container(
          color: Colors.blueGrey[900],
          width: double.infinity,
          height: size.height * 0.06,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Powered by Webbook © 2022',
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
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Consumer<ConnectivityProvider>(
            builder: (context, connectivity, child) {
              return (connectivity.isOnline == false)
                  ? const NoInternet()
                  : Container(
                      width: double.infinity,
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
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  top: AppHeight.h30,
                                  right: AppWidth.w10,
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: TextFormField(
                                            controller: watchLoginServiceProvider.serverTextController,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: ColorManager.blue,
                                                ),
                                              ),
                                              labelText: "Enter server name",
                                              hintText: (sharedPref!.getString('server_text')) == null
                                                  ? 'http://182.93.85.199:8085/webshop'
                                                  : 'http://182.93.85.199:8085/${sharedPref!.getString('server_text').toString()}',
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                showAlertDialog(context);
                                                FocusScope.of(context).requestFocus(FocusNode());
                                                var siteName = Strings.webShopUrl.split(":8")[0];

                                                var newSiteName = siteName.split("//")[1];

                                                final ping = Ping(newSiteName, count: 3);

                                                ping.stream.listen(
                                                  (event) {
                                                    if (event.summary != null) {
                                                      if (event.summary!.received >= 2) {
                                                        watchLoginServiceProvider.isIpError = false;
                                                        Fluttertoast.cancel();
                                                        Fluttertoast.showToast(
                                                          msg: "Connection Successful",
                                                          toastLength: Toast.LENGTH_LONG,
                                                          gravity: ToastGravity.BOTTOM,
                                                        );
                                                      } else {
                                                        watchLoginServiceProvider.isIpError = true;
                                                        Fluttertoast.cancel();
                                                        Fluttertoast.showToast(
                                                          msg: "IP Error",
                                                          toastLength: Toast.LENGTH_LONG,
                                                          gravity: ToastGravity.BOTTOM,
                                                          backgroundColor: ColorManager.error,
                                                        );
                                                      }
                                                    }
                                                  },
                                                );
                                              },
                                              child: Text(
                                                "Ping",
                                                style: getMediumStyle(
                                                  fontSize: FontSize.s16,
                                                  color: ColorManager.blue,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                watchLoginServiceProvider.serverName = watchLoginServiceProvider.serverTextController!.text.trim();
                                                watchLoginServiceProvider.serverNameTextController!.text =
                                                    watchLoginServiceProvider.serverName.split("/")[3];
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "OK",
                                                style: getMediumStyle(
                                                  fontSize: FontSize.s16,
                                                  color: ColorManager.blue,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "Cancel",
                                                style: getMediumStyle(
                                                  fontSize: FontSize.s16,
                                                  color: ColorManager.blue,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(
                                    Icons.settings,
                                    color: ColorManager.white,
                                    size: FontSize.s20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: AppHeight.h20),
                            child: FadeAnimation(
                              2,
                              Text(
                                "WebShop",
                                style: getBoldStyle(
                                  fontSize: FontSize.s20,
                                  color: ColorManager.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: ColorManager.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(AppRadius.r40),
                                  topRight: Radius.circular(AppRadius.r40),
                                ),
                              ),
                              margin: EdgeInsets.only(top: AppHeight.h60),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: AppHeight.h20,
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      margin: EdgeInsets.only(left: AppWidth.w22),
                                      child: FadeAnimation(
                                        2,
                                        Text(
                                          "Code",
                                          style: getBoldStyle(
                                            fontSize: FontSize.s18,
                                            color: ColorManager.blackOpacity87,
                                          ),
                                        ),
                                      ),
                                    ),
                                    FadeAnimation(
                                      2,
                                      Container(
                                        width: double.infinity,
                                        height: size.height * 0.08,
                                        margin: EdgeInsets.symmetric(horizontal: AppWidth.w20, vertical: AppHeight.h10),
                                        padding: EdgeInsets.symmetric(horizontal: AppWidth.w4, vertical: AppHeight.h4),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: ColorManager.blue,
                                            width: 1,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: ColorManager.blueBright,
                                              blurRadius: AppRadius.r10,
                                              offset: const Offset(1, 1),
                                            ),
                                          ],
                                          color: ColorManager.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(AppRadius.r20),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.cloud,
                                                color: ColorManager.blueBright,
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin: const EdgeInsets.only(left: 10),
                                                child: TextFormField(
                                                  textInputAction: TextInputAction.done,
                                                  onFieldSubmitted: (value) async {
                                                    watchLoginServiceProvider.serverNameTextController!.text = value;
                                                    await sharedPref!
                                                        .setString('server_text', watchLoginServiceProvider.serverNameTextController!.text);

                                                    watchLoginServiceProvider.serverTextController!.text =
                                                        'http://182.93.85.199:8085/${sharedPref!.getString('server_text').toString()}';
                                                    setState(() {});
                                                  },
                                                  controller: watchLoginServiceProvider.serverNameTextController,
                                                  maxLines: 1,
                                                  decoration: const InputDecoration(
                                                    hintText: 'Code',
                                                    border: InputBorder.none,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      margin: EdgeInsets.only(left: AppWidth.w22),
                                      child: FadeAnimation(
                                        2,
                                        Text(
                                          "UserName",
                                          style: getBoldStyle(
                                            fontSize: FontSize.s18,
                                            color: ColorManager.blackOpacity87,
                                          ),
                                        ),
                                      ),
                                    ),
                                    FadeAnimation(
                                      2,
                                      Container(
                                        width: double.infinity,
                                        height: size.height * 0.08,
                                        margin: EdgeInsets.symmetric(horizontal: AppWidth.w20, vertical: AppHeight.h10),
                                        padding: EdgeInsets.symmetric(horizontal: AppWidth.w4, vertical: AppHeight.h4),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: ColorManager.blue,
                                            width: 1,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: ColorManager.blueBright,
                                              blurRadius: AppRadius.r10,
                                              offset: const Offset(1, 1),
                                            ),
                                          ],
                                          color: ColorManager.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(AppRadius.r20),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.person_outlined,
                                                color: ColorManager.blueBright,
                                              ),
                                              onPressed: () {},
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin: const EdgeInsets.only(left: 10),
                                                child: TextFormField(
                                                  controller: watchLoginServiceProvider.userNameTextController,
                                                  maxLines: 1,
                                                  decoration: const InputDecoration(
                                                    hintText: 'UserName',
                                                    border: InputBorder.none,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      margin: EdgeInsets.only(left: AppWidth.w22),
                                      child: FadeAnimation(
                                        2,
                                        Text(
                                          "Password",
                                          style: getBoldStyle(
                                            fontSize: FontSize.s18,
                                            color: ColorManager.blackOpacity87,
                                          ),
                                        ),
                                      ),
                                    ),
                                    FadeAnimation(
                                      2,
                                      Container(
                                        width: double.infinity,
                                        height: size.height * 0.08,
                                        margin: EdgeInsets.symmetric(horizontal: AppWidth.w20, vertical: AppHeight.h10),
                                        padding: EdgeInsets.symmetric(horizontal: AppWidth.w4, vertical: AppHeight.h4),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: ColorManager.blue,
                                            width: 1,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: ColorManager.blueBright,
                                              blurRadius: AppRadius.r10,
                                              offset: const Offset(1, 1),
                                            ),
                                          ],
                                          color: ColorManager.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(AppRadius.r20),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                watchLoginServiceProvider.passwordVisible ? Icons.visibility_off : Icons.visibility,
                                                color: ColorManager.blueBright,
                                              ),
                                              onPressed: () {
                                                watchLoginServiceProvider.makePasswordVisible();
                                              },
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin: const EdgeInsets.only(left: 10),
                                                child: TextFormField(
                                                  controller: watchLoginServiceProvider.passwordTextController,
                                                  obscureText: watchLoginServiceProvider.passwordVisible,
                                                  obscuringCharacter: '*',
                                                  maxLines: 1,
                                                  decoration: const InputDecoration(
                                                    hintText: 'Password',
                                                    border: InputBorder.none,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: AppHeight.h20,
                                    ),
                                    FadeAnimation(
                                      2,
                                      Center(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            _onLogin(watchLoginServiceProvider, validMacAddressProvider);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: ColorManager.skyBlue,
                                            shadowColor: ColorManager.skyBlue,
                                            elevation: 18,
                                            padding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(AppRadius.r20),
                                            ),
                                          ),
                                          child: Ink(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                                colors: [
                                                  ColorManager.blue,
                                                  ColorManager.blueBright,
                                                ],
                                              ),
                                              borderRadius: BorderRadius.circular(AppRadius.r20),
                                            ),
                                            child: Container(
                                              width: size.width * 0.7,
                                              height: size.height * 0.08,
                                              alignment: Alignment.center,
                                              child: watchLoginServiceProvider.loading!
                                                  ? const CircularProgressIndicator()
                                                  : Text(
                                                      'Login',
                                                      style: getBoldStyle(
                                                        fontSize: FontSize.s20,
                                                        color: ColorManager.white,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: AppHeight.h12,
                                    ),
                                    Row(
                                      children: [
                                        FadeAnimation(
                                          2,
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: AppWidth.w15, vertical: AppHeight.h6),
                                            child: InkWell(
                                              onTap: () {
                                                watchLoginServiceProvider.makeShowDevicId();
                                              },
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    height: size.height * 0.05,
                                                    child: Center(
                                                      child: Text(
                                                        watchLoginServiceProvider.showDeviceId ? 'Hide ID: ' : 'Show ID ',
                                                        style: getBoldStyle(
                                                          color: ColorManager.black,
                                                          fontSize: FontSize.s14,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: size.height * 0.05,
                                                    width: size.width * 0.55,
                                                    child: ListView(
                                                      scrollDirection: Axis.horizontal,
                                                      children: [
                                                        Center(
                                                          child: Text(
                                                            watchLoginServiceProvider.showDeviceId ? '  ${watchLoginServiceProvider.deviceId}' : '  ',
                                                            style: getMediumStyle(
                                                              color: ColorManager.red,
                                                              fontSize: FontSize.s14,
                                                            ),
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
                                        FadeAnimation(
                                          2,
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: TextButton(
                                              onPressed: () {
                                                registerPopUp(watchLoginServiceProvider, size);
                                              },
                                              child: Text(
                                                'Register',
                                                style: getBoldStyle(
                                                  color: ColorManager.green,
                                                  fontSize: FontSize.s14,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
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
      ),
    );
  }

  _onLogin(LoginServiceProvider loginServiceProvider, ValidMacAddressProvider validMacAddressProvider) async {
    await sharedPref!.setString('server_text', loginServiceProvider.serverNameTextController!.text);
    var ip = 'http://182.93.85.199:8085/';
    loginServiceProvider.serverTextController!.text = sharedPref?.getString("webshop_url") ?? '$ip${sharedPref!.getString('server_text').toString()}';

    if (loginServiceProvider.userNameTextController!.text.isEmpty || loginServiceProvider.passwordTextController.text.isEmpty) {
      loginServiceProvider.loading = false;
      Fluttertoast.cancel();
      return Fluttertoast.showToast(
        msg: "UserName/Password is Empty",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ColorManager.error,
      );
    } else if (loginServiceProvider.serverNameTextController?.text == "") {
      loginServiceProvider.loading = false;
      Fluttertoast.cancel();
      return Fluttertoast.showToast(
        msg: "Code is Empty",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ColorManager.error,
      );
    } else if (loginServiceProvider.serverTextController?.text == "") {
      loginServiceProvider.loading = false;
      Fluttertoast.cancel();
      return Fluttertoast.showToast(
        msg: "Server is Empty",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ColorManager.error,
      );
    } else if (loginServiceProvider.isIpError == true) {
      loginServiceProvider.loading = false;
      await sharedPref?.remove('token');
      Fluttertoast.cancel();
      return Fluttertoast.showToast(
        msg: "Ip Error",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ColorManager.error,
      );
    } else {
      Strings.webShopUrl = loginServiceProvider.serverTextController!.text;
      String userName = loginServiceProvider.userNameTextController!.text;
      String password = loginServiceProvider.passwordTextController.text;
      UserInfoModel userInfoModel = UserInfoModel(
        userName: userName,
        password: password,
      );
      var login = await readLoginServiceProvider!.getLogin(userInfoModel);
      var response = await validMacAddressProvider.getMacID(loginServiceProvider.deviceId.toString());

      if (login != null) {
        if (userName == "webbookmgmt") {
          await sharedPref?.setString('user_name', userName);
          if (!mounted) return;
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
              (route) => false);
        } else if (response['data'] != null) {
          await sharedPref?.setString('user_name', loginServiceProvider.userNameTextController!.text);
          if (!mounted) return;
          return Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
              (route) => false);
        } else if (response == null || response['responseType'] != 6) {
          sharedPref?.remove('token');
          loginServiceProvider.loading = false;
          Fluttertoast.cancel();
          Fluttertoast.showToast(
            msg: 'Mac Error. Contact Administrator',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: ColorManager.error,
          );
        } else {
          sharedPref?.remove('token');
          loginServiceProvider.loading = false;
          Fluttertoast.cancel();
          Fluttertoast.showToast(
            msg: 'Something went Wrong',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: ColorManager.error,
          );
        }
      } else {
        loginServiceProvider.loading = false;
        Fluttertoast.cancel();
        return Fluttertoast.showToast(
          msg: "The Username or Password is incorrect",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: ColorManager.error,
        );
      }
    }
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Exit App',
              style: getBoldStyle(
                fontSize: FontSize.s18,
                color: ColorManager.error,
              ),
            ),
            content: Text(
              'Do you want to exit an App?',
              style: getRegularStyle(
                fontSize: FontSize.s16,
                color: ColorManager.black,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                //return false when click on "NO"
                child: Text(
                  'No',
                  style: getRegularStyle(
                    fontSize: FontSize.s14,
                    color: ColorManager.green,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                //return true when click on "Yes"
                child: Text(
                  'Yes',
                  style: getRegularStyle(
                    fontSize: FontSize.s14,
                    color: ColorManager.error,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          SizedBox(
            width: AppWidth.w2,
          ),
          Container(
            margin: EdgeInsets.only(left: AppWidth.w4),
            child: Text(
              "Loading",
              style: getRegularStyle(
                fontSize: FontSize.s14,
                color: ColorManager.black,
              ),
            ),
          ),
        ],
      ),
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (cxt) {
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).maybePop();
        });
        return alert;
      },
    );
  }

  registerPopUp(LoginServiceProvider watchLoginServiceProvider, Size size) {
    showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.r10),
            ),
            backgroundColor: ColorManager.white,
            insetPadding: EdgeInsets.all(AppHeight.h10),
            title: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.r6),
                  topRight: Radius.circular(AppRadius.r6),
                ),
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
                      'Registration'.toUpperCase(),
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
                          watchLoginServiceProvider.companyNameTextController.clear();
                          watchLoginServiceProvider.vatTextController.clear();
                          watchLoginServiceProvider.mobileTextController.clear();
                          watchLoginServiceProvider.remarksTextController.clear();
                          watchLoginServiceProvider.platformResponse = "";
                        },
                        child: Icon(
                          Icons.close,
                          color: ColorManager.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            content: SizedBox(
              height: size.height * 0.45,
              width: size.width,
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: AppHeight.h10),
                        child: TextFormField(
                          controller: watchLoginServiceProvider.companyNameTextController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h20, horizontal: AppWidth.w10),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                              borderRadius: BorderRadius.circular(AppRadius.r10),
                            ),
                            labelText: 'Company Name',
                            labelStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                            hintText: 'Your Company Name',
                            hintStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: AppHeight.h10),
                        child: TextFormField(
                          controller: watchLoginServiceProvider.mobileTextController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h20, horizontal: AppWidth.w10),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                              borderRadius: BorderRadius.circular(AppRadius.r10),
                            ),
                            labelText: 'Mobile',
                            labelStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                            hintText: 'Number',
                            hintStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: AppHeight.h10),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: watchLoginServiceProvider.vatTextController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h20, horizontal: AppWidth.w10),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                              borderRadius: BorderRadius.circular(AppRadius.r10),
                            ),
                            labelText: 'Company VAT',
                            labelStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                            hintText: 'VAT',
                            hintStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: AppHeight.h10),
                        child: TextFormField(
                          controller: watchLoginServiceProvider.remarksTextController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h20, horizontal: AppWidth.w10),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                              borderRadius: BorderRadius.circular(AppRadius.r10),
                            ),
                            labelText: 'Remarks',
                            labelStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                            hintText: 'Remarks',
                            hintStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(AppHeight.h10),
                      backgroundColor: ColorManager.green,
                    ),
                    onPressed: () {
                      onSetupConfirm(watchLoginServiceProvider);
                    },
                    child: Text(
                      'Confirm',
                      style: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  onSetupConfirm(LoginServiceProvider watchLoginServiceProvider) {
    if (watchLoginServiceProvider.companyNameTextController.text.isEmpty) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: 'CompanyName is Empty',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ColorManager.error,
      );
    } else if (watchLoginServiceProvider.mobileTextController.text.isEmpty) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: 'Mobile Number is Empty',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ColorManager.error,
      );
    } else if (watchLoginServiceProvider.mobileTextController.text.length > 10 || watchLoginServiceProvider.mobileTextController.text.length < 10) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: 'Mobile Number should be 10 digit',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ColorManager.error,
      );
    } else if (watchLoginServiceProvider.vatTextController.text.isNotEmpty) {
      if (watchLoginServiceProvider.vatTextController.text.length > 9 || watchLoginServiceProvider.vatTextController.text.length < 9) {
        Fluttertoast.cancel();
        Fluttertoast.showToast(
          msg: 'Vat should be 9 digit',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: ColorManager.error,
        );
      } else {
        onSendEmail(watchLoginServiceProvider);
      }
    } else {
      onSendEmail(watchLoginServiceProvider);
    }
  }

  onSendEmail(LoginServiceProvider watchLoginServiceProvider) async {
    String company = watchLoginServiceProvider.companyNameTextController.text;
    String mobile = watchLoginServiceProvider.vatTextController.text;
    String vat = watchLoginServiceProvider.mobileTextController.text;
    String remarks = watchLoginServiceProvider.remarksTextController.text;
    String deviceId = watchLoginServiceProvider.deviceId.toString();
    String platformResponse = watchLoginServiceProvider.platformResponse;
    String code = (watchLoginServiceProvider.serverNameTextController != null) ? watchLoginServiceProvider.serverNameTextController!.text : '';

    final Email email = Email(
      body:
          'Respected Sir/Madam \n This email is written for the purpose of registration for the WebShop Mobile App that I want to implement in my business. \n The Details are as follows: \n\n Company: $company \n Vat: $vat \n Mobile: $mobile \n Code: $code  \n My device MacId: $deviceId \n Remarks: $remarks \n\n Thank You.',
      subject: 'New WebShop Account Setup',
      recipients: ['webbookhelp@gmail.com'],
      cc: ['webbookmgmt@gmail.com'],
    );

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'Email Sent Sucessfully';
    } catch (e) {
      platformResponse = e.toString();
    }

    watchLoginServiceProvider.companyNameTextController.clear();
    watchLoginServiceProvider.vatTextController.clear();
    watchLoginServiceProvider.mobileTextController.clear();
    watchLoginServiceProvider.remarksTextController.clear();
    watchLoginServiceProvider.platformResponse = "";

    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: ColorManager.black,
        content: Text(
          platformResponse,
          style: getBoldStyle(
            fontSize: FontSize.s14,
            color: ColorManager.white,
          ),
        ),
      ),
    );
  }
}
