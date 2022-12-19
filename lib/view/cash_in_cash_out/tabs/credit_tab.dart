import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/cash_in_cash_out/model/cash_in_cash_out_model.dart';
import 'package:webshop/view/cash_in_cash_out/provider/cash_in_cash_out_provider.dart';
import 'package:webshop/widgets/cashin_out_widget.dart';
import 'package:webshop/widgets/no_data_dialog.dart';

class CreditTab extends StatefulWidget {
  const CreditTab({
    Key? key,
  }) : super(key: key);

  @override
  State<CreditTab> createState() => _CreditTabState();
}

class _CreditTabState extends State<CreditTab> {
  @override
  void initState() {
    getApiCall();
    super.initState();
  }

  Future<void> getApiCall() async {
    context.read<CashInCashOutProvider>().billPMode = 0;
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
            builder: (context, credit, child) {
              return credit.cashInCashOutModel.data == null
                  ? const LoadingBox()
                  : credit.cashInCashOutModel.data!.businessViewList!.isNotEmpty
                      ? RefreshIndicator(
                          onRefresh: getApiCall,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: AppHeight.h2,
                              ),
                              const CashInOutHeaderWidget(cashType: 'Credit'),
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
                                    rows: credit.cashInCashOutModel.data!.businessViewList!
                                        .map(
                                          (credit) => _cashInReportRow(credit, size),
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

  DataRow _cashInReportRow(CashInOut credit, Size size) {
    return DataRow(cells: [
      DataCell(
        Container(
          width: size.width * 0.3,
          padding: EdgeInsets.only(left: AppWidth.w4),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              credit.bdName.toString(),
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
              credit.billDescription.toString(),
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
              credit.billNo.toString(),
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
              credit.billCredit.toString(),
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
