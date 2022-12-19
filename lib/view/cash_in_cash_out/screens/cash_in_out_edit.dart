import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/cash_in_cash_out/cash_in_cash_out_page.dart';
import 'package:webshop/view/cash_in_cash_out/model/post_business_model.dart';
import 'package:webshop/view/cash_in_cash_out/provider/edit_cash_in_out_provider.dart';
import 'package:webshop/view/supplier/provider/post_business_supplier_provider.dart';

class CashInOutEdit extends StatefulWidget {
  final int billId;

  const CashInOutEdit({super.key, required this.billId});

  @override
  State<CashInOutEdit> createState() => _CashInOutEditPageState();
}

class _CashInOutEditPageState extends State<CashInOutEdit> {
  TabletSetupServiceProvider? watchTabletSetupServiceProvider;
  PostBusinessSupplierServiceProvider? watchPostBusinessSupplierProvider;
  EditCashInOutProvider? readEditCashInOutProvider;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController custommerNameController = TextEditingController();
  TextEditingController supplierNameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController inserterController = TextEditingController();

  double oValue = 0.0;
  final formKey = GlobalKey<FormState>();
  int? stkId;
  String? groupName, brandName;
  bool isChecked = false;
  String? gender = 'm';
  String? fromDate;
  int? groupId;
  int? brandId;

  @override
  void initState() {
    // List<BillDesList>? billCode = context.read<TabletSetupServiceProvider>().tabletSetupModel.data!.billDesList!.where((element) => element.b == widget.bdId).toList();
    // context.read<EditCashInOutProvider>().billDesList = billCode.first;
    // context.read<EditCashInOutProvider>().setBillCode(widget.bdId.toString());
    getApi();
    super.initState();
  }

