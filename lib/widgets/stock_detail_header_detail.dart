import 'package:flutter/material.dart';

import 'package:webshop/commons/exporter.dart';

class StockDetailHeaderDetail extends StatelessWidget {
  const StockDetailHeaderDetail({
    Key? key,
    required this.width,
    required this.text1,
    required this.text2,
  }) : super(key: key);

  final double width;
  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                text1,
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
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    width: size.width * 0.25,
                    height: size.height * 0.03,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        text2,
                        style: getSemiBoldStyle(
                          fontSize: FontSize.s12,
                          color: ColorManager.white,
                        ),
                      ),
                    ),
                  ),
                  VerticalDivider(
                    color: ColorManager.black,
                    thickness: 1.0,
                  ),
                  SizedBox(
                    width: size.width * 0.15,
                    height: size.height * 0.03,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Bill No',
                        style: getSemiBoldStyle(
                          fontSize: FontSize.s12,
                          color: ColorManager.white,
                        ),
                      ),
                    ),
                  ),
                  VerticalDivider(
                    color: ColorManager.black,
                    thickness: 1.0,
                  ),
                  SizedBox(
                    width: size.width * 0.15,
                    height: size.height * 0.03,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Qty',
                        style: getSemiBoldStyle(
                          fontSize: FontSize.s12,
                          color: ColorManager.white,
                        ),
                      ),
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
