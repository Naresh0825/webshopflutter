import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/Login/screens/login_screen.dart';
import 'commons/theme_manager.dart';
import 'view/Homepage/home_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();

    context.read<ConnectivityProvider>().startMonitoring();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => MaterialApp(
        title: 'WebShop',
        debugShowCheckedModeBanner: false,
        theme: getApplicationTheme(),
        home: SplashScreenView(
          navigateRoute: (sharedPref?.getString('token') != null) ? const HomeScreen() : const LoginScreen(),
          text: 'Powered by Webbook',
          textType: TextType.TyperAnimatedText,
          textStyle: TextStyle(
            fontSize: FontSize.s30,
            fontFamily: 'Ms Madi',
            letterSpacing: 2.0,
            fontWeight: FontWeightManager.bold,
            color: ColorManager.deepPurple,
          ),
          duration: 2500,
          backgroundColor: ColorManager.white,
        ),
      ),
    );
  }
}
