import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';

class StockHeaderDetail extends StatelessWidget {
  const StockHeaderDetail({
    Key? key,
    required this.width,
    required this.text,
  }) : super(key: key);

  final double width;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                text,
                style: getSemiBoldStyle(
                  fontSize: FontSize.s12,
                  color: ColorManager.white,
                ),
              ),
              Divider(
                thickness: AppHeight.h1,
                color: ColorManager.white,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Qty',
                    style: getSemiBoldStyle(
                      fontSize: FontSize.s12,
                      color: ColorManager.white,
                    ),
                  ),
                  Text(
                    'Amount',
                    style: getSemiBoldStyle(
                      fontSize: FontSize.s12,
                      color: ColorManager.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        VerticalDivider(
          color: ColorManager.white,
          thickness: 1.0,
        ),
      ],
    );
  }
}
