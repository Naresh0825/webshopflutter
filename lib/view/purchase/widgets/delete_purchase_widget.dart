import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/purchase/purchase_page.dart';
import 'package:webshop/view/purchase/services/delete_purchase_service.dart';

class DeletePurchaseWidget extends StatefulWidget {
  final int purId;
  const DeletePurchaseWidget({super.key, required this.purId});

  @override
  State<DeletePurchaseWidget> createState() => _DeletePurchaseWidgetState();
}

class _DeletePurchaseWidgetState extends State<DeletePurchaseWidget> {
  DeletePurchaseServiceProvider? deletePurchaseServiceProvider;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    deletePurchaseServiceProvider = context.watch<DeletePurchaseServiceProvider>();

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
                  'Void Purchase',
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
                      deletePurchaseServiceProvider!.reasonTextEditingController.clear();
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
          key: deletePurchaseServiceProvider!.formKey,
          child: Column(
            children: [
              Container(
                width: size.width,
                margin: EdgeInsets.only(bottom: AppHeight.h10),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*Required';
                    } else if (value.length < 10) {
                      return 'Enter Valid Reason';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  controller: deletePurchaseServiceProvider!.reasonTextEditingController,
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
                    onPressed: onConfirm,
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

  onConfirm() async {
    if (deletePurchaseServiceProvider!.formKey.currentState!.validate()) {
      var reason = await context.read<DeletePurchaseServiceProvider>().deletePurchase(widget.purId, deletePurchaseServiceProvider!.reasonTextEditingController.text);

      if (reason["responseType"] == 6) {
        deletePurchaseServiceProvider!.reasonTextEditingController.clear();
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const PurchasePage(
              isPurchaseReturn: false,
            ),
          ),
          (route) => false,
        );
        Fluttertoast.cancel();
        return Fluttertoast.showToast(
          msg: 'Purchase Deleted Successfully',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: ColorManager.black,
        );
      } else {
        deletePurchaseServiceProvider!.reasonTextEditingController.clear();
        if (!mounted) return;
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
