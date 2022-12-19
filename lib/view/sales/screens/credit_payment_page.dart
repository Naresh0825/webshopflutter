import 'dart:developer';

import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:number_to_words_english/number_to_words_english.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/sales/model/sales_add_model.dart';
import 'package:webshop/view/sales/sales_entries.dart';
import 'package:webshop/view/sales/services/sales_service.dart';
import 'package:webshop/view/sales/services/update_sales_provider.dart';
import 'package:webshop/view/sales_return/models/get_sales_model.dart';
import 'package:webshop/view/sales_return/provider/get_salesbyid_provider.dart';

class CreditPayment extends StatefulWidget {
  final String? agentName;
  final int? agentId;
  final Sales salesDetails;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const CreditPayment({super.key, required this.salesDetails, this.agentName, this.agentId, required this.scaffoldKey});

  @override
  State<CreditPayment> createState() => _CreditPaymentState();
}

class _CreditPaymentState extends State<CreditPayment> {
  TabletSetupServiceProvider? watchTabletSetupServiceProvider;

  SalesServiceProvider? readSalesServiceProvider;
  GetSalesByIdProvider? readGetSalesByIdProvider;
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    if (context.read<SalesServiceProvider>().businessTotalAmount == 0.0) {
      amountController.text = context.read<SalesServiceProvider>().salesTotalAmount.toString();
    } else {
      amountController.text = (context.read<SalesServiceProvider>().salesTotalAmount - context.read<SalesServiceProvider>().businessTotalAmount).toString();
    }

