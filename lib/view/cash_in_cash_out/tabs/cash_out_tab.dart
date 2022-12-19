import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/cash_in_cash_out/model/cash_in_cash_out_model.dart';
import 'package:webshop/view/cash_in_cash_out/provider/cash_in_cash_out_provider.dart';
import 'package:webshop/widgets/cashin_out_widget.dart';
import 'package:webshop/widgets/no_data_dialog.dart';

class CashOutTab extends StatefulWidget {
  const CashOutTab({
    Key? key,
  }) : super(key: key);

  @override
  State<CashOutTab> createState() => _CashOutTabState();
}

class _CashOutTabState extends State<CashOutTab> {
  @override
  void initState() {
    getApiCall();
    super.initState();
  }

  Future<void> getApiCall() async {
    context.read<CashInCashOutProvider>().billPMode = 2;
    await context.read<CashInCashOutProvider>().getCashInCashOut(context.read<CashInCashOutProvider>().billPMode,
        context.read<CashInCashOutProvider>().selectedFromDate, context.read<CashInCashOutProvider>().selectedToDate);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Expanded(
          child: Consumer<CashInCashOutProvider>(
            builder: (context, cashOut, child) {
              return cashOut.cashInCashOutModel.data == null
                  ? const LoadingBox()
                  : cashOut.cashInCashOutModel.data!.businessViewList!.isNotEmpty
                      ? RefreshIndicator(
                          onRefresh: getApiCall,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: AppHeight.h2,
                              ),
                              const CashInOutHeaderWidget(cashType: 'CashOut'),
                              SizedBox(
                                height: size.height * 0.65,
                                width: size.width,
                                child: SingleChildScrollView(
                                  child: DataTable(
                                    dataRowHeight: 50.0,
                                    headingRowHeight: 0.0,
                                    columnSpacing: 0.0,
                                    horizontalMargin: 0,
                                    dataRowColor: MaterialStateProperty.resolveWith((states) => ColorManager.white),
                                    columns: _createColumn(),
                                    rows: cashOut.cashInCashOutModel.data!.businessViewList!
                                        .map(
                                          (cash) => _cashInReportRow(cash, size),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const NoDataErrorBox();
            },
          ),
        ),
      ],
    );
  }

  DataRow _cashInReportRow(CashInOut cash, Size size) {
    return DataRow(cells: [
      DataCell(
        Container(
          width: size.width * 0.3,
          padding: EdgeInsets.only(left: AppWidth.w4),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              cash.bdName.toString(),
              style: getRegularStyle(
                fontSize: FontSize.s12,
                color: ColorManager.black,
              ),
            ),
          ),
        ),
      ),
      DataCell(
        Container(
          width: size.width * 0.35,
          padding: EdgeInsets.only(left: AppWidth.w4),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              cash.billDescription.toString(),
              style: getRegularStyle(
                fontSize: FontSize.s12,
                color: ColorManager.black,
              ),
            ),
          ),
        ),
      ),
      DataCell(
        Container(
          width: size.width * 0.15,
          padding: EdgeInsets.only(left: AppWidth.w4),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              cash.billNo.toString(),
              style: getRegularStyle(
                fontSize: FontSize.s12,
                color: ColorManager.black,
              ),
            ),
          ),
        ),
      ),
      DataCell(
        Container(
          width: size.width * 0.2,
          padding: EdgeInsets.only(left: AppWidth.w4),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              cash.billCashOut.toString(),
              style: getRegularStyle(
                fontSize: FontSize.s12,
                color: ColorManager.black,
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  _createColumn() {
    return <DataColumn>[
      DataColumn(label: Container()),
      DataColumn(label: Container()),
      DataColumn(label: Container()),
      DataColumn(label: Container()),
    ];
  }
}
