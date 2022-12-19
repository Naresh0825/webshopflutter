import 'package:flutter/material.dart';

import '../../../commons/exporter.dart';

class TextFieldWithTitle extends StatefulWidget {
  final String title;
  final String labelText;
  final double? width;
  const TextFieldWithTitle({
    Key? key,
    required this.size,
    required this.title,
    required this.labelText,
    this.width,
  }) : super(key: key);

  final Size size;

  @override
  State<TextFieldWithTitle> createState() => _TextFieldWithTitle();
}

class _TextFieldWithTitle extends State<TextFieldWithTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: AppWidth.w8),
      width: widget.width ?? widget.size.width * .3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style:
                getBoldStyle(fontSize: FontSize.s16, color: ColorManager.black),
          ),
          Container(
            margin: EdgeInsets.only(bottom: AppHeight.h10),
            child: TextFormField(
              // controller: patientAddressController,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    vertical: AppHeight.h20, horizontal: AppWidth.w10),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ColorManager.skyBlue, width: AppWidth.w2),
                  borderRadius: BorderRadius.circular(AppRadius.r10),
                ),
                labelText: widget.labelText,
                labelStyle: getMediumStyle(
                    fontSize: FontSize.s14, color: ColorManager.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
