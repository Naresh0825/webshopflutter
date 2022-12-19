import 'package:webshop/commons/exporter.dart';

class ReturnItemHeaderWidget extends StatelessWidget {
  const ReturnItemHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: ColorManager.red,
      width: size.width,
      height: size.height * 0.04,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(AppHeight.h2),
            width: size.width * 0.35,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Name',
                style: getSemiBoldStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.white,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(AppHeight.h2),
            width: size.width * 0.1,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Qty',
                style: getSemiBoldStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.white,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(AppHeight.h2),
            width: size.width * 0.2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Rate',
                style: getSemiBoldStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.white,
                ),
              ),
            ),
          ),
          SizedBox(
            width: size.width * 0.3,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Amount',
                style: getSemiBoldStyle(
                  fontSize: FontSize.s14,
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