    if (widget.agentName != null && widget.agentId != null) {
      context.read<SalesServiceProvider>().tranType = tranTypeList[1]['id'];
      context.read<SalesServiceProvider>().customerrName = widget.agentName;
      context.read<SalesServiceProvider>().customerrId = widget.agentId;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    watchTabletSetupServiceProvider = context.watch<TabletSetupServiceProvider>();
    readGetSalesByIdProvider = context.read<GetSalesByIdProvider>();
    SalesServiceProvider readSalesServiceProvider = context.read<SalesServiceProvider>();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
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
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                offset: const Offset(0.0, 1.0),
                color: ColorManager.grey,
              )
            ],
          ),
        ),
        leading: IconButton(
          onPressed: () {
            readSalesServiceProvider.setCustomerName(null);
            readSalesServiceProvider.setCustomerId(null);
            readSalesServiceProvider.setPMode(null);
            Navigator.pop(context);
          },
          icon: Icon(Icons.close, color: ColorManager.white),
        ),
        centerTitle: false,
        elevation: 1,
        backgroundColor: ColorManager.white,
        title: Text(
          'Credit pay',
          style: getMediumStyle(fontSize: FontSize.s18, color: ColorManager.white),
        ),
      ),
      body: Consumer<ConnectivityProvider>(builder: (context, connectivity, child) {
        return (connectivity.isOnline == false)
            ? const NoInternet()
            : Container(
                color: ColorManager.blue.withOpacity(.05),
                child: SafeArea(
                    child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: ColorManager.white,
                        boxShadow: [
                          BoxShadow(
                            color: ColorManager.blackOpacity38,
                            blurRadius: 5.0, // soften the shadow
                            spreadRadius: 1.0, //extend the shadow
                            offset: const Offset(1.0, .5),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: AppHeight.h10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('Total Amount: ${readSalesServiceProvider.salesTotalAmount}', style: getMediumStyle(fontSize: FontSize.s16, color: ColorManager.black)),
                            ],
                          ),
                          SizedBox(
                            height: AppHeight.h10,
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: Container(
                        color: ColorManager.white,
                        child: Column(
                          children: [
                            InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Trasaction',
                                labelStyle: getMediumStyle(
                                  fontSize: FontSize.s18,
                                  color: ColorManager.black,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: ColorManager.black,
                                    width: 10.0,
                                  ),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SingleChildScrollView(
                                        child: SizedBox(
                                          height: size.height * 0.06,
                                          width: size.width * 0.45,
                                          child: DropdownButtonFormField<String>(
                                            validator: (value) {
                                              if (value == null) {
                                                return '*Required';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(horizontal: AppWidth.w8),
                                              fillColor: ColorManager.white,
                                              filled: true,
                                              hintText: 'Mode',
                                              hintStyle: getSemiBoldStyle(
                                                fontSize: FontSize.s14,
                                                color: ColorManager.blackOpacity54,
                                              ),
                                              labelText: 'Mode',
                                              labelStyle: getSemiBoldStyle(
                                                fontSize: FontSize.s14,
                                                color: ColorManager.blackOpacity54,
                                              ),
                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                                borderRadius: BorderRadius.circular(AppRadius.r5),
                                              ),
                                            ),
                                            itemHeight: size.height * 0.08,
                                            isExpanded: true,
                                            icon: const Icon(Icons.arrow_drop_down),
                                            iconEnabledColor: ColorManager.skyBlue,
                                            iconSize: FontSize.s20,
                                            items: tranTypeList.map((project) {
                                              return DropdownMenuItem<String>(
                                                value: project['id'],
                                                child: Container(
                                                  margin: EdgeInsets.only(left: AppWidth.w1),
                                                  padding: EdgeInsets.only(left: AppWidth.w10),
                                                  height: size.height * 0.08,
                                                  width: double.infinity,
                                                  child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(
                                                      project['name'].toString(),
                                                      style: getMediumStyle(
                                                        fontSize: FontSize.s14,
                                                        color: ColorManager.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (paymentMode) {
                                              String? customerName;
                                              int? cusId;

                                              readSalesServiceProvider.setPMode(paymentMode);
                                              if (readSalesServiceProvider.billPMode == '1') {
                                                customerName = 'Cash';
                                                cusId = 0;
                                              } else if (readSalesServiceProvider.billPMode == '2') {
                                                customerName = widget.agentName;
                                                cusId = widget.agentId;
                                              } else if (readSalesServiceProvider.billPMode == '3') {
                                                customerName = 'Pos Card';
                                                cusId = 2;
                                              } else if (readSalesServiceProvider.billPMode == '4') {
                                                customerName = 'E Pay';
                                                cusId = 3;
                                              }

                                              readSalesServiceProvider.setCustomerName(customerName);
                                              readSalesServiceProvider.setCustomerId(cusId);
                                            },
                                            value: readSalesServiceProvider.billPMode,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: size.width * .35,
                                        child: TextFormField(
                                          style: getMediumStyle(
                                            fontSize: FontSize.s16,
                                            color: ColorManager.black,
                                          ),
                                          controller: amountController,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h4, horizontal: AppWidth.w10),
                                            border: OutlineInputBorder(
                                              borderSide: const BorderSide(width: 1.5, color: Colors.blue),
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            labelText: 'Amount',
                                            labelStyle: getMediumStyle(
                                              fontSize: FontSize.s16,
                                              color: ColorManager.black,
                                            ),
                                            hintText: 'Amount',
                                            hintStyle: getMediumStyle(
                                              fontSize: FontSize.s16,
                                              color: ColorManager.black,
                                            ),
                                            floatingLabelBehavior: FloatingLabelBehavior.always,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: const Size(130, 50),
                                            maximumSize: const Size(150, 60),
                                          ),
                                          onPressed: () {
                                            double isGreater = readSalesServiceProvider.salesTotalAmount - readSalesServiceProvider.businessTotalAmount;
                                            if (double.parse(amountController.text.toString()) > double.parse(isGreater.toString())) {
                                              Fluttertoast.cancel();
                                              Fluttertoast.showToast(
                                                msg: 'Amount OverFlowed',
                                                backgroundColor: ColorManager.amber,
                                                gravity: ToastGravity.BOTTOM,
                                                toastLength: Toast.LENGTH_LONG,
                                              );
                                            } else {
                                              if (readSalesServiceProvider.salesTotalAmount != readSalesServiceProvider.businessTotalAmount) {
                                                if (readSalesServiceProvider.billPMode != null) {
                                                  if (readSalesServiceProvider.billPMode == '2') {
                                                    if (widget.agentName == null && widget.agentId == null) {
                                                      Fluttertoast.cancel();
                                                      Fluttertoast.showToast(
                                                        msg: 'Select Customer Name',
                                                        toastLength: Toast.LENGTH_LONG,
                                                        gravity: ToastGravity.BOTTOM,
                                                        backgroundColor: ColorManager.error,
                                                      );
                                                    } else {
                                                      Businesslist businesslist = Businesslist(
                                                        billId: 0,
                                                        billPMode: int.parse(readSalesServiceProvider.billPMode.toString()),
                                                        billDescription: readSalesServiceProvider.customerName,
                                                        billDate: DateTime.parse(DateTime.now().toIso8601String().split("T")[0]).toIso8601String(),
                                                        billTotalAmt: double.parse(amountController.text),
                                                        billCodeId: 1,
                                                        billAgtId: readSalesServiceProvider.customerId!,
                                                        billAddedBy: int.parse(sharedPref!.getString('staffId').toString()),
                                                      );
                                                      //For Only now Purpose

                                                      readSalesServiceProvider.addBusinessList(businesslist);
                                                      readSalesServiceProvider.calculateBusinessTotalAmount();
                                                      if (readSalesServiceProvider.businessTotalAmount == readSalesServiceProvider.salesTotalAmount) {
                                                        amountController.text = 0.0.toString();
                                                      } else {
                                                        amountController.text = (readSalesServiceProvider.salesTotalAmount - readSalesServiceProvider.businessTotalAmount).toString();
                                                      }

                                                      setState(() {});
                                                    }
                                                  } else if (readSalesServiceProvider.billPMode == '1' || readSalesServiceProvider.billPMode == '3' || readSalesServiceProvider.billPMode == '4') {
                                                    Businesslist businesslist = Businesslist(
                                                      billId: 0,
                                                      billPMode: int.parse(readSalesServiceProvider.billPMode.toString()),
                                                      billDescription: readSalesServiceProvider.customerName,
                                                      billDate: DateTime.parse(DateTime.now().toIso8601String().split("T")[0]).toIso8601String(),
                                                      billTotalAmt: double.parse(amountController.text),
                                                      billCodeId: 1,
                                                      billAgtId: readSalesServiceProvider.customerId ?? 0,
                                                      billAddedBy: int.parse(sharedPref!.getString('staffId').toString()),
                                                    );
                                                    //For Only now Purpose

                                                    readSalesServiceProvider.addBusinessList(businesslist);
                                                    readSalesServiceProvider.calculateBusinessTotalAmount();
                                                    if (readSalesServiceProvider.businessTotalAmount == readSalesServiceProvider.salesTotalAmount) {
                                                      amountController.text = 0.0.toString();
                                                    } else {
                                                      amountController.text = (readSalesServiceProvider.salesTotalAmount - readSalesServiceProvider.businessTotalAmount).toString();
                                                    }

                                                    setState(() {});
                                                  } else {
                                                    Fluttertoast.cancel();
                                                    Fluttertoast.showToast(
                                                      msg: 'Error occored',
                                                      toastLength: Toast.LENGTH_LONG,
                                                      gravity: ToastGravity.BOTTOM,
                                                      backgroundColor: ColorManager.error,
                                                    );
                                                  }
                                                }
                                              } else {
                                                Fluttertoast.cancel();
                                                Fluttertoast.showToast(
                                                  msg: 'Amount Reached',
                                                  backgroundColor: ColorManager.amber,
                                                  gravity: ToastGravity.BOTTOM,
                                                  toastLength: Toast.LENGTH_LONG,
                                                );
                                              }
                                            }
                                            FocusScope.of(context).requestFocus(FocusNode());
                                          },
                                          icon: Icon(Icons.arrow_downward, color: ColorManager.white),
                                          label: Text(
                                            'Settlement',
                                            style: getMediumStyle(fontSize: FontSize.s18, color: ColorManager.white),
                                          ))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: AppHeight.h10),
                            Column(
                              children: [
                                Container(
                                  color: ColorManager.blue,
                                  width: size.width * 1.4,
                                  height: size.height * 0.04,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(left: AppHeight.h10),
                                        width: size.width * 0.4,
                                        child: Text(
                                          'Settlements',
                                          textAlign: TextAlign.start,
                                          style: getSemiBoldStyle(
                                            fontSize: FontSize.s14,
                                            color: ColorManager.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: size.height * .4,
                                  width: size.width,
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: readSalesServiceProvider.business.length,
                                    itemBuilder: (BuildContext context, int i) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(width: 1.0, color: Colors.lightBlue.shade900), // red as border color
                                          ),
                                        ),
                                        child: ListTile(
                                          leading: Text(
                                            readSalesServiceProvider.business[i].billDescription.toString(),
                                            style: getSemiBoldStyle(
                                              fontSize: FontSize.s14,
                                              color: ColorManager.black,
                                            ),
                                          ),
                                          trailing: Text(
                                            readSalesServiceProvider.business[i].billTotalAmt.toString(),
                                            style: getSemiBoldStyle(
                                              fontSize: FontSize.s14,
                                              color: ColorManager.black,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )),
              );
      }),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  readSalesServiceProvider.business.clear();
                  readSalesServiceProvider.calculateBusinessTotalAmount();
                  amountController.text = context.read<SalesServiceProvider>().salesTotalAmount.toString();
                  setState(() {});
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(180, 50)),
                  maximumSize: MaterialStateProperty.all(const Size(200, 60)),
                  backgroundColor: MaterialStateProperty.all(ColorManager.redAccent),
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: AppWidth.w10, vertical: AppHeight.h1)),
                  textStyle: MaterialStateProperty.all(getMediumStyle(fontSize: FontSize.s14, color: ColorManager.white)),
                ),
                child: Text(
                  'Clear',
                  style: getBoldStyle(fontSize: FontSize.s16, color: ColorManager.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog<String>(
                    context: widget.scaffoldKey.currentContext!,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Print'),
                      content: const Text('Do you want a print?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            onPayBill(readSalesServiceProvider, true);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SalesEntries(),
                                ),
                                (route) => false);
                            if (printIp == null) {
                              showDialog<String>(
                                context: widget.scaffoldKey.currentContext!,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Printer Alert'),
                                  content: const Text('Printer\'s ip is not set, to add printer\'s ip go to drawer->Add printer '),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const SalesEntries(),
                                          ),
                                          (route) => false),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          child: const Text('Yes'),
                        ),
                        TextButton(
                          onPressed: () {
                            onPayBill(readSalesServiceProvider, false);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SalesEntries(),
                                ),
                                (route) => false);
                          },
                          child: const Text('No'),
                        ),
                      ],
                    ),
                  );
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(180, 50)),
                  maximumSize: MaterialStateProperty.all(const Size(200, 60)),
                  backgroundColor:
                      MaterialStateProperty.all(readSalesServiceProvider.salesTotalAmount != readSalesServiceProvider.businessTotalAmount ? ColorManager.greenInActive : ColorManager.green),
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: AppWidth.w10, vertical: AppHeight.h1)),
                  textStyle: MaterialStateProperty.all(getMediumStyle(fontSize: FontSize.s14, color: ColorManager.white)),
                ),
                child: Text(
                  'Pay Bill',
                  style: getBoldStyle(fontSize: FontSize.s16, color: ColorManager.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  onPayBill(SalesServiceProvider readSalesServiceProvider, bool printBill) async {
    if (readSalesServiceProvider.salesTotalAmount == readSalesServiceProvider.businessTotalAmount) {
      var response = await context.read<UpdateSalesProvider>().updateSales(widget.salesDetails, readSalesServiceProvider.salesItemList, readSalesServiceProvider.business);
      log(response.toString(), name: 'response');

      if (response['responseType'] == 6 || response['data'] != null) {
        if (printBill == true) {
          if (printIp != null || printIp == "") {
            const PaperSize paper = PaperSize.mm80;
            final profile = await CapabilityProfile.load();
            final printer = NetworkPrinter(paper, profile);
            var data = await readGetSalesByIdProvider!.getSalesById(response['data']);

            PosPrintResult res = await printer.connect(printIp!, port: 9100);
            // var printResId = response['data'];
            log(res.msg.toString());

            if (res == PosPrintResult.success) {
              if (data.data != null) {
                readSalesServiceProvider.setPaymentModes(readGetSalesByIdProvider!.getSalesByIdModel.data!.businessDtoList!);
                billPrint(printer, watchTabletSetupServiceProvider!, readSalesServiceProvider, readGetSalesByIdProvider!.getSalesByIdModel);
                printer.disconnect();
              }
            } else {
              Fluttertoast.cancel();
              Fluttertoast.showToast(
                msg: res.msg,
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: ColorManager.error,
              );
            }
          }
        }
        readSalesServiceProvider.salesItemList.clear();
        readSalesServiceProvider.duplicateSalesItemList.clear();
        readSalesServiceProvider.tempSalesItemList.clear();
        readSalesServiceProvider.setCustomerName(null);
        readSalesServiceProvider.setCustomerId(null);
        readSalesServiceProvider.setPMode(null);
        readSalesServiceProvider.business.clear();
        readSalesServiceProvider.businessTotalAmount = 0.0;
        readSalesServiceProvider.salesSubTotal = 0.0;
        readSalesServiceProvider.salesTotalAmount = 0.0;
        readSalesServiceProvider.custommerNameController.clear();
        readSalesServiceProvider.agtId = null;
        readSalesServiceProvider.billToController.clear();
        readSalesServiceProvider.discountController.clear();
        readSalesServiceProvider.addressController.clear();
        readSalesServiceProvider.panNumberController.clear();
        readSalesServiceProvider.phoneNumberController.clear();
        Fluttertoast.cancel();
        Fluttertoast.showToast(
          msg: 'Sales Successful',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: ColorManager.green,
        );

        if (!mounted) return;
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => const SalesEntries(),
          ),
        );
      } else {
        Fluttertoast.cancel();
        Fluttertoast.showToast(
          msg: 'Sales Failed',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: ColorManager.error,
        );
      }
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: 'Amount Not Settled',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ColorManager.error,
      );
    }
  }

  billPrint(NetworkPrinter printer, TabletSetupServiceProvider tabletSetupServiceProvider, SalesServiceProvider saleServiceProvider, GetSalesByIdModel getSalesByIdModel) {
    PosFontType fontType = PosFontType.fontA;
    printer.beep(n: 1);
    tabletSetupServiceProvider.tabletSetupModel.data!.settingList!.where((element) => element.settingName == 'Demo').first.settingValue == '0'
        ? printer.text(
            "${tabletSetupServiceProvider.tabletSetupModel.data!.company!.name}\n(${tabletSetupServiceProvider.tabletSetupModel.data!.settingList!.where((element) => element.settingName == 'Demo').first.description})",
            styles: PosStyles(align: PosAlign.center, fontType: fontType, bold: true, width: PosTextSize.size1),
          )
        : printer.text(
            tabletSetupServiceProvider.tabletSetupModel.data!.company!.name.toString(),
            styles: PosStyles(align: PosAlign.center, bold: true, width: PosTextSize.size1, fontType: fontType),
          );
    printer.text(
      "${tabletSetupServiceProvider.tabletSetupModel.data!.company!.address}",
      styles: PosStyles(align: PosAlign.center, width: PosTextSize.size1, fontType: fontType),
    );
    printer.text(
      "Vat No: ${tabletSetupServiceProvider.tabletSetupModel.data!.company!.vatNo}",
      styles: PosStyles(align: PosAlign.center, fontType: fontType),
    );
    printer.text(
      "Tel No: ${tabletSetupServiceProvider.tabletSetupModel.data!.company!.telephone}",
      styles: PosStyles(align: PosAlign.center, fontType: fontType),
    );
    printer.text("        ");
    printer.text(
      "Tax Invoice",
      styles: const PosStyles(align: PosAlign.center, bold: true, width: PosTextSize.size1, underline: true),
    );
    printer.text("        ");
    printer.text(
      "Bill No     : ${getSalesByIdModel.data!.traBillNo}",
      styles: PosStyles(align: PosAlign.left, fontType: fontType),
    );
    printer.text(
      "Invoice Date: ${getSalesByIdModel.data!.traDate.toString().split('T')[0]}     ${getSalesByIdModel.data!.traNepDate}",
      styles: PosStyles(align: PosAlign.left, fontType: fontType),
    );
    printer.text(
      "Trans Date  : ${getSalesByIdModel.data!.traDate.toString().split('T')[0]}     ${getSalesByIdModel.data!.traNepDate}",
      styles: PosStyles(align: PosAlign.left, fontType: fontType),
    );
    printer.text(
      "Bill To     : ${getSalesByIdModel.data!.traCustomerName}",
      styles: PosStyles(align: PosAlign.left, fontType: fontType),
    );
    printer.text(
      "Address     : ${getSalesByIdModel.data!.traCustomerAddress}",
      styles: PosStyles(align: PosAlign.left, fontType: fontType),
    );
    printer.text(
      "Buyer's TPIN: ${getSalesByIdModel.data!.traCustomerPanNo}",
      styles: PosStyles(align: PosAlign.left, fontType: fontType),
    );
    printer.text(
      "Mobile      : ${getSalesByIdModel.data!.traCustomerMobileNo}",
      styles: PosStyles(align: PosAlign.left, fontType: fontType),
    );

    printer.text("-----------------------------------------------");
    printer.row([
      PosColumn(
        text: 'Sn ',
        width: 1,
        styles: PosStyles(align: PosAlign.left, fontType: fontType),
      ),
      PosColumn(
        text: 'Particular',
        width: 5,
        styles: PosStyles(align: PosAlign.left, fontType: fontType),
      ),
      PosColumn(
        text: 'Qty',
        width: 1,
        styles: PosStyles(align: PosAlign.right, fontType: fontType),
      ),
      PosColumn(
        text: 'Rate',
        width: 2,
        styles: PosStyles(align: PosAlign.center, fontType: fontType),
      ),
      PosColumn(
        text: 'Amount',
        width: 3,
        styles: PosStyles(align: PosAlign.right, fontType: fontType),
      ),
    ]);

    printer.text("-----------------------------------------------");
    for (var i = 0; i < getSalesByIdModel.data!.tradeSaleDetailDtoList!.length; i++) {
      printer.row([
        PosColumn(
          text: '${i + 1} ',
          width: 1,
          styles: PosStyles(align: PosAlign.left, fontType: fontType),
        ),
        PosColumn(
          text: '${getSalesByIdModel.data!.tradeSaleDetailDtoList![i].stDes}',
          width: 5,
          styles: PosStyles(align: PosAlign.left, fontType: fontType),
        ),
        PosColumn(
          text: getSalesByIdModel.data!.tradeSaleDetailDtoList![i].traDQty!.toStringAsFixed(0),
          width: 1,
          styles: PosStyles(align: PosAlign.center, fontType: fontType),
        ),
        PosColumn(
          text: getSalesByIdModel.data!.tradeSaleDetailDtoList![i].traDRate!.toStringAsFixed(0),
          width: 2,
          styles: PosStyles(align: PosAlign.center, fontType: fontType),
        ),
        PosColumn(
          text: getSalesByIdModel.data!.tradeSaleDetailDtoList![i].traDAmount!.toStringAsFixed(2),
          width: 3,
          styles: PosStyles(align: PosAlign.right, fontType: fontType),
        ),
      ]);
    }
    printer.row([
      PosColumn(
        text: '',
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(
        text: '-----------------------------------------------------------',
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    printer.row([
      PosColumn(
        text: '',
        width: 5,
        styles: PosStyles(align: PosAlign.right, fontType: fontType),
      ),
      PosColumn(
        text: 'Subtotal',
        width: 3,
        styles: PosStyles(align: PosAlign.right, fontType: fontType),
      ),
      PosColumn(
        text: ':',
        width: 1,
        styles: PosStyles(align: PosAlign.right, fontType: fontType),
      ),
      PosColumn(
        text: saleServiceProvider.salesSubTotal.toStringAsFixed(2),
        width: 3,
        styles: PosStyles(align: PosAlign.right, fontType: fontType),
      ),
    ]);
    printer.row([
      PosColumn(
        text: '',
        width: 5,
        styles: PosStyles(align: PosAlign.right, fontType: fontType),
      ),
      PosColumn(
        text: 'Discount',
        width: 3,
        styles: PosStyles(align: PosAlign.right, fontType: fontType),
      ),
      PosColumn(
        text: ':',
        width: 1,
        styles: PosStyles(align: PosAlign.right, fontType: fontType),
      ),
      PosColumn(
        text: double.parse(saleServiceProvider.discountController.text.isEmpty ? '0' : saleServiceProvider.discountController.text).toStringAsFixed(2),
        width: 3,
        styles: PosStyles(align: PosAlign.right, fontType: fontType),
      ),
    ]);
    printer.row([
      PosColumn(
        text: '',
        width: 5,
        styles: PosStyles(align: PosAlign.right, fontType: fontType),
      ),
      PosColumn(
        text: 'Total',
        width: 3,
        styles: PosStyles(align: PosAlign.right, fontType: fontType),
      ),
      PosColumn(
        text: ':',
        width: 1,
        styles: PosStyles(align: PosAlign.right, fontType: fontType),
      ),
      PosColumn(
        text: saleServiceProvider.salesTotalAmount.toStringAsFixed(2),
        width: 3,
        styles: PosStyles(align: PosAlign.right, fontType: fontType),
      ),
    ]);
    printer.text("        ");
    printer.text(
      "In Words: ${NumberToWordsEnglish.convert(
        int.parse(saleServiceProvider.salesTotalAmount.toString().split('.')[0]),
      ).toUpperCase()} AND ${NumberToWordsEnglish.convert(
        int.parse(saleServiceProvider.salesTotalAmount.toStringAsFixed(2).split('.')[1]),
      ).toUpperCase()} PAISA ONLY",
      styles: PosStyles(align: PosAlign.left, fontType: fontType),
    );
    printer.text(
      "Payment Mode: ${saleServiceProvider.paymentModeString} ",
      styles: PosStyles(align: PosAlign.left, fontType: fontType),
    );
    printer.text(
      "Prepared By: ${getSalesByIdModel.data!.traInsertedStaff} ",
      styles: PosStyles(align: PosAlign.left, fontType: fontType),
    );

    printer.text("              ");
    printer.text("              ");
    printer.row([
      PosColumn(
        text: '__________________',
        width: 4,
        styles: PosStyles(align: PosAlign.center, fontType: fontType),
      ),
      PosColumn(
        text: '',
        width: 2,
        styles: PosStyles(align: PosAlign.left, fontType: fontType),
      ),
      PosColumn(
        text: '',
        width: 2,
        styles: PosStyles(align: PosAlign.right, fontType: fontType),
      ),
      PosColumn(
        text: '__________________',
        width: 4,
        styles: PosStyles(align: PosAlign.center, fontType: fontType),
      ),
    ]);
    printer.row([
      PosColumn(
        text: 'Prepared By',
        width: 4,
        styles: PosStyles(align: PosAlign.center, fontType: fontType),
      ),
      PosColumn(
        text: '',
        width: 2,
        styles: PosStyles(align: PosAlign.left, fontType: fontType),
      ),
      PosColumn(
        text: '',
        width: 2,
        styles: PosStyles(align: PosAlign.right, fontType: fontType),
      ),
      PosColumn(
        text: 'Received By',
        width: 4,
        styles: PosStyles(align: PosAlign.center, fontType: fontType),
      ),
    ]);
    printer.text("              ");
    printer.text(
      "  ",
      styles: PosStyles(align: PosAlign.center, fontType: fontType),
    );
    printer.text(
      "${tabletSetupServiceProvider.tabletSetupModel.data!.settingList!.where((element) => element.settingName == 'POSTEXT').first.settingValue}",
      styles: PosStyles(align: PosAlign.center, fontType: fontType),
    );

    printer.text("        ");
    printer.text("        ");
    printer.text("        ");
    printer.cut();
    printer.beep(n: 2);
  }
}
