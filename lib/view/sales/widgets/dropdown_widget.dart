import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:webshop/commons/exporter.dart';

class SalesDropDownWithTitle extends StatefulWidget {
  final TextEditingController? controller;
  final String text;
  const SalesDropDownWithTitle({
    Key? key,
    required this.size,
    required this.text,
    this.controller,
  }) : super(key: key);

  final Size size;

  @override
  State<SalesDropDownWithTitle> createState() => _SalesDropDownWithTitleState();
}

class _SalesDropDownWithTitleState extends State<SalesDropDownWithTitle> {
  TabletSetupServiceProvider? watchTabletSetupServiceProvider;

  @override
  Widget build(BuildContext context) {
    watchTabletSetupServiceProvider = context.watch<TabletSetupServiceProvider>();
    return SizedBox(
      width: widget.size.width * .5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: AppHeight.h4,
          ),
          Text(
            widget.text,
            style: getBoldStyle(fontSize: FontSize.s16, color: ColorManager.black),
          ),
          SizedBox(
            height: AppHeight.h4,
          ),
          SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.grey.withOpacity(.4),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              height: widget.size.height * 0.075,
              width: widget.size.width * 0.6,
              child: TypeAheadFormField<StockList>(
                textFieldConfiguration: TextFieldConfiguration(
                    controller: widget.controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(AppRadius.r10),
                      ),
                      fillColor: ColorManager.white,
                      filled: true,
                      hintText: 'Stock List',
                      hintStyle: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.grey),
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
                    )),
                onSuggestionSelected: (StockList stock) {
                  log(stock.stDes.toString(), name: 'stock name');
                },
                itemBuilder: (context, StockList stock) => ListTile(
                  title: Text(
                    stock.stDes.toString(),
                    style: getRegularStyle(
                      fontSize: FontSize.s12,
                      color: ColorManager.black,
                    ),
                  ),
                ),
                suggestionsCallback: getStockSuggestion,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<StockList> getStockSuggestion(String query) =>
      List.of(watchTabletSetupServiceProvider!.tabletSetupModel.data!.stockList!).where((StockList stock) {
        final stockNameLower = stock.stDes!.toLowerCase();
        final queryLower = query.toLowerCase();
        return stockNameLower.contains(queryLower);
      }).toList();
}
