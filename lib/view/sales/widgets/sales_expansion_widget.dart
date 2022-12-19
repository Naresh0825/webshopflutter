import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/sales/model/find_sale_model.dart';
import 'package:webshop/view/stock/widgets/row_popup_widget.dart';

class SalesExpansionWidget extends StatefulWidget {
  final FindSale stockData;
  const SalesExpansionWidget({
    Key? key,
    required this.stockData,
  }) : super(key: key);

  @override
  State<SalesExpansionWidget> createState() => _SalesExpansionWidgetState();
}

class _SalesExpansionWidgetState extends State<SalesExpansionWidget> {
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
                    'Date',
                    style: getBoldStyle(
                      fontSize: FontSize.s10,
                      color: const Color(0xff0074E3),
                    ),
                  ),
                  Text(
                    widget.stockData.traDate.toString().split('T')[0].toString(),
                    style: getMediumStyle(
                      fontSize: FontSize.s12,
                      color: ColorManager.grey,
                    ),
                  ),
                ],
              ),
              title: Text(
                widget.stockData.traCustomerName.toString(),
                style: getBoldStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.black,
                ),
              ),
              subtitle: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bill No: ',
                    style: getBoldStyle(
                      fontSize: FontSize.s12,
                      color: const Color(0xff0074E3),
                    ),
                  ),
                  Text(
                    widget.stockData.traBillNo.toString(),
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
                  title: 'Sales Amount: ',
                  titleDetail: widget.stockData.salesAmount.toString(),
                ),
                SizedBox(
                  height: AppHeight.h4,
                ),
                RowPopUpWidget(
                  title: 'Total Amount: ',
                  titleDetail: widget.stockData.traTotalAmount.toString(),
                ),
                SizedBox(
                  height: AppHeight.h4,
                ),
                RowPopUpWidget(
                  title: 'Transaction Remark: ',
                  titleDetail: widget.stockData.traRemark.toString(),
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
