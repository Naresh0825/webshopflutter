import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';

class SalesDetailHeaderWidget extends StatelessWidget {
  const SalesDetailHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: ColorManager.darkBlue,
      width: size.width * 1.4,
      height: size.height * 0.05,
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(AppWidth.w4),
            width: size.width * 0.3,
            child: Center(
              child: Text(
                'Item',
                style: getBoldStyle(
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
            padding: EdgeInsets.all(AppWidth.w4),
            width: size.width * 0.1,
            height: size.height * 0.05,
            child: Center(
              child: Text(
                'Qty',
                style: getBoldStyle(
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
            padding: EdgeInsets.all(AppWidth.w4),
            width: size.width * 0.15,
            height: size.height * 0.05,
            child: Center(
              child: Text(
                'Bill No.',
                style: getBoldStyle(
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
            padding: EdgeInsets.all(AppWidth.w4),
            width: size.width * 0.15,
            height: size.height * 0.05,
            child: Center(
              child: Text(
                'Sales',
                style: getBoldStyle(
                  fontSize: FontSize.s16,
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
            padding: EdgeInsets.all(AppWidth.w4),
            width: size.width * 0.15,
            height: size.height * 0.05,
            child: Center(
              child: Text(
                'Costs',
                style: getBoldStyle(
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
            padding: EdgeInsets.all(AppWidth.w4),
            width: size.width * 0.15,
            height: size.height * 0.05,
            child: Center(
              child: Text(
                'Profit',
                style: getBoldStyle(
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
            padding: EdgeInsets.all(AppWidth.w4),
            width: size.width * 0.15,
            height: size.height * 0.05,
            child: Center(
              child: Text(
                'Profit%',
                style: getBoldStyle(
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
