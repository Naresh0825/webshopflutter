import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/cash_in_cash_out/model/cash_in_cash_out_model.dart';
import 'package:webshop/view/cash_in_cash_out/provider/cash_in_cash_out_provider.dart';
import 'package:webshop/view/cash_in_cash_out/provider/edit_cash_in_out_provider.dart';
import 'package:webshop/view/cash_in_cash_out/screens/cash_in_out_edit.dart';
import 'package:webshop/widgets/no_data_dialog.dart';

class AllTab extends StatefulWidget {
  const AllTab({
    Key? key,
  }) : super(key: key);

  @override
  State<AllTab> createState() => _AllTabState();
}

class _AllTabState extends State<AllTab> {
  List<CashInOut> businessViewList = [];
  @override
  void initState() {
    getApiCall();
    super.initState();
  }

  Future<void> getApiCall() async {
    context.read<CashInCashOutProvider>().billPMode = -1;
    await context.read<CashInCashOutProvider>().getCashInCashOut(context.read<CashInCashOutProvider>().billPMode,
        context.read<CashInCashOutProvider>().selectedFromDate, context.read<CashInCashOutProvider>().selectedToDate);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Expanded(child: Consumer<CashInCashOutProvider>(builder: (context, cashIn, child) {
          return cashIn.cashInCashOutModel.data == null
              ? const LoadingBox()
              : cashIn.cashInCashOutModel.data!.businessViewList!.isNotEmpty
                  ? RefreshIndicator(
                      onRefresh: getApiCall,
                      child: ListView.builder(
                        itemCount: cashIn.cashInCashOutModel.data!.businessViewList!.length,
                        itemBuilder: (context, index) {
                          if (cashIn.cashInCashOutModel.data != null) {
                            businessViewList = cashIn.cashInCashOutModel.data!.businessViewList!
                              ..sort((a, b) => a.billDate!.toIso8601String().compareTo(b.billDate!.toIso8601String()));
                          }

                          return GestureDetector(
                            onTap: () {
                              (businessViewList[index].bdCode == "MIS" ||
                                      businessViewList[index].bdCode == "PMT" ||
                                      businessViewList[index].bdCode == "RCT")
                                  ? {
                                      context.read<EditCashInOutProvider>().billDesList = null,
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CashInOutEdit(
                                            billId: businessViewList[index].billId!,
                                          ),
                                        ),
                                      ),
                                    }
                                  : {};
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: AppHeight.h6, vertical: AppHeight.h4),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppRadius.r5),
                                  color: ColorManager.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 5.0, // soften the shadow
                                      spreadRadius: 1.0, //extend the shadow
                                      offset: Offset(1.0, 1.0),
                                    )
                                  ],
                                ),
                                height: size.height * .1,
                                child: Center(
                                  child: ListTile(
                                    title: Text(
                                      businessViewList[index].billDescription.toString(),
                                      style: getBoldStyle(
                                        fontSize: FontSize.s18,
                                        color: ColorManager.black,
                                      ),
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Text(
                                          businessViewList[index].bdName.toString(),
                                          style: getMediumStyle(
                                            fontSize: FontSize.s12,
                                            color: ColorManager.grey2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: Column(
                                      children: [
                                        Text(
                                          businessViewList[index].billPMode == 0
                                              ? businessViewList[index].billCredit.toString()
                                              : businessViewList[index].billPMode == 2
                                                  ? businessViewList[index].billCashOut.toString()
                                                  : businessViewList[index].billCashIn.toString(),
                                          style: getSemiBoldStyle(
                                            fontSize: FontSize.s14,
                                            color: ColorManager.black,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: AppHeight.h4, vertical: AppHeight.h4),
                                          decoration: BoxDecoration(
                                            color: businessViewList[index].billPMode == 0
                                                ? ColorManager.amber
                                                : businessViewList[index].billPMode == 2
                                                    ? ColorManager.red.withOpacity(.7)
                                                    : ColorManager.green,
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 5.0, // soften the shadow
                                                spreadRadius: 1.0, //extend the shadow
                                                offset: Offset(1.0, 1.0),
                                              )
                                            ],
                                          ),
                                          child: Text(
                                            businessViewList[index].billPMode == 0
                                                ? 'Credit'
                                                : businessViewList[index].billPMode == 2
                                                    ? 'Cash Out'
                                                    : 'Cash In',
                                            style: getSemiBoldStyle(fontSize: FontSize.s10, color: ColorManager.white),
                                          ),
                                        ),
                                        (businessViewList[index].bdCode == "MIS" ||
                                                businessViewList[index].bdCode == "PMT" ||
                                                businessViewList[index].bdCode == "RCT")
                                            ? Text(
                                                'Change',
                                                style: getSemiBoldStyle(fontSize: FontSize.s10, color: ColorManager.grey),
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ),
                                  // Text('$index', textScaleFactor: 5),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : const NoDataErrorBox();
        }))
      ],
    );
  }
}
