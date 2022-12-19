import 'package:webshop/commons/exporter.dart';

class TableHeaderWidget extends StatelessWidget {
  const TableHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: ColorManager.blue,
      width: size.width * 1.4,
      height: size.height * 0.06,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(AppHeight.h2),
            width: size.width * 0.32,
            child: Text(
              'Name',
              textAlign: TextAlign.start,
              style: getSemiBoldStyle(
                fontSize: FontSize.s12,
                color: ColorManager.white,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(AppHeight.h2),
            width: size.width * 0.08,
            child: Text(
              'Qty',
              textAlign: TextAlign.start,
              style: getSemiBoldStyle(
                fontSize: FontSize.s12,
                color: ColorManager.white,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(AppHeight.h2),
            width: size.width * 0.14,
            child: Text(
              'Rate',
              textAlign: TextAlign.center,
              style: getSemiBoldStyle(
                fontSize: FontSize.s12,
                color: ColorManager.white,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(AppHeight.h2),
            width: size.width * 0.18,
            child: Text(
              'Amount',
              textAlign: TextAlign.end,
              style: getSemiBoldStyle(
                fontSize: FontSize.s12,
                color: ColorManager.white,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(AppHeight.h2),
            width: size.width * 0.2,
            child: Text(
              'SalesRate',
              textAlign: TextAlign.end,
              style: getSemiBoldStyle(
                fontSize: FontSize.s12,
                color: ColorManager.white,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(AppHeight.h2),
            width: size.width * 0.1,
            child: Text(
              '',
              textAlign: TextAlign.start,
              style: getSemiBoldStyle(
                fontSize: FontSize.s12,
                color: ColorManager.white,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(AppHeight.h2),
            width: size.width * 0.1,
            child: Text(
              '',
              textAlign: TextAlign.start,
              style: getSemiBoldStyle(
                fontSize: FontSize.s12,
                color: ColorManager.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
