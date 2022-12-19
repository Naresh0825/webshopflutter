import 'package:webshop/commons/exporter.dart';

class CashInOutHeaderWidget extends StatelessWidget {
  final String cashType;
  const CashInOutHeaderWidget({super.key, required this.cashType});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: ColorManager.darkBlue,
      width: size.width,
      height: size.height * 0.05,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppWidth.w4),
            width: size.width * 0.3,
            child: Center(
              child: Text(
                'Bill Code',
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
            child: Center(
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
            width: size.width * 0.15,
            child: Center(
              child: Text(
                'Bill No',
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
            child: Center(
              child: Text(
                cashType.toString(),
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
