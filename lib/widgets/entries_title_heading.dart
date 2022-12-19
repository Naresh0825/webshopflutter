import 'package:flutter/material.dart';
import 'package:webshop/commons/colors_manager.dart';
import 'package:webshop/commons/font_manager.dart';
import 'package:webshop/commons/font_styles_manager.dart';
import 'package:webshop/commons/size_value_manager.dart';

class EntriesTitleHeadingWidget extends StatelessWidget {
  const EntriesTitleHeadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      color: ColorManager.darkBlue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(AppHeight.h4),
            width: size.width * 0.35,
            child: Text(
              'Name',
              style: getRegularStyle(
                fontSize: FontSize.s14,
                color: ColorManager.white,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(AppHeight.h4),
            width: size.width * 0.15,
            child: Center(
              child: Text(
                'Qty',
                style: getRegularStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.white,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(AppHeight.h4),
            width: size.width * 0.15,
            child: Center(
              child: Text(
                'Rate',
                style: getRegularStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.white,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(AppHeight.h4),
            width: size.width * 0.2,
            child: Center(
              child: Text(
                'Amount',
                style: getRegularStyle(
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
