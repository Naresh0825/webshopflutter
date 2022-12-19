import 'package:webshop/commons/exporter.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: ColorManager.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: size.height * 0.5,
            width: size.width,
            margin: EdgeInsets.fromLTRB(0, 0, 0, AppHeight.h24),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/no_connection.png"),
              ),
            ),
          ),
          Text(
            'No Internet Connection',
            style: getMediumStyle(
              fontSize: FontSize.s18,
              color: ColorManager.error,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(AppHeight.h14),
            child: Center(
              child: Text(
                'You are not connected to the internet. Make sure Wi-Fi is on and Airplane Mode is Off',
                style: getMediumStyle(
                  fontSize: FontSize.s18,
                  color: ColorManager.error,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NoInternetSmall extends StatelessWidget {
  const NoInternetSmall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: ColorManager.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: size.height * 0.15,
            width: size.width * 0.5,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/no_connection.png"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
