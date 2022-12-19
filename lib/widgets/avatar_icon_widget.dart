import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';

class AvatarIconWidget extends StatelessWidget {
  const AvatarIconWidget({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.name,
  }) : super(key: key);

  final VoidCallback onTap;
  final IconData icon;
  final String name;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            backgroundColor: ColorManager.blue.withOpacity(0.7),
            radius: AppRadius.r12,
            child: Icon(
              icon,
              size: FontSize.s16,
              color: ColorManager.white,
            ),
          ),
          SizedBox(
            height: AppHeight.h10,
          ),
          Text(
            name,
            style: getBoldStyle(
              fontSize: FontSize.s12,
              color: ColorManager.blue,
            ),
          ),
        ],
      ),
    );
  }
}
