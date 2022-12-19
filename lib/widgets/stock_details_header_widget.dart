import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/widgets/stock_detail_header_detail.dart';

class StockDetailsHeaderWidget extends StatelessWidget {
  const StockDetailsHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: ColorManager.darkBlue,
      width: size.width * 2.5,
      height: size.height * 0.08,
      child: Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          VerticalDivider(
            color: ColorManager.white,
            thickness: 1.0,
          ),
          StockDetailHeaderDetail(
            width: size.width * 0.65,
            text1: 'Purchase/Sale Return',
            text2: 'Supplier',
          ),
          StockDetailHeaderDetail(
            width: size.width * 0.65,
            text1: 'Sale/Purchase Return',
            text2: 'Customer',
          ),
          Container(
            width: size.width * 0.15,
            padding: EdgeInsets.only(left: AppWidth.w4),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Lost',
                style: getSemiBoldStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.white,
                ),
              ),
            ),
          ),
          VerticalDivider(
            color: ColorManager.white,
            thickness: 1.0,
          ),
          Container(
            width: size.width * 0.2,
            padding: EdgeInsets.only(left: AppWidth.w4),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Baln. Qty',
                style: getSemiBoldStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.white,
                ),
              ),
            ),
          ),
          VerticalDivider(
            color: ColorManager.white,
            thickness: 1.0,
          ),
          Container(
            width: size.width * 0.2,
            padding: EdgeInsets.only(left: AppWidth.w4),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Rate',
                style: getSemiBoldStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.white,
                ),
              ),
            ),
          ),
          VerticalDivider(
            color: ColorManager.white,
            thickness: 1.0,
          ),
          Container(
            width: size.width * 0.2,
            padding: EdgeInsets.only(left: AppWidth.w4),
            child: Align(
              alignment: Alignment.center,
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
