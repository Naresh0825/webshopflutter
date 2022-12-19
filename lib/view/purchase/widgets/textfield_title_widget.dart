import 'package:flutter/material.dart';

import '../../../commons/exporter.dart';

class TextFieldWithTitle extends StatefulWidget {
  final Function(String)? onChanged;
  final String title;
  final String labelText;
  final double? width;
  final TextEditingController controller;
  const TextFieldWithTitle({
    Key? key,
    required this.size,
    required this.title,
    required this.labelText,
    this.width,
    required this.controller,
    this.onChanged,
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
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: ColorManager.grey.withOpacity(.4),
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            // margin: EdgeInsets.only(bottom: AppHeight.h10),
            child: TextFormField(
              style: TextStyle(color: ColorManager.black),
              controller: widget.controller,
              maxLines: 1,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(AppRadius.r10),
                ),
                fillColor: ColorManager.white,
                filled: true,
                hintText: widget.labelText,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorManager.blueGrey),
                  borderRadius: BorderRadius.circular(AppRadius.r10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorManager.blueBright),
                  borderRadius: BorderRadius.circular(AppRadius.r10),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorManager.red),
                  borderRadius: BorderRadius.circular(AppRadius.r10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
