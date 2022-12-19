import 'package:webshop/commons/exporter.dart';

class StatementHeaderWidget extends StatelessWidget {
  final bool isCustomer;
  const StatementHeaderWidget({super.key, required this.isCustomer});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: ColorManager.darkBlue,
      width: size.width * 1.5,
      height: size.height * 0.05,
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(AppWidth.w4),
            width: size.width * 0.25,
            child: Center(
              child: Text(
                'Date',
                style: getBoldStyle(
                  fontSize: FontSize.s16,
                  color: ColorManager.white,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(AppWidth.w4),
            width: size.width * 0.25,
            height: size.height * 0.05,
            child: Center(
              child: Text(
                'Miti',
                style: getBoldStyle(
                  fontSize: FontSize.s16,
                  color: ColorManager.white,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(AppWidth.w4),
            width: size.width * 0.2,
            height: size.height * 0.05,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Bill No.',
                style: getBoldStyle(
                  fontSize: FontSize.s16,
                  color: ColorManager.white,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(AppWidth.w4),
            width: size.width * 0.35,
            height: size.height * 0.05,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Description',
                style: getBoldStyle(
                  fontSize: FontSize.s16,
                  color: ColorManager.white,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(AppWidth.w4),
            width: size.width * 0.23,
            height: size.height * 0.05,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                (isCustomer == true) ? 'Sales' : 'Purchase',
                style: getBoldStyle(
                  fontSize: FontSize.s16,
                  color: ColorManager.white,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(AppWidth.w4),
            width: size.width * 0.22,
            height: size.height * 0.05,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Payment',
                style: getBoldStyle(
                  fontSize: FontSize.s16,
                  color: ColorManager.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
