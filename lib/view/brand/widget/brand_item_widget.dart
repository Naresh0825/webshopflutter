import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';

class GroupItemWidget extends StatelessWidget {
  final String code;
  final String productName;
  const GroupItemWidget({
    super.key,
    required this.code,
    required this.productName,
  });

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {},
      child: Padding(
          padding: EdgeInsets.all(AppHeight.h2),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: ColorManager.blackOpacity87),
              borderRadius: BorderRadius.all(
                Radius.circular(AppRadius.r10),
              ),
            ),
            child: ListTile(
              leading: Text(
                code,
                style: getBoldStyle(
                  color: ColorManager.black,
                  fontSize: FontSize.s20,
                ),
              ),
              title: Text(
                productName,
                style: getMediumStyle(
                  fontSize: FontSize.s16,
                  color: ColorManager.black,
                ),
                overflow: TextOverflow.fade,
                textAlign: TextAlign.center,
              ),
            ),
          )),
    );
  }
}
