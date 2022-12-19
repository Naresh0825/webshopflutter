import 'package:flutter/material.dart';

import '../../../commons/exporter.dart';

class HomeOptions extends StatelessWidget {
  final Function() onTap;
  final String text;
  final String imageLink;
  final IconData? icon;
  const HomeOptions({
    Key? key,
    required this.size,
    required this.onTap,
    required this.text,
    this.icon,
    required this.imageLink,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(AppHeight.h2),
        decoration: BoxDecoration(
          color: ColorManager.white.withOpacity(.8),
          borderRadius: BorderRadius.circular(AppRadius.r10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: size.height * .04,
              width: size.width * .08,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imageLink),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: getMediumStyle(
                fontSize: FontSize.s14,
                color: ColorManager.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
