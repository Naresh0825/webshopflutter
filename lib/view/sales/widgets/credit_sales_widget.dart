import 'package:flutter/material.dart';

import '../../../commons/exporter.dart';

class CreditSalesTopicWidget extends StatelessWidget {
  final Function() onTap;
  final String text;
  final Color color;
  final Color textcolor;
  const CreditSalesTopicWidget({
    Key? key,
    required this.size,
    required this.onTap,
    required this.text,
    required this.color,
    required this.textcolor,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(AppHeight.h2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.r5),
          color: color,
          boxShadow: [
            BoxShadow(
              color: ColorManager.grey.withOpacity(.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(-3.0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              text,
              textAlign: TextAlign.center,
              style: getBoldStyle(
                fontSize: FontSize.s14,
                color: textcolor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
