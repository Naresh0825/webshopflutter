// ignore_for_file: use_build_context_synchronously

import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/sales/sales_page.dart';
import 'package:webshop/view/sales/services/delete_sales_service.dart';
import 'package:webshop/view/sales_return/models/get_sales_model.dart';
import 'package:webshop/view/sales_return/provider/get_salesbyid_provider.dart';

class DeleteSalesWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final int traId;
  final GetSalesByIdProvider watchGetSalesByIdProvider;
  const DeleteSalesWidget({super.key, required this.traId, required this.watchGetSalesByIdProvider, required this.scaffoldKey});

  @override
  State<DeleteSalesWidget> createState() => _DeleteSalesWidgetState();
}

class _DeleteSalesWidgetState extends State<DeleteSalesWidget> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    DeleteSalesServiceProvider watchDeleteSalesServiceProvider = context.watch<DeleteSalesServiceProvider>();
    TabletSetupServiceProvider tabletSetupServiceProvider = context.watch<TabletSetupServiceProvider>();

    return SingleChildScrollView(
      child: AlertDialog(
        titlePadding: EdgeInsets.zero,
        title: Container(
          color: ColorManager.darkPurple,
          width: size.width,
          height: size.height * 0.06,
          margin: EdgeInsets.all(AppHeight.h4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: AppHeight.h8),
                child: Text(
                  'Delete Sales',
                  style: getBoldStyle(
                    fontSize: FontSize.s10,
                    color: ColorManager.white,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(AppHeight.h10),
                child: CircleAvatar(
                  radius: AppRadius.r14,
                  backgroundColor: ColorManager.white,
                  child: InkWell(
                    onTap: () {
                      watchDeleteSalesServiceProvider.reasonTextEditingController.clear();
                      Navigator.pop(context);
                    },
                    child: Image.asset('assets/images/reject.png'),
                  ),
                ),
              ),
            ],
          ),
        ),
        content: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: size.width,
                margin: EdgeInsets.only(bottom: AppHeight.h10),
                child: TextFormField(
                  validator: (value) {
                    if (value == null) {
                      return 'Reason is empty';
                    } else if (value.length < 10) {
                      return 'Enter Valid Reason';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.text,
                  controller: watchDeleteSalesServiceProvider.reasonTextEditingController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: AppHeight.h20,
                      horizontal: AppWidth.w10,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                      borderRadius: BorderRadius.circular(AppRadius.r10),
                    ),
                    labelText: 'Reason',
                    labelStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.grey),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.blue,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        showDialog<String>(
                          context: widget.scaffoldKey.currentContext!,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Print'),
                            content: const Text('Do you want a print?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  onConfirm(watchDeleteSalesServiceProvider, context, tabletSetupServiceProvider, throwPrint: true);
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const SalesPage(isSalesReturn: false),
                                      ),
                                      (route) => false);
                                },
                                child: const Text('Yes'),
                              ),
                              TextButton(
                                onPressed: () {
                                  onConfirm(watchDeleteSalesServiceProvider, context, tabletSetupServiceProvider, throwPrint: false);
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const SalesPage(isSalesReturn: false),
                                      ),
                                      (route) => false);
                                },
                                child: const Text('No'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Confirm',
                      style: getRegularStyle(
                        fontSize: FontSize.s14,
                        color: ColorManager.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: AppWidth.w20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.grey,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: getRegularStyle(
                        fontSize: FontSize.s14,
                        color: ColorManager.white,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  onConfirm(DeleteSalesServiceProvider watchDeleteSalesServiceProvider, BuildContext context, TabletSetupServiceProvider tabletSetupServiceProvider, {bool? throwPrint}) async {
    if (_formKey.currentState!.validate()) {
      if (watchDeleteSalesServiceProvider.reasonTextEditingController.text.isEmpty) {
        Fluttertoast.cancel();
        return Fluttertoast.showToast(
          msg: 'Reason is Empty',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: ColorManager.error,
        );
      } else if (watchDeleteSalesServiceProvider.reasonTextEditingController.text.length < 10) {
        Fluttertoast.cancel();
        return Fluttertoast.showToast(
          msg: 'Enter Valid Reason',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: ColorManager.error,
        );
      } else {
        var reason = await context.read<DeleteSalesServiceProvider>().deleteSales(widget.traId, watchDeleteSalesServiceProvider.reasonTextEditingController.text);

        if (reason["responseType"] == 6) {
          if (throwPrint == true) {
            if (printIp != null || printIp == '') {
              const PaperSize paper = PaperSize.mm80;
              final profile = await CapabilityProfile.load();
              final printer = NetworkPrinter(paper, profile);

              PosPrintResult res = await printer.connect(printIp!, port: 9100);

              if (res == PosPrintResult.success) {
                billCancelPrint(printer, tabletSetupServiceProvider);
                printer.disconnect();
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

          watchDeleteSalesServiceProvider.reasonTextEditingController.clear();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const SalesPage(isSalesReturn: false),
            ),
            (route) => false,
          );
          if (printIp == null) {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Printer Alert'),
                content: const Text('Printer\'s ip is not set, to add your printer ip go to Drawer->Add printer.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SalesPage(isSalesReturn: false),
                        ),
                        (route) => false),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
          Fluttertoast.cancel();
          return Fluttertoast.showToast(
            msg: 'Sales Deleted Successfully',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: ColorManager.black,
          );
        } else {
          watchDeleteSalesServiceProvider.reasonTextEditingController.clear();

          Navigator.pop(context);
          Fluttertoast.cancel();
          return Fluttertoast.showToast(
            msg: 'Sales Deleted Failed',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: ColorManager.error,
          );
        }
      }
    }
  }

  billCancelPrint(NetworkPrinter printer, TabletSetupServiceProvider tabletSetupServiceProvider) {
    PosFontType fontType = PosFontType.fontA;
    printer.beep(n: 1);
    printer.text(
      'Sale Cancelled',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        width: PosTextSize.size2,
        underline: true,
      ),
    );
    printer.text(
      tabletSetupServiceProvider.tabletSetupModel.data!.company!.name.toString(),
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        width: PosTextSize.size1,
        underline: true,
      ),
    );
    printer.text(
      "Vat No:${tabletSetupServiceProvider.tabletSetupModel.data!.company!.vatNo}",
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        width: PosTextSize.size1,
        underline: true,
      ),
    );
    printer.text("        ");
    printer.text(
      "Date/Time : ${DateTime.now().toString().split(' ')[0]} at ${NepaliDateTime.now().toString().split(' ')[1].split(':')[0]}:${NepaliDateTime.now().toString().split(' ')[1].split(':')[1]}",
      styles: PosStyles(align: PosAlign.left, fontType: fontType),
    );
    printer.text(
      "Name      : ${widget.watchGetSalesByIdProvider.getSalesByIdModel.data!.traCustomerName}",
      styles: PosStyles(align: PosAlign.left, fontType: fontType),
    );
    printer.text(
      "Address   : ${widget.watchGetSalesByIdProvider.getSalesByIdModel.data!.traCustomerAddress}",
      styles: PosStyles(align: PosAlign.left, fontType: fontType),
    );
    printer.text(
      "Pan No    : ${widget.watchGetSalesByIdProvider.getSalesByIdModel.data!.traCustomerPanNo}",
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
    for (var i = 0; i < widget.watchGetSalesByIdProvider.getSalesByIdModel.data!.tradeSaleDetailDtoList!.length; i++) {
      TradeSaleDetailDtoList data = widget.watchGetSalesByIdProvider.getSalesByIdModel.data!.tradeSaleDetailDtoList![i];
      printer.row(
        [
          PosColumn(
            text: '${i + 1} ',
            width: 1,
            styles: PosStyles(align: PosAlign.left, fontType: fontType),
          ),
          PosColumn(
            text: '${data.stDes}',
            width: 5,
            styles: PosStyles(align: PosAlign.left, fontType: fontType),
          ),
          PosColumn(
            text: data.traDQty!.toStringAsFixed(0),
            width: 1,
            styles: PosStyles(align: PosAlign.center, fontType: fontType),
          ),
          PosColumn(
            text: data.traDRate!.toStringAsFixed(0),
            width: 2,
            styles: PosStyles(align: PosAlign.center, fontType: fontType),
          ),
          PosColumn(
            text: data.traDAmount!.toStringAsFixed(2),
            width: 3,
            styles: PosStyles(align: PosAlign.right, fontType: fontType),
          ),
        ],
      );
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
        text: widget.watchGetSalesByIdProvider.getSalesByIdModel.data!.traSubAmount!.toStringAsFixed(2),
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
        text: widget.watchGetSalesByIdProvider.getSalesByIdModel.data!.traDiscAmount!.toStringAsFixed(2),
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
        text: widget.watchGetSalesByIdProvider.getSalesByIdModel.data!.traTotalAmount!.toStringAsFixed(2),
        width: 3,
        styles: PosStyles(align: PosAlign.right, fontType: fontType),
      ),
    ]);
    printer.text("-----------------------------------------------");
    printer.text(
      "Thank you for visiting us",
      styles: PosStyles(align: PosAlign.left, fontType: fontType),
    );
    printer.text("-----------------------------------------------");

    printer.text("        ");
    printer.text("        ");
    printer.text("        ");
    printer.cut();
    printer.beep(n: 2);
  }
}