  getApi() async {
    readEditCashInOutProvider = context.read<EditCashInOutProvider>();
    var data = await context.read<EditCashInOutProvider>().getGetBusinessById(widget.billId);
    if (data.data != null) {
      if (!mounted) return;
      var billCode = context.read<TabletSetupServiceProvider>().tabletSetupModel.data!.billDesList!.where((element) => element.bdId == data.data!.billCodeId).toList();
      readEditCashInOutProvider!.setSelectFromDate(DateTime.parse(readEditCashInOutProvider!.getBusinessByIdModel.data!.billDate.toString()));
      inserterController.text = readEditCashInOutProvider!.getBusinessByIdModel.data!.billAddedByStaff.toString();
      amountController.text = readEditCashInOutProvider!.getBusinessByIdModel.data!.billTotalAmt.toString();
      descriptionController.text = readEditCashInOutProvider!.getBusinessByIdModel.data!.billDescription.toString();
      context.read<EditCashInOutProvider>().billDesList = billCode.first;
      context.read<EditCashInOutProvider>().setBillCode(data.data!.billCodeId.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    watchTabletSetupServiceProvider = context.watch<TabletSetupServiceProvider>();

    fromDate = readEditCashInOutProvider!.selectFromDate.toString().split(" ")[0].toString();

    watchPostBusinessSupplierProvider = context.watch<PostBusinessSupplierServiceProvider>();

    Size size = MediaQuery.of(context).size;
    Widget labelStartDate = InkWell(
      onTap: () {
        selectFromDate();
      },
      child: Container(
        height: size.height * 0.088,
        width: size.width * 0.46,
        padding: EdgeInsets.all(AppHeight.h4),
        child: InputDecorator(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: AppWidth.w10),
            labelText: 'Date',
            labelStyle: getMediumStyle(
              fontSize: FontSize.s16,
              color: ColorManager.grey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r5),
              borderSide: BorderSide(
                color: ColorManager.grey,
                width: 10.0,
              ),
            ),
          ),
          child: Center(
            child: Text(
              fromDate.toString(),
              style: getBoldStyle(
                fontSize: FontSize.s14,
                color: ColorManager.black,
              ),
            ),
          ),
        ),
      ),
    );

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          centerTitle: true,
          elevation: 1,
          backgroundColor: Colors.blue,
          title: Text(
            'Edit Cash In/Out',
            style: getBoldStyle(fontSize: FontSize.s18, color: ColorManager.white),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppWidth.w10),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Form(
              key: formKey,
              child: ListView(
                children: <Widget>[
                  SizedBox(height: AppHeight.h10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      labelStartDate,
                      SizedBox(
                        width: size.width * .4,
                        child: TextFormField(
                          style: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.grey),
                          readOnly: true,
                          controller: inserterController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h19, horizontal: AppWidth.w10),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                borderRadius: BorderRadius.circular(AppRadius.r4),
                              ),
                              labelText: 'Inserter',
                              hintStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                              hintText: 'Inserter',
                              labelStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                              floatingLabelBehavior: FloatingLabelBehavior.always),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppHeight.h10),
                  // widget.model.supName == null
                  //     ? SizedBox(
                  //         height: size.height * 0.08,
                  //         width: size.width * .75,
                  //         child: TypeAheadFormField<AgentList>(
                  //           textFieldConfiguration: TextFieldConfiguration(
                  //             style: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                  //             controller: custommerNameController,
                  //             decoration: InputDecoration(
                  //               contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h20, horizontal: AppWidth.w10),
                  //               suffixIcon: IconButton(
                  //                   onPressed: () {},
                  //                   icon: Icon(
                  //                     Icons.arrow_drop_down,
                  //                     color: ColorManager.blueBright,
                  //                   )),
                  //               prefixIcon: Icon(
                  //                 Icons.person,
                  //                 color: ColorManager.blueBright,
                  //               ),
                  //               border: OutlineInputBorder(
                  //                 borderSide: BorderSide(width: 2, color: ColorManager.blackOpacity38),
                  //                 borderRadius: BorderRadius.circular(AppRadius.r5),
                  //               ),
                  //               fillColor: ColorManager.white,
                  //               filled: true,
                  //               hintText: 'Customer',
                  //               hintStyle: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.grey),
                  //               focusedBorder: OutlineInputBorder(
                  //                 borderSide: BorderSide(color: ColorManager.blueBright),
                  //                 borderRadius: BorderRadius.circular(AppRadius.r10),
                  //               ),
                  //               errorBorder: OutlineInputBorder(
                  //                 borderSide: BorderSide(color: ColorManager.red),
                  //                 borderRadius: BorderRadius.circular(AppRadius.r10),
                  //               ),
                  //             ),
                  //           ),
                  //           onSuggestionSelected: (AgentList agent) {
                  //             readCashInCashOutProvider!.setCusId(agent.agtId);
                  //           },
                  //           itemBuilder: (context, AgentList agent) => ListTile(
                  //             title: Text(
                  //               agent.agtCompany.toString(),
                  //               style: getRegularStyle(
                  //                 fontSize: FontSize.s12,
                  //                 color: ColorManager.black,
                  //               ),
                  //             ),
                  //           ),
                  //           suggestionsCallback: getAgentSuggestion,
                  //         ),
                  //       )
                  //     : SizedBox(
                  //         height: size.height * 0.08,
                  //         width: size.width * .75,
                  //         child: TypeAheadFormField<SupplierList>(
                  //           textFieldConfiguration: TextFieldConfiguration(
                  //             controller: supplierNameController,
                  //             decoration: InputDecoration(
                  //               contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h20, horizontal: AppWidth.w10),
                  //               suffixIcon: IconButton(
                  //                   onPressed: () {},
                  //                   icon: Icon(
                  //                     Icons.arrow_drop_down,
                  //                     color: ColorManager.blueBright,
                  //                   )),
                  //               prefixIcon: Icon(
                  //                 Icons.person,
                  //                 color: ColorManager.blueBright,
                  //               ),
                  //               border: OutlineInputBorder(
                  //                 borderSide: BorderSide(width: 2, color: ColorManager.blackOpacity38),
                  //                 borderRadius: BorderRadius.circular(AppRadius.r5),
                  //               ),
                  //               fillColor: ColorManager.white,
                  //               filled: true,
                  //               hintText: 'Suppliers',
                  //               hintStyle: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.grey),
                  //               focusedBorder: OutlineInputBorder(
                  //                 borderSide: BorderSide(color: ColorManager.blueBright),
                  //                 borderRadius: BorderRadius.circular(AppRadius.r10),
                  //               ),
                  //               errorBorder: OutlineInputBorder(
                  //                 borderSide: BorderSide(color: ColorManager.red),
                  //                 borderRadius: BorderRadius.circular(AppRadius.r10),
                  //               ),
                  //             ),
                  //           ),
                  //           onSuggestionSelected: (SupplierList supplier) {
                  //             readCashInCashOutProvider!.setSupId(supplier.supId);
                  //           },
                  //           itemBuilder: (context, SupplierList supplier) => ListTile(
                  //             title: Text(
                  //               supplier.supName.toString(),
                  //               style: getRegularStyle(
                  //                 fontSize: FontSize.s12,
                  //                 color: ColorManager.black,
                  //               ),
                  //             ),
                  //           ),
                  //           suggestionsCallback: getSupplierSuggestion,
                  //         ),
                  //       ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SingleChildScrollView(
                        child: SizedBox(
                          height: size.height * 0.078,
                          width: size.width * 0.6,
                          child: DropdownButtonFormField<BillDesList>(
                            validator: (value) {
                              if (value == null) {
                                return '*Required';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h19, horizontal: AppWidth.w10),
                              hintText: 'Bill Code',
                              label: Text(
                                "Bill Code",
                                style: getRegularStyle(
                                  fontSize: FontSize.s16,
                                  color: ColorManager.black,
                                ),
                              ),
                              hintStyle: getSemiBoldStyle(
                                fontSize: FontSize.s14,
                                color: ColorManager.blackOpacity54,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                borderRadius: BorderRadius.circular(AppRadius.r5),
                              ),
                            ),
                            itemHeight: size.height * 0.07,
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down),
                            iconEnabledColor: ColorManager.skyBlue,
                            iconSize: FontSize.s20,
                            items: watchTabletSetupServiceProvider!.tabletSetupModel.data!.billDesList!.where((element) => element.bdVisible == true).map((project) {
                              return DropdownMenuItem<BillDesList>(
                                value: project,
                                child: Container(
                                  margin: EdgeInsets.only(left: AppWidth.w1),
                                  padding: EdgeInsets.only(left: AppWidth.w10),
                                  height: size.height * 0.08,
                                  width: double.infinity,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      project.bdName.toString(),
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
                              readEditCashInOutProvider!.billDesList = paymentMode!;
                              readEditCashInOutProvider!.setBillCode(paymentMode.bdId.toString());
                            },
                            value: readEditCashInOutProvider!.billDesList,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppHeight.h10),
                  Row(
                    children: [
                      SizedBox(
                        width: size.width * .6,
                        child: TextFormField(
                          style: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h20, horizontal: AppWidth.w10),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                borderRadius: BorderRadius.circular(AppRadius.r5),
                              ),
                              labelText: 'Amount',
                              labelStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                              hintText: 'Amount',
                              hintStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                              floatingLabelBehavior: FloatingLabelBehavior.always),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppHeight.h10),
                  SizedBox(
                    width: size.width * .75,
                    child: TextFormField(
                      style: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                      controller: descriptionController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '*Required';
                        }
                        return null;
                      },
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h20, horizontal: AppWidth.w10),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                            borderRadius: BorderRadius.circular(AppRadius.r10),
                          ),
                          labelText: 'Description',
                          labelStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                          hintText: 'Description',
                          hintStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                    ),
                  ),
                  SizedBox(
                    height: AppHeight.h10,
                  ),
                  Row(
                    children: [
                      const Text('Inactive'),
                      Checkbox(
                        focusColor: ColorManager.black,
                        value: isChecked,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: ConstrainedBox(
                          constraints: BoxConstraints.tightFor(width: size.width * 0.8, height: size.height * 0.06),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(ColorManager.green),
                              shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                                (Set<MaterialState> states) {
                                  return RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(AppRadius.r50),
                                  );
                                },
                              ),
                            ),
                            onPressed: () {
                              onSave();
                            },
                            child: Text(
                              "Save",
                              style: getBoldStyle(
                                fontSize: FontSize.s15,
                                color: ColorManager.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: AppHeight.h10,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void selectFromDate() async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: readEditCashInOutProvider!.selectFromDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2090),
    );
    if (selected != null && selected != readEditCashInOutProvider!.selectFromDate) {
      readEditCashInOutProvider!.setSelectFromDate(selected);

      setState(() {});
    }
  }

