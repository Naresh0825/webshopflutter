import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/purchase/model/purchase_by_id_model.dart';
import 'package:webshop/view/purchase/model/purchase_item_model.dart';
import 'package:webshop/view/purchase/purchase_entries.dart';
import 'package:webshop/view/purchase/purchase_page.dart';
import 'package:webshop/view/purchase/services/purchase_by_id_service.dart';
import 'package:webshop/view/purchase/services/purchase_service.dart';
import 'package:webshop/view/sales_return/provider/get_salesbyid_provider.dart';
import 'package:webshop/widgets/no_data_dialog.dart';
import 'package:webshop/view/purchase/model/purchase_by_id_model.dart' as pur;

class PurchaseDetailsPage extends StatefulWidget {
  final int purId;
  final bool fromPurchase;
  const PurchaseDetailsPage({super.key, required this.purId, required this.fromPurchase});

  @override
  State<PurchaseDetailsPage> createState() => _SalesDetailsState();
}

class _SalesDetailsState extends State<PurchaseDetailsPage> {
  PurchaseServiceProvider? readPurchaseServiceProvider;
  TextEditingController billNoController = TextEditingController();
  TextEditingController billingNameController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();
  // TextEditingController remarksController = TextEditingController();
  TextEditingController subAmountController = TextEditingController();
  TextEditingController discountAmountController = TextEditingController();
  @override
  void initState() {
    context.read<PurchaseByIdServiceProvider>().getPurchaseById(int.parse(widget.purId.toString()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    readPurchaseServiceProvider = context.read<PurchaseServiceProvider>();
    Size size = MediaQuery.of(context).size;
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivity, child) {
        return (connectivity.isOnline == false)
            ? const NoInternet()
            : Scaffold(
                backgroundColor: Theme.of(context).colorScheme.background,
                appBar: AppBar(
                  shadowColor: ColorManager.blackOpacity87,
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          ColorManager.blue,
                          ColorManager.blueBright,
                        ],
                      ),
                    ),
                  ),
                  leading: IconButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true)
                          .pushReplacement(MaterialPageRoute(builder: (context) => const PurchasePage(isPurchaseReturn: false)));
                      context.read<GetSalesByIdProvider>().getSalesByIdModel.data = null;
                    },
                    icon: const Icon(Icons.arrow_back),
                    color: ColorManager.white,
                  ),
                  title: Text(
                    'Purchase Details',
                    style: getMediumStyle(fontSize: FontSize.s25, color: ColorManager.white),
                  ),
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
                floatingActionButton: fAB(),
                body: Consumer<PurchaseByIdServiceProvider>(
                  builder: (context, getPurchaseDetails, child) {
                    String? date;
                    List<PurchaseDetailDtoList>? purchaseDetailDtoList;
                    var data = getPurchaseDetails.purchaseByIdModel.data;

                    if (data != null) {
                      billNoController.text = data.purBillNo != null ? data.purBillNo.toString() : '';
                      billingNameController.text = data.supplier.toString();
                      date = data.purDate.toString();
                      totalAmountController.text = data.purTotalAmount.toString();
                      // remarksController.text = data.purRemark.toString();
                      discountAmountController.text = data.purDiscAmount.toString();
                      subAmountController.text = data.purSubAmount.toString();
                      purchaseDetailDtoList = data.purchaseDetailDtoList;
                    }

                    return data == null
                        ? SizedBox(
                            height: size.height * .8,
                            child: const LoadingBox(),
                          )
                        : GestureDetector(
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(AppHeight.h12),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Billing Information'.toUpperCase(),
                                          style: getBoldStyle(fontSize: FontSize.s16, color: ColorManager.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: ColorManager.white,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 5.0, // soften the shadow
                                          spreadRadius: 1.0, //extend the shadow
                                          offset: Offset(1.0, .5),
                                        )
                                      ],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(AppHeight.h8),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: size.width * .4,
                                                child: TextFormField(
                                                  style: TextStyle(color: ColorManager.black),
                                                  readOnly: true,
                                                  controller: billNoController,
                                                  textInputAction: TextInputAction.done,
                                                  decoration: InputDecoration(
                                                    fillColor: ColorManager.grey3,
                                                    filled: true,
                                                    contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h20, horizontal: AppWidth.w10),
                                                    border: OutlineInputBorder(
                                                      borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                                      borderRadius: BorderRadius.circular(AppRadius.r5),
                                                    ),
                                                    labelText: 'Bill No.',
                                                    hintText: 'Bill No.',
                                                    labelStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: size.height * .078,
                                                width: size.width * .4,
                                                child: InputDecorator(
                                                  decoration: InputDecoration(
                                                    fillColor: ColorManager.grey3,
                                                    filled: true,
                                                    labelText: 'Date',
                                                    labelStyle: getMediumStyle(
                                                      fontSize: FontSize.s18,
                                                      color: ColorManager.black,
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(AppRadius.r5),
                                                      borderSide: BorderSide(
                                                        color: ColorManager.black,
                                                        width: 10.0,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.date_range,
                                                          color: ColorManager.blueBright,
                                                        ),
                                                        Text(
                                                          date.toString().split('T')[0],
                                                          style: getBoldStyle(
                                                            fontSize: FontSize.s14,
                                                            color: ColorManager.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: AppHeight.h10),
                                          TextFormField(
                                            style: TextStyle(color: ColorManager.black),
                                            readOnly: true,
                                            controller: billingNameController,
                                            textInputAction: TextInputAction.done,
                                            decoration: InputDecoration(
                                              fillColor: ColorManager.grey3,
                                              filled: true,
                                              contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h18, horizontal: AppWidth.w10),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                                borderRadius: BorderRadius.circular(AppRadius.r5),
                                              ),
                                              labelText: 'Billing Name',
                                              hintText: 'Billing Name',
                                              labelStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: AppHeight.h10),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: ColorManager.white,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 5.0, // soften the shadow
                                          spreadRadius: 1.0, //extend the shadow
                                          offset: Offset(1.0, .5),
                                        )
                                      ],
                                    ),
                                    child: ExpansionTile(
                                      initiallyExpanded: true,
                                      title: Text(
                                        'Billing Items'.toUpperCase(),
                                        style: getSemiBoldStyle(fontSize: FontSize.s16, color: ColorManager.black),
                                      ),
                                      children: [
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          itemCount: purchaseDetailDtoList!.length,
                                          itemBuilder: (context, index) {
                                            return Card(
                                              elevation: 5,
                                              child: ListTile(
                                                leading: Text('${index + 1}'),
                                                title: Text(
                                                  purchaseDetailDtoList![index].stDes.toString(),
                                                  style: getSemiBoldStyle(fontSize: FontSize.s16, color: ColorManager.black),
                                                ),
                                                subtitle: Text(
                                                  '${purchaseDetailDtoList[index].purDQty.toString()} unit at ${purchaseDetailDtoList[index].purDRate.toString()}',
                                                  style: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                                ),
                                                trailing: Text(purchaseDetailDtoList[index].purDAmount.toString()),
                                              ),
                                            );
                                          },
                                        ),
                                        SizedBox(height: AppHeight.h10),
                                        SpaceAroundText(
                                          size: size,
                                          firstText: Text(
                                            'Subtotal',
                                            style: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.grey),
                                          ),
                                          secondText: Text(
                                            data.purSubAmount!.toStringAsFixed(2),
                                            style: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.grey),
                                          ),
                                        ),
                                        SpaceAroundText(
                                          size: size,
                                          firstText: Text(
                                            'Discount',
                                            style: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.grey),
                                          ),
                                          secondText: Text(
                                            data.purDiscAmount!.toStringAsFixed(2),
                                            style: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.grey),
                                          ),
                                        ),
                                        SpaceAroundText(
                                          size: size,
                                          firstText: Text(
                                            'Taxable Amt',
                                            style: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.grey),
                                          ),
                                          secondText: Text(
                                            data.purTaxableAmount!.toStringAsFixed(2),
                                            style: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.grey),
                                          ),
                                        ),
                                        SpaceAroundText(
                                          size: size,
                                          firstText: Text(
                                            'VAT',
                                            style: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.grey),
                                          ),
                                          secondText: Text(
                                            data.purVatAmount!.toStringAsFixed(2),
                                            style: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.grey),
                                          ),
                                        ),
                                        SpaceAroundText(
                                          size: size,
                                          firstText: Text(
                                            'Total Amt',
                                            style: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.grey),
                                          ),
                                          secondText: Text(
                                            data.purTotalAmount!.toStringAsFixed(2),
                                            style: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.grey),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: AppHeight.h150),
                                ],
                              ),
                            ),
                          );
                  },
                ),
              );
      },
    );
  }

  fAB() {
    return Padding(
      padding: EdgeInsets.only(left: AppWidth.w20, bottom: AppHeight.h20),
      child: FloatingActionButton(
        onPressed: () async {
          pur.PurchaseByIdModel response = await context.read<PurchaseByIdServiceProvider>().getPurchaseById(int.parse(widget.purId.toString()));

          pur.PurchaseId data = response.data!;

          PurchaseDetails purchaseDetails = PurchaseDetails(
            purId: data.purId,
            purType: data.purType,
            purDate: data.purDate,
            purSupId: data.purSupId,
            purMode: data.purMode,
            purCashCredit: data.purCashCredit,
            purInsertedDate: data.purInsertedDate,
            purInsertedBy: data.purInsertedBy,
            purSubAmount: data.purSubAmount,
            purDiscAmount: data.purDiscAmount,
            purTaxableAmount: data.purTaxableAmount,
            purNonTaxableAmount: data.purNonTaxableAmount,
            purVatAmount: data.purVatAmount,
            purTotalAmount: data.purTotalAmount,
            purInActive: data.purInActive,
            supplier: data.supplier,
            purBillNo: data.purBillNo,
          );

          if (!mounted) return;
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => PurchaseEntries(
                  purchaseDetails: purchaseDetails,
                  fromPurchase: widget.fromPurchase,
                ),
              ),
              (route) => false);
        },
        backgroundColor: ColorManager.blueBright,
        child: FaIcon(
          FontAwesomeIcons.penToSquare,
          size: FontSize.s20,
        ),
      ),
    );
  }
}

class SpaceAroundText extends StatelessWidget {
  final Text firstText;
  final Text secondText;
  const SpaceAroundText({
    Key? key,
    required this.size,
    required this.firstText,
    required this.secondText,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: size.width * .05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              SizedBox(
                width: size.width * .25,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [firstText],
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: AppWidth.w10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text(':'),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: size.width * .2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [secondText],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
