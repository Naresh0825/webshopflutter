import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/agent/agent_page.dart';
import 'package:webshop/view/agent/provider/post_business_agent_provider.dart';

class AgentCashReciveDialogueScreen extends StatefulWidget {
  final int agtId;
  final String billDescription;
  const AgentCashReciveDialogueScreen({super.key, required this.agtId, required this.billDescription});

  @override
  State<AgentCashReciveDialogueScreen> createState() => _AgentCashReciveDialogueScreenState();
}

class _AgentCashReciveDialogueScreenState extends State<AgentCashReciveDialogueScreen> {
  @override
  void initState() {
    context.read<PostBusinessAgentProvider>().descriptionTextEditingController.text = 'Received From: ${widget.billDescription}';
    context.read<PostBusinessAgentProvider>().nameTextEditingController.text = widget.billDescription;
    super.initState();
  }

  PostBusinessAgentProvider? watchPostBusinessAgentProvider;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    watchPostBusinessAgentProvider = context.watch<PostBusinessAgentProvider>();

    watchPostBusinessAgentProvider?.dateSelect = watchPostBusinessAgentProvider?.selectedDate.toIso8601String().split("T")[0];

    Widget labelStartDate = InkWell(
      onTap: () {
        watchPostBusinessAgentProvider?.selectDate(context, widget.agtId);
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
              watchPostBusinessAgentProvider!.dateSelect.toString(),
              style: getMediumStyle(
                fontSize: FontSize.s14,
                color: ColorManager.black,
              ),
            ),
          ),
        ),
      ),
    );
    return SingleChildScrollView(
      child: AlertDialog(
        titlePadding: EdgeInsets.zero,
        title: Container(
          color: ColorManager.blueBright,
          width: size.width,
          height: size.height * 0.06,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: AppHeight.h8),
                child: Text(
                  'Cash Receive:',
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
                      watchPostBusinessAgentProvider!.clear(context);
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
                  'Customer Name: ',
                  style: getMediumStyle(fontSize: FontSize.s18, color: ColorManager.blackOpacity87),
                ),
                Text(
                  widget.billDescription,
                  style: getRegularStyle(fontSize: FontSize.s18, color: ColorManager.blackOpacity87),
                ),
              ],
            ),
            SizedBox(height: AppHeight.h10),
            // Container(
            //   width: size.width,
            //   margin: EdgeInsets.only(bottom: AppHeight.h10),
            //   child: TextFormField(
            //     style: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
            //     validator: (value) {
            //       if (value == null || value.isEmpty) {
            //         return '*Required';
            //       }
            //       return null;
            //     },
            //     keyboardType: TextInputType.text,
            //     readOnly: true,
            //     controller: watchPostBusinessAgentProvider!.nameTextEditingController,
            //     textInputAction: TextInputAction.done,
            //     decoration: InputDecoration(
            //       fillColor: ColorManager.grey3,
            //       filled: true,
            //       contentPadding: EdgeInsets.symmetric(
            //         vertical: AppHeight.h20,
            //         horizontal: AppWidth.w10,
            //       ),
            //       border: OutlineInputBorder(
            //         borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
            //         borderRadius: BorderRadius.circular(AppRadius.r10),
            //       ),
            //       labelText: 'Customer Name',
            //       labelStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.grey),
            //     ),
            //   ),
            // ),
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
                    style: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*Required';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    controller: watchPostBusinessAgentProvider!.amountTextEditingController,
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
                        hintText: 'Amount',
                        hintStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.blackOpacity87),
                        labelStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.blackOpacity87),
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
                style: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '*Required';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                controller: watchPostBusinessAgentProvider!.descriptionTextEditingController,
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
                  labelStyle: getMediumStyle(
                    fontSize: FontSize.s14,
                    color: ColorManager.blackOpacity87,
                  ),
                  hintText: 'Description',
                  hintStyle: getMediumStyle(
                    fontSize: FontSize.s14,
                    color: ColorManager.blackOpacity87,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
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
                    watchPostBusinessAgentProvider!.clear(context);
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
  }

  onSave() async {
    if (watchPostBusinessAgentProvider!.amountTextEditingController.text.isEmpty) {
      Fluttertoast.cancel();
      return Fluttertoast.showToast(
        msg: 'Amount is Empty',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ColorManager.error,
      );
    } else if (watchPostBusinessAgentProvider!.descriptionTextEditingController.text.isEmpty) {
      Fluttertoast.cancel();
      return Fluttertoast.showToast(
        msg: 'Description is Empty',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ColorManager.error,
      );
    } else {
      var response = await context.read<PostBusinessAgentProvider>().postBusinessAgent(
            watchPostBusinessAgentProvider!.descriptionTextEditingController.text,
            watchPostBusinessAgentProvider!.dateSelect.toString(),
            double.parse(watchPostBusinessAgentProvider!.amountTextEditingController.text),
            widget.agtId,
          );

      if (response["responseType"] == 6) {
        if (!mounted) return;
        watchPostBusinessAgentProvider!.clear(context);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const AgentPage(),
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