  List<SupplierList> getSupplierSuggestion(String query) => List.of(watchTabletSetupServiceProvider!.tabletSetupModel.data!.supplierList!).where((SupplierList supplier) {
        final stockNameLower = supplier.supName!.toLowerCase();
        final queryLower = query.toLowerCase();
        return stockNameLower.contains(queryLower);
      }).toList();
  List<AgentList> getAgentSuggestion(String query) => List.of(watchTabletSetupServiceProvider!.tabletSetupModel.data!.agentList!).where((element) => element.agtCategory == 1).where((AgentList agent) {
        final stockNameLower = agent.agtCompany!.toLowerCase();
        final queryLower = query.toLowerCase();
        return stockNameLower.contains(queryLower);
      }).toList();

  onSave() async {
    if (amountController.text.isEmpty) {
      Fluttertoast.cancel();
      return Fluttertoast.showToast(
        msg: 'Amount is Empty',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ColorManager.error,
      );
    } else if (descriptionController.text.isEmpty) {
      Fluttertoast.cancel();
      return Fluttertoast.showToast(
        msg: 'Description is Empty',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ColorManager.error,
      );
    } else {
      PostBusiness postBusinessSupplier = PostBusiness(
        billId: readEditCashInOutProvider!.getBusinessByIdModel.data!.billId!,
        billPMode: 2,
        billDescription: descriptionController.text,
        billDate: fromDate.toString(),
        billTotalAmt: double.parse(amountController.text),
        billCodeId: int.parse(readEditCashInOutProvider!.billCode!),
        billAddedBy: int.parse(sharedPref!.getString('staffId').toString()),
        billInActive: isChecked,
        billDeletedBy: isChecked ? int.parse(sharedPref!.getString('staffId').toString()) : null,
        billDeletedOn: isChecked ? DateTime.now().toString() : null,
        billDeletedReason: isChecked ? descriptionController.text : null,
      );

      var response = await context.read<PostBusinessSupplierServiceProvider>().postServiceSupplier(postBusinessSupplier);

      if (response["responseType"] == 6) {
        if (!mounted) return;
        watchPostBusinessSupplierProvider!.clear(context);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const CashInCashOutPage(),
            ),
            (route) => false);
        Fluttertoast.cancel();
        return Fluttertoast.showToast(
          msg: 'Edit Successfull',
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
