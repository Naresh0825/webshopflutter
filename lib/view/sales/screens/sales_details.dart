import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/sales/sales_page.dart';
import 'package:webshop/view/sales/widgets/delete_sales_widget.dart';
import 'package:webshop/view/sales_return/models/get_sales_model.dart';
import 'package:webshop/view/sales_return/provider/get_salesbyid_provider.dart';
import 'package:webshop/widgets/no_data_dialog.dart';

class SalesDetails extends StatefulWidget {
  final int salesId;
  const SalesDetails({super.key, required this.salesId});

  @override
  State<SalesDetails> createState() => _SalesDetailsState();
}

class _SalesDetailsState extends State<SalesDetails> {
  TextEditingController billNoController = TextEditingController();
  TextEditingController billingNameController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  @override
  void initState() {
    context.read<GetSalesByIdProvider>().getSalesById(int.parse(widget.salesId.toString()));
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    GetSalesByIdProvider watchGetSalesByIdProvider = context.watch<GetSalesByIdProvider>();
    return Consumer<ConnectivityProvider>(builder: (context, connectivity, child) {
      return (connectivity.isOnline == false)
          ? const NoInternet()
          : Scaffold(
              key: _scaffoldKey,
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
                    Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => const SalesPage(isSalesReturn: false)));
                    context.read<GetSalesByIdProvider>().getSalesByIdModel.data = null;
                  },
                  icon: const Icon(Icons.arrow_back),
                  color: ColorManager.white,
                ),
                title: Text(
                  'Sales Details',
                  style: getMediumStyle(fontSize: FontSize.s20, color: ColorManager.white),
                ),
              ),
              body: Consumer<GetSalesByIdProvider>(
                builder: (context, getSalesDetails, child) {
                  String? date;
                  List<TradeSaleDetailDtoList>? tradeSaleDetails;

                  if (getSalesDetails.getSalesByIdModel.data != null) {
                    billNoController.text = getSalesDetails.getSalesByIdModel.data!.traBillNo.toString();
                    billingNameController.text = getSalesDetails.getSalesByIdModel.data!.traCustomerName.toString();
                    date = getSalesDetails.getSalesByIdModel.data!.traDate.toString();
                    remarksController.text = getSalesDetails.getSalesByIdModel.data!.traRemark.toString();
                    tradeSaleDetails = getSalesDetails.getSalesByIdModel.data!.tradeSaleDetailDtoList;
                  }
                  return getSalesDetails.getSalesByIdModel.data == null
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
                                        SizedBox(height: AppHeight.h10),
                                        TextFormField(
                                          style: TextStyle(color: ColorManager.black),
                                          readOnly: true,
                                          controller: remarksController,
                                          textInputAction: TextInputAction.done,
                                          decoration: InputDecoration(
                                            fillColor: ColorManager.grey3,
                                            filled: true,
                                            contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h18, horizontal: AppWidth.w10),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                              borderRadius: BorderRadius.circular(AppRadius.r5),
                                            ),
                                            labelText: 'Remarks',
                                            hintText: 'Remarks',
                                            labelStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                          ),
                                        ),
                                        SizedBox(height: AppHeight.h4),
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
                                        itemCount: tradeSaleDetails!.length,
                                        itemBuilder: (context, index) {
                                          return Card(
                                            elevation: 5,
                                            child: ListTile(
                                              leading: Text('${index + 1}'),
                                              title: Text(
                                                tradeSaleDetails![index].stDes.toString(),
                                                style: getSemiBoldStyle(fontSize: FontSize.s16, color: ColorManager.black),
                                              ),
                                              subtitle: Text(
                                                '${tradeSaleDetails[index].traDQty.toString()} unit at ${tradeSaleDetails[index].traDRate.toString()}',
                                                style: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                              ),
                                              trailing: Text(tradeSaleDetails[index].traDAmount.toString()),
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
                                          getSalesDetails.getSalesByIdModel.data!.traSubAmount.toString(),
                                          style: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.grey),
                                        ),
                                      ),
                                      SpaceAroundText(
                                        size: size,
                                        firstText: Text(
                                          'Discount(${getSalesDetails.getSalesByIdModel.data!.traDiscPercent.toString()}%)',
                                          style: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.grey),
                                        ),
                                        secondText: Text(
                                          getSalesDetails.getSalesByIdModel.data!.traDiscAmount.toString(),
                                          style: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.grey),
                                        ),
                                      ),
                                      SpaceAroundText(
                                        size: size,
                                        firstText: Text(
                                          'Total Amount',
                                          style: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.grey),
                                        ),
                                        secondText: Text(
                                          getSalesDetails.getSalesByIdModel.data!.traTotalAmount.toString(),
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
              bottomSheet: Container(
                height: size.height * .08,
                width: size.width,
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
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => DeleteSalesWidget(
                              scaffoldKey: _scaffoldKey,
                              traId: int.parse(widget.salesId.toString()),
                              watchGetSalesByIdProvider: watchGetSalesByIdProvider,
                            ),
                          );
                        },
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(const Size(180, 50)),
                          maximumSize: MaterialStateProperty.all(const Size(200, 60)),
                          backgroundColor: MaterialStateProperty.all(ColorManager.redAccent),
                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: AppWidth.w10, vertical: AppHeight.h1)),
                          textStyle: MaterialStateProperty.all(getMediumStyle(fontSize: FontSize.s14, color: ColorManager.white)),
                        ),
                        child: Text(
                          'Void',
                          style: getBoldStyle(fontSize: FontSize.s16, color: ColorManager.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
    });
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
                width: size.width * .28,
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
                width: size.width * .28,
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
