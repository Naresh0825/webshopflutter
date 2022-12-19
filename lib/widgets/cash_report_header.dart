import 'package:webshop/commons/exporter.dart';

class CashReportHeader extends StatelessWidget {
  const CashReportHeader({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 1.6,
      height: size.height * 0.05,
      color: ColorManager.darkBlue,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: size.width * 0.2,
            padding: EdgeInsets.only(left: AppWidth.w4),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Date',
                style: getSemiBoldStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.white,
                ),
              ),
            ),
          ),
          Container(
            width: size.width * 0.15,
            padding: EdgeInsets.only(left: AppWidth.w4),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Bill No',
                style: getSemiBoldStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.white,
                ),
              ),
            ),
          ),
          Container(
            width: size.width * 0.35,
            padding: EdgeInsets.only(left: AppWidth.w4),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Description',
                style: getSemiBoldStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.white,
                ),
              ),
            ),
          ),
          Container(
            width: size.width * 0.3,
            padding: EdgeInsets.only(left: AppWidth.w4),
            child: Align(
              alignment: Alignment.center,
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
            width: size.width * 0.2,
            padding: EdgeInsets.only(left: AppWidth.w4),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Cash In',
                style: getSemiBoldStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.white,
                ),
              ),
            ),
          ),
          Container(
            width: size.width * 0.2,
            padding: EdgeInsets.only(left: AppWidth.w4),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Cash Out',
                style: getSemiBoldStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.white,
                ),
              ),
            ),
          ),
          Container(
            width: size.width * 0.2,
            padding: EdgeInsets.only(left: AppWidth.w4),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Code',
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
