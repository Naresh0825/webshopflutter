import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';

class SearchWidget extends StatelessWidget {
  final double? reqWidth;
  final TextEditingController searchTextEditingController;
  final Function(String) onChanged;
  final Function()? onPressed;

  const SearchWidget({
    super.key,
    required this.searchTextEditingController,
    required this.onChanged,
    required this.onPressed,
    this.reqWidth,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: reqWidth ?? size.width,
      height: size.height * 0.065,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.r10),
        color: ColorManager.redWhite,
      ),
      child: Row(
        children: [
          SizedBox(width: AppWidth.w10),
          Expanded(
            child: TextFormField(
              style: getMediumStyle(fontSize: FontSize.s15, color: ColorManager.black),
              onChanged: onChanged,
              controller: searchTextEditingController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search',
                hintStyle: TextStyle(
                  fontSize: FontSize.s16,
                  color: ColorManager.grey,
                  letterSpacing: 1.5,
                ),
                suffixIcon: (searchTextEditingController.text.isEmpty)
                    ? Icon(
                        Icons.search_outlined,
                        size: FontSize.s20,
                      )
                    : IconButton(
                        icon: const Icon(Icons.close_outlined),
                        iconSize: FontSize.s20,
                        onPressed: onPressed,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
