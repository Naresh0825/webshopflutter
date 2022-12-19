import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/sales/model/sales_add_model.dart';
import 'package:webshop/view/sales/services/sales_service.dart';

class SalesList extends StatefulWidget {
  final TextEditingController? barCodeController, stockListController, quantityController, rateController;
  const SalesList({
    super.key,
    this.barCodeController,
    this.stockListController,
    this.quantityController,
    this.rateController,
  });

  @override
  State<SalesList> createState() => _SalesListState();
}

class _SalesListState extends State<SalesList> {
  SalesServiceProvider? watchSalesServiceProvider, readSalesServiceProvider;
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    watchSalesServiceProvider = context.watch<SalesServiceProvider>();
    readSalesServiceProvider = context.read<SalesServiceProvider>();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: ListView.builder(
        reverse: true,
        shrinkWrap: true,
        controller: scrollController,
        itemCount: watchSalesServiceProvider!.salesItemList.length,
        itemBuilder: (BuildContext context, int index) {
          SalesItemModel sales = watchSalesServiceProvider!.salesItemList[index];
          return Column(
            children: [
              Card(
                child: ListTile(
                  leading: IconButton(
                    onPressed: () {
                      readSalesServiceProvider!.deleteSalesItem(sales);
                    },
                    icon: Icon(
                      Icons.close,
                      size: FontSize.s25,
                      color: ColorManager.error,
                    ),
                  ),
                  title: Text(
                    sales.traDStkName.toString(),
                    style: getSemiBoldStyle(
                      fontSize: FontSize.s15,
                      color: ColorManager.black,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      Row(
                        children: [
                          Text(
                            sales.traDQty.toString(),
                            style: getMediumStyle(
                              fontSize: FontSize.s13,
                              color: ColorManager.black,
                            ),
                          ),
                          Text(
                            ' x ',
                            style: getMediumStyle(
                              fontSize: FontSize.s13,
                              color: ColorManager.black,
                            ),
                          ),
                          Text(
                            sales.traDRate.toString(),
                            style: getMediumStyle(
                              fontSize: FontSize.s13,
                              color: ColorManager.black,
                            ),
                          ),
                          Text(
                            ' = ',
                            style: getMediumStyle(
                              fontSize: FontSize.s13,
                              color: ColorManager.black,
                            ),
                          ),
                          Text(
                            sales.traDAmount.toString(),
                            style: getMediumStyle(
                              fontSize: FontSize.s13,
                              color: ColorManager.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: AppWidth.w6,
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.edit_note,
                      size: FontSize.s30,
                      color: ColorManager.blueBright,
                    ),
                    onPressed: () {
                      readSalesServiceProvider!.changeEntryMode();
                      readSalesServiceProvider!.setIndexSalesItem(index);
                      widget.barCodeController!.text = '';
                      widget.stockListController!.text = sales.traDStkName!;
                      widget.quantityController!.text = sales.traDQty.toString();
                      widget.rateController!.text = sales.traDRate.toString();
                      readSalesServiceProvider!.salesAmount = sales.traDAmount!;
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
