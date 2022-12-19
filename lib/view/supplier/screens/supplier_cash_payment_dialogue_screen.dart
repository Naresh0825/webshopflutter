import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/cash_in_cash_out/model/post_business_model.dart';
import 'package:webshop/view/supplier/provider/post_business_supplier_provider.dart';
import 'package:webshop/view/supplier/supplier_page.dart';

class SupplierCashPaymentDialogueScreen extends StatefulWidget {
  final int supId;
  final String billDescription;
  const SupplierCashPaymentDialogueScreen({super.key, required this.supId, required this.billDescription});

  @override
  State<SupplierCashPaymentDialogueScreen> createState() => _SupplierCashPaymentDialogueScreenState();
}

class _SupplierCashPaymentDialogueScreenState extends State<SupplierCashPaymentDialogueScreen> {
  PostBusinessSupplierServiceProvider? watchPostBusinessSupplierProvider;
  @override
  void initState() {
    context.read<PostBusinessSupplierServiceProvider>().descriptionTextEditingController.text = 'Payment to: ${widget.billDescription}';
    context.read<PostBusinessSupplierServiceProvider>().nameTextEditingController.text = widget.billDescription;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    watchPostBusinessSupplierProvider = context.watch<PostBusinessSupplierServiceProvider>();

    watchPostBusinessSupplierProvider?.dateSelect = watchPostBusinessSupplierProvider?.selectedDate.toIso8601String().split("T")[0];

    Widget labelStartDate = InkWell(
      onTap: () {
        watchPostBusinessSupplierProvider?.selectDate(context, widget.supId);
      },
      child: SizedBox(
        height: size.height * 0.075,
        width: size.width * 0.4,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'Date',
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
          child: Center(
            child: Text(
              watchPostBusinessSupplierProvider!.dateSelect.toString(),
              style: getRegularStyle(
                fontSize: FontSize.s14,
                color: ColorManager.black,
              ),
            ),
          ),
        ),
      ),
    );
    return Consumer<ConnectivityProvider>(builder: (context, connectivity, child) {
      return (connectivity.isOnline == false)
          ? const NoInternet()
          : SingleChildScrollView(
              child: AlertDialog(
                titlePadding: EdgeInsets.zero,
                title: Container(
                  color: ColorManager.blueBright,
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
                          'Payment',
                          style: getBoldStyle(
                            fontSize: FontSize.s18,
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
                              watchPostBusinessSupplierProvider!.clear(context);
                              Navigator.pop(context);
                            },
                            child: Image.asset('assets/images/reject.png'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Supplier Name: ',
                          style: getMediumStyle(fontSize: FontSize.s18, color: ColorManager.blackOpacity87),
                        ),
                        Text(
                          widget.billDescription,
                          style: getRegularStyle(fontSize: FontSize.s18, color: ColorManager.blackOpacity87),
                        ),
                      ],
                    ),
                    SizedBox(height: AppHeight.h10),
                    Row(
                      children: [
                        labelStartDate,
                      ],
                    ),
                    SizedBox(height: AppHeight.h10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: size.width * 0.4,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '*Required';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            controller: watchPostBusinessSupplierProvider!.amountTextEditingController,
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
                                labelText: 'Amount',
                                labelStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.grey),
                                hintText: 'Amount',
                                hintStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.grey),
                                floatingLabelBehavior: FloatingLabelBehavior.always),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppHeight.h10,
                    ),
                    Container(
                      width: size.width,
                      margin: EdgeInsets.only(bottom: AppHeight.h10),
                      child: TextFormField(
                        style: getRegularStyle(fontSize: FontSize.s15, color: ColorManager.black),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '*Required';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        controller: watchPostBusinessSupplierProvider!.descriptionTextEditingController,
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
                          labelText: 'Description',
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
                          onPressed: onSave,
                          child: Text(
                            'Save',
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
                            watchPostBusinessSupplierProvider!.clear(context);
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
            );
    });
  }

  onSave() async {
    if (watchPostBusinessSupplierProvider!.amountTextEditingController.text.isEmpty) {
      Fluttertoast.cancel();
      return Fluttertoast.showToast(
        msg: 'Amount is Empty',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ColorManager.error,
      );
    } else if (watchPostBusinessSupplierProvider!.descriptionTextEditingController.text.isEmpty) {
      Fluttertoast.cancel();
      return Fluttertoast.showToast(
        msg: 'Description is Empty',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ColorManager.error,
      );
    } else {
      PostBusiness postBusiness = PostBusiness(
          billId: 0,
          billPMode: 2,
          billDescription: watchPostBusinessSupplierProvider!.descriptionTextEditingController.text,
          billDate: watchPostBusinessSupplierProvider!.dateSelect.toString(),
          billTotalAmt: double.parse(watchPostBusinessSupplierProvider!.amountTextEditingController.text),
          billCodeId: 5,
          billSupplierId: widget.supId,
          billAddedBy: int.parse(sharedPref!.getString('staffId').toString()),
          billInActive: false);
      var response = await context.read<PostBusinessSupplierServiceProvider>().postServiceSupplier(postBusiness);

      if (response["responseType"] == 6) {
        if (!mounted) return;
        watchPostBusinessSupplierProvider!.clear(context);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const SupplierPage(),
            ),
            (route) => false);
        Fluttertoast.cancel();
        return Fluttertoast.showToast(
          msg: 'Amount Paid Successfull',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: ColorManager.black,
        );
      } else {
        Fluttertoast.cancel();
        return Fluttertoast.showToast(
          msg: response["message"],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: ColorManager.black,
        );
      }
    }
  }
}
