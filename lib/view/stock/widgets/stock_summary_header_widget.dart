import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/widgets/stock_header_detail.dart';

class StockSummaryHeaderWidget extends StatelessWidget {
  final String headerName;
  const StockSummaryHeaderWidget({super.key, required this.headerName});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 2.6,
      height: size.height * 0.08,
      color: ColorManager.darkBlue,
      child: Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: size.width * 0.3,
            padding: EdgeInsets.only(left: AppWidth.w4),
            child: Text(
              headerName,
              style: getSemiBoldStyle(
                fontSize: FontSize.s12,
                color: ColorManager.white,
              ),
            ),
          ),
          VerticalDivider(
            color: ColorManager.white,
            thickness: 1.0,
          ),
          StockHeaderDetail(
            width: size.width * 0.35,
            text: 'Opening Balance',
          ),
          StockHeaderDetail(
            width: size.width * 0.35,
            text: 'Purchase/Return',
          ),
          StockHeaderDetail(
            width: size.width * 0.35,
            text: 'Sales/Issued',
          ),
          StockHeaderDetail(
            width: size.width * 0.35,
            text: 'Lost & Damage',
          ),
          StockHeaderDetail(
            width: size.width * 0.35,
            text: 'Closing Balance',
          ),
          SizedBox(
            width: size.width * 0.3,
            child: Text(
              'Cost Rate',
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
