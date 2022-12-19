import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:platform_device_id/platform_device_id.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/Login/models/user_info_model.dart';

class LoginServiceProvider extends ChangeNotifier {
  bool isIpError = false;
  bool? loading = false;

  TextEditingController? serverTextController;
  TextEditingController? userNameTextController;
  TextEditingController? serverNameTextController;
  TextEditingController passwordTextController = TextEditingController();

  //for mail
  String platformResponse = '';
  TextEditingController companyNameTextController = TextEditingController();
  TextEditingController vatTextController = TextEditingController();
  TextEditingController mobileTextController = TextEditingController();
  TextEditingController remarksTextController = TextEditingController();

  bool passwordVisible = true;
  String? deviceId;
  bool showDeviceId = false;

  String serverName = "";

  Future<dynamic> getLogin(UserInfoModel userModel) async {
    loading = true;
    notifyListeners();
    var client = http.Client();
    dynamic jsonData;
    final url = Uri.parse("${Strings.webShopUrl}${Strings.login}");
    Map body = {
      "UserName": userModel.userName,
      "Password": userModel.password,
    };

    try {
      var response = await client.post(
        url,
        body: json.encode(body),
        headers: {
          "content-type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        jsonData = jsonDecode(response.body);

        loading = false;
        notifyListeners();
        await sharedPref?.setString('webstore_url', Strings.webShopUrl);
        await sharedPref?.setString('token', jsonData['token']);
        await sharedPref?.setString('staffId', jsonData['staffId']);
        await sharedPref?.setString('userType', jsonData['userType']);
      } else if (response.statusCode == 400) {}
    } on Exception catch (e) {
      log(e.toString(), name: 'login error');
    }
    loading = false;
    return jsonData;
  }

  Future<void> initPlatformState() async {
    String deviceId1;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      deviceId1 = (await PlatformDeviceId.getDeviceId)!;
    } on PlatformException {
      deviceId1 = 'Failed to get deviceId.';
    }

    deviceId = deviceId1;
    notifyListeners();
  }

  makePasswordVisible() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  makeShowDevicId() {
    showDeviceId = !showDeviceId;
    notifyListeners();
  }
}
