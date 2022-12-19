import 'package:flutter/material.dart';

import '../../../commons/exporter.dart';

class TextFieldWithTitle extends StatefulWidget {
  final TextInputType? keyboardType;
  final bool? enabled;
  final String title;
  final String? labelText;
  final double? width;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  const TextFieldWithTitle({
    Key? key,
    required this.size,
    required this.title,
    this.labelText,
    this.width,
    this.controller,
    this.keyboardType,
    this.enabled,
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
            color: ColorManager.white,
            margin: EdgeInsets.only(bottom: AppHeight.h10),
            child: TextFormField(
              onChanged: widget.onChanged,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '*Required';
                }
                return null;
              },
              enabled: widget.enabled,
              keyboardType: widget.keyboardType,
              controller: widget.controller,
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
