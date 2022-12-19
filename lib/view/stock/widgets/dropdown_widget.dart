import 'package:flutter/material.dart';

import '../../../commons/exporter.dart';

class DropDownWithTitle extends StatefulWidget {
  const DropDownWithTitle({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  State<DropDownWithTitle> createState() => _DropDownWithTitleState();
}

class _DropDownWithTitleState extends State<DropDownWithTitle> {
  @override
  Widget build(BuildContext context) {
    List<String> items = [
      'item1',
      'item2',
      'item3',
    ];
    String? selectionItem = 'item1';
    return Container(
      padding: EdgeInsets.only(left: AppWidth.w8),
      width: widget.size.width * .5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Supplier',
            style:
                getBoldStyle(fontSize: FontSize.s16, color: ColorManager.black),
          ),
          SingleChildScrollView(
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorManager.skyBlue),
                  borderRadius: BorderRadius.circular(AppRadius.r10),
                ),
              ),
              // itemHeight: widget.size.height * 0.08,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              iconEnabledColor: ColorManager.skyBlue,
              iconSize: FontSize.s30,
              items: items
                  .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                      )))
                  .toList(),
              onChanged: (item) {
                setState(() {
                  selectionItem = item;
                });
              },
              value: selectionItem,
            ),
          ),
        ],
      ),
    );
  }
}
