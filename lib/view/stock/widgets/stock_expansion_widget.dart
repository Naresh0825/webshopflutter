import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';

import 'row_popup_widget.dart';

class StockExpansionWidget extends StatefulWidget {
  final StockList stockData;
  const StockExpansionWidget({
    Key? key,
    required this.stockData,
  }) : super(key: key);

  @override
  State<StockExpansionWidget> createState() => _StockExpansionWidgetState();
}

class _StockExpansionWidgetState extends State<StockExpansionWidget> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      animationDuration: const Duration(milliseconds: 800),
      children: [
        ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Brand: ',
                    style: getBoldStyle(
                      fontSize: FontSize.s10,
                      color: const Color(0xff0074E3),
                    ),
                  ),
                  Text(
                    widget.stockData.brandName.toString(),
                    style: getMediumStyle(
                      fontSize: FontSize.s12,
                      color: ColorManager.grey,
                    ),
                  ),
                ],
              ),
              title: Text(
                widget.stockData.stDes.toString(),
                style: getBoldStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.black,
                ),
              ),
              subtitle: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Code: ',
                    style: getBoldStyle(
                      fontSize: FontSize.s12,
                      color: const Color(0xff0074E3),
                    ),
                  ),
                  Text(
                    widget.stockData.stCode.toString(),
                    style: getRegularStyle(
                      fontSize: FontSize.s12,
                      color: ColorManager.grey,
                    ),
                  ),
                ],
              ),
            );
          },
          body: Padding(
            padding: EdgeInsets.only(left: AppWidth.w80, bottom: AppWidth.w10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: AppHeight.h4,
                ),
                RowPopUpWidget(
                  title: 'Qty:       ',
                  titleDetail: widget.stockData.stOBal.toString(),
                ),
                SizedBox(
                  height: AppHeight.h4,
                ),
                RowPopUpWidget(
                  title: 'Cost Rate:  ',
                  titleDetail: widget.stockData.stORate.toString(),
                ),
                SizedBox(
                  height: AppHeight.h4,
                ),
                RowPopUpWidget(
                  title: 'Sales Rate: ',
                  titleDetail: widget.stockData.stSalesRate.toString(),
                ),
                SizedBox(
                  height: AppHeight.h4,
                ),
                RowPopUpWidget(
                  title: 'InActive:       ',
                  titleDetail: widget.stockData.stInActive.toString(),
                ),
              ],
            ),
          ),
          isExpanded: _expanded,
          canTapOnHeader: true,
        ),
      ],
      dividerColor: Colors.grey,
      expansionCallback: (panelIndex, isExpanded) {
        _expanded = !_expanded;
        setState(() {});
      },
    );
  }
}
