import '../../../commons/exporter.dart';

class TableSalesHeaderWidget extends StatelessWidget {
  final Color? color;
  const TableSalesHeaderWidget({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: color ?? ColorManager.blue,
      width: size.width * 1.4,
      height: size.height * 0.04,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(AppHeight.h2),
            width: size.width * 0.4,
            child: Text(
              'Name',
              textAlign: TextAlign.start,
              style: getSemiBoldStyle(
                fontSize: FontSize.s14,
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
                fontSize: FontSize.s14,
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
                fontSize: FontSize.s14,
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
                fontSize: FontSize.s14,
                color: ColorManager.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
