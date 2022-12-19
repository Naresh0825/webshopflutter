import 'package:webshop/commons/exporter.dart';

class SalesSummaryReportHeader extends StatelessWidget {
  const SalesSummaryReportHeader({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 1.7,
      height: size.height * 0.05,
      color: ColorManager.darkBlue,
      child: Row(
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
            width: size.width * 0.2,
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
              alignment: Alignment.centerLeft,
              child: Text(
                'Customer',
                style: getSemiBoldStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.white,
                ),
              ),
            ),
          ),
          Container(
            width: size.width * 0.25,
            padding: EdgeInsets.only(left: AppWidth.w4),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Total',
                style: getSemiBoldStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.white,
                ),
              ),
            ),
          ),
          Container(
            width: size.width * 0.25,
            padding: EdgeInsets.only(left: AppWidth.w4),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Cash',
                style: getSemiBoldStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.white,
                ),
              ),
            ),
          ),
          Container(
            width: size.width * 0.25,
            padding: EdgeInsets.only(left: AppWidth.w4),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Credit',
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
              alignment: Alignment.centerLeft,
              child: Text(
                'Detail',
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
