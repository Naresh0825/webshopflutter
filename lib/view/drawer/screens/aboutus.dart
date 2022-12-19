// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/drawer/widgets/aboutus_contact.dart';
import 'package:webshop/view/homepage/home_screen.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            height: size.height,
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding: EdgeInsets.all(AppHeight.h10),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HomeScreen(),
                            ),
                            (route) => false);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: ColorManager.black,
                        size: FontSize.s20,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.1,
                  child: Image.asset(
                    'assets/images/logo.png',
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Software Company',
                    style: getBoldStyle(
                      fontSize: FontSize.s14,
                      color: ColorManager.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: AppHeight.h6,
                ),
                Divider(
                  height: AppHeight.h2,
                  thickness: AppHeight.h2,
                  color: ColorManager.blueBright,
                ),
                SizedBox(
                  height: AppHeight.h10,
                ),
                AboutUsContact(
                  onTap: () => launch(website),
                  icon: FontAwesomeIcons.internetExplorer,
                  contactName: 'www.webbook.com.np',
                  iconColor: ColorManager.blueBright,
                ),
                AboutUsContact(
                  onTap: () => launch('tel:$phoneNumber'),
                  icon: FontAwesomeIcons.phone,
                  contactName: phoneNumber,
                  iconColor: ColorManager.blue,
                ),
                AboutUsContact(
                  onTap: () => launch(youtube),
                  icon: FontAwesomeIcons.youtube,
                  contactName: 'Youtube',
                  iconColor: ColorManager.red,
                ),
                AboutUsContact(
                  onTap: () => launch('mailto:$email'),
                  icon: Icons.mail,
                  contactName: email,
                  iconColor: ColorManager.black,
                ),
                AboutUsContact(
                  onTap: () => launch('https://www.facebook.com/$facebookHandle'),
                  icon: FontAwesomeIcons.facebook,
                  contactName: 'Facebook',
                  iconColor: ColorManager.darkBlue,
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: SizedBox(
        width: double.infinity,
        height: size.height * 0.06,
        child: Container(
          padding: EdgeInsets.only(top: AppHeight.h6, bottom: AppHeight.h4),
          height: AppHeight.h28,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ColorManager.blue,
                ColorManager.blueBright,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              tileMode: TileMode.clamp,
            ),
          ),
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
    );
  }
}
