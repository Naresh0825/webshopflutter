import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/agent/agent_page.dart';
import 'package:webshop/view/agent/model/agent_model.dart';
import 'package:webshop/view/agent/provider/add_agent_provider.dart';

class AddAgentScreen extends StatefulWidget {
  final AgentModel? agentModel;

  const AddAgentScreen({
    super.key,
    this.agentModel,
  });

  @override
  State<AddAgentScreen> createState() => _AddAgentScreenState();
}

class _AddAgentScreenState extends State<AddAgentScreen> {
  String? category, agent;
  int? agentId;

  String? openingDate;
  String? agentOpeningDate;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController vatNoController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController openingDueController = TextEditingController();
  final TextEditingController balanceController = TextEditingController();
  final TextEditingController paymentCategoryListController = TextEditingController();
  final TextEditingController agentListController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  bool isActive = false;

  DateTime selectedDate = DateTime.now();

  final formKey = GlobalKey<FormState>();

  void selectFromDate() async {
    selectedDate = DateTime.parse(agentOpeningDate.toString());

    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2090),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        openingDate = null;
        selectedDate = selected;
      });
    }
  }

  @override
  void initState() {
    context.read<TabletSetupServiceProvider>();
    if (widget.agentModel != null) {
      agentOpeningDate = widget.agentModel!.agtOpDate;
      agentId = widget.agentModel!.agtId;
      nameController.text = widget.agentModel!.agtCompany!;
      addressController.text = widget.agentModel!.agtAdress!;
      vatNoController.text = (widget.agentModel!.agtVatNo == null) ? '' : widget.agentModel!.agtVatNo.toString();
      mobileController.text = widget.agentModel!.agtMobile!;
      telephoneController.text = widget.agentModel!.agtTel!;
      openingDueController.text = (widget.agentModel!.agtOpAmount == null) ? '' : widget.agentModel!.agtOpAmount.toString();
      balanceController.text = (widget.agentModel!.agtAmount == null) ? '' : widget.agentModel!.agtAmount.toString();
      paymentCategoryListController.text = widget.agentModel!.agtCategory.toString();
      agentListController.text = widget.agentModel!.agtCompany!;
      category = widget.agentModel!.agtCategory.toString();
      agent = widget.agentModel!.agtSrourceId.toString();

      isActive = widget.agentModel!.agtInactive!;
    } else {
      agent = agentSource[0]["id"];
      category = customerTypeTranList[0]["id"];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TabletSetupServiceProvider watchTabletSetupServiceProvider = context.watch<TabletSetupServiceProvider>();
    Color labelAndHintTextColor = ColorManager.blackOpacity54;
    Size size = MediaQuery.of(context).size;
    if (openingDate == null) {
      agentOpeningDate = selectedDate.toString().split(" ")[0].toString();
    } else {
      agentOpeningDate = openingDate;
    }

    Widget labelStartDate = InkWell(
      onTap: () {
        selectFromDate();
      },
      child: SizedBox(
        height: size.height * 0.07,
        width: size.width * 0.25,
        child: Center(
          child: Text(
            agentOpeningDate.toString(),
            style: getMediumStyle(
              fontSize: FontSize.s16,
              color: ColorManager.black,
            ),
          ),
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: ColorManager.blueBright,
        title: Text(
          widget.agentModel != null ? 'Update Customer' : 'Add Customer',
          style: getMediumStyle(
            fontSize: FontSize.s20,
            color: ColorManager.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: AppHeight.h10),
                      child: TextFormField(
                        style: getRegularStyle(fontSize: FontSize.s16, color: ColorManager.black),
                        textCapitalization: TextCapitalization.words,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: nameController,
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
                            labelText: 'Name',
                            hintText: 'Customer Name',
                            labelStyle: getMediumStyle(
                              fontSize: FontSize.s16,
                              color: labelAndHintTextColor,
                            ),
                            hintStyle: getMediumStyle(
                              fontSize: FontSize.s16,
                              color: labelAndHintTextColor,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '*Required';
                          }
                          return null;
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: size.width * .46,
                          margin: EdgeInsets.only(bottom: AppHeight.h10),
                          child: TextFormField(
                            style: TextStyle(color: ColorManager.black),
                            controller: addressController,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h20, horizontal: AppWidth.w10),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                  borderRadius: BorderRadius.circular(AppRadius.r10),
                                ),
                                labelText: 'Address',
                                hintText: 'Address',
                                labelStyle: getMediumStyle(
                                  fontSize: FontSize.s16,
                                  color: labelAndHintTextColor,
                                ),
                                hintStyle: getMediumStyle(
                                  fontSize: FontSize.s16,
                                  color: labelAndHintTextColor,
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.always),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: AppHeight.h10),
                          width: size.width * .46,
                          child: TextFormField(
                            controller: vatNoController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              String patttern = r'(^(?:[+0]9)?[0-9]{10}$)';
                              RegExp regExp = RegExp(patttern);
                              if (value == null || value.isEmpty) {
                                return null;
                              } else if (!regExp.hasMatch(value)) {
                                return 'Enter valid number';
                              } else {
                                return null;
                              }
                            },
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h20, horizontal: AppWidth.w10),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                  borderRadius: BorderRadius.circular(AppRadius.r10),
                                ),
                                labelText: 'Vat No.',
                                hintText: 'Vat no.',
                                labelStyle: getMediumStyle(
                                  fontSize: FontSize.s16,
                                  color: labelAndHintTextColor,
                                ),
                                hintStyle: getMediumStyle(
                                  fontSize: FontSize.s16,
                                  color: labelAndHintTextColor,
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.always),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: AppHeight.h2),
                          margin: EdgeInsets.only(bottom: AppHeight.h10),
                          width: size.width * .46,
                          child: InputDecorator(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: AppWidth.w10),
                              labelText: 'Date',
                              labelStyle: getMediumStyle(
                                fontSize: FontSize.s16,
                                color: labelAndHintTextColor,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppRadius.r5),
                                borderSide: BorderSide(
                                  color: labelAndHintTextColor,
                                  width: 10.0,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: ColorManager.blueBright,
                                ),
                                labelStartDate,
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: size.width * .46,
                          margin: EdgeInsets.only(bottom: AppHeight.h10),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: openingDueController,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h20, horizontal: AppWidth.w10),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                  borderRadius: BorderRadius.circular(AppRadius.r10),
                                ),
                                labelText: 'Opening Due',
                                hintText: 'Opening Due',
                                labelStyle: getMediumStyle(
                                  fontSize: FontSize.s16,
                                  color: labelAndHintTextColor,
                                ),
                                hintStyle: getMediumStyle(
                                  fontSize: FontSize.s16,
                                  color: labelAndHintTextColor,
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.always),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: size.width * 0.46,
                          margin: EdgeInsets.only(bottom: AppHeight.h10),
                          child: TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              String patttern = r'(^(?:[+0]9)?[0-9]{10}$)';
                              RegExp regExp = RegExp(patttern);
                              if (value == null || value.isEmpty) {
                                return null;
                              } else if (!regExp.hasMatch(value)) {
                                return 'Enter valid number';
                              } else {
                                return null;
                              }
                            },
                            keyboardType: TextInputType.number,
                            controller: mobileController,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h20, horizontal: AppWidth.w10),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                  borderRadius: BorderRadius.circular(AppRadius.r10),
                                ),
                                labelText: 'Mobile',
                                hintText: 'Mobile number',
                                labelStyle: getMediumStyle(
                                  fontSize: FontSize.s16,
                                  color: labelAndHintTextColor,
                                ),
                                hintStyle: getMediumStyle(
                                  fontSize: FontSize.s16,
                                  color: labelAndHintTextColor,
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.always),
                          ),
                        ),
                        Container(
                          width: size.width * 0.46,
                          margin: EdgeInsets.only(bottom: AppHeight.h10),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: telephoneController,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h20, horizontal: AppWidth.w10),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                  borderRadius: BorderRadius.circular(AppRadius.r10),
                                ),
                                labelText: 'Telephone',
                                hintText: 'Telephone',
                                labelStyle: getMediumStyle(
                                  fontSize: FontSize.s16,
                                  color: labelAndHintTextColor,
                                ),
                                hintStyle: getMediumStyle(
                                  fontSize: FontSize.s16,
                                  color: labelAndHintTextColor,
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.always),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.only(bottom: AppHeight.h10),
                            width: size.width * 0.46,
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Category',
                                hintText: 'Category',
                                labelStyle: getSemiBoldStyle(
                                  fontSize: FontSize.s14,
                                  color: labelAndHintTextColor,
                                ),
                                hintStyle: getSemiBoldStyle(
                                  fontSize: FontSize.s14,
                                  color: labelAndHintTextColor,
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                  borderRadius: BorderRadius.circular(AppRadius.r10),
                                ),
                              ),
                              itemHeight: size.height * 0.08,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down),
                              iconEnabledColor: ColorManager.skyBlue,
                              iconSize: FontSize.s25,
                              items: customerTypeTranList.map((project) {
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
                                        style: getRegularStyle(
                                          fontSize: FontSize.s16,
                                          color: ColorManager.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (categories) {
                                category = categories!;
                              },
                              value: category,
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.only(bottom: AppHeight.h10),
                            width: size.width * 0.46,
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                hintText: 'Agent Source',
                                labelText: 'Agent Source',
                                hintStyle: getSemiBoldStyle(
                                  fontSize: FontSize.s14,
                                  color: labelAndHintTextColor,
                                ),
                                labelStyle: getSemiBoldStyle(
                                  fontSize: FontSize.s14,
                                  color: labelAndHintTextColor,
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                  borderRadius: BorderRadius.circular(AppRadius.r10),
                                ),
                              ),
                              itemHeight: size.height * 0.08,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down),
                              iconEnabledColor: ColorManager.skyBlue,
                              iconSize: FontSize.s25,
                              items: agentSource.map((project) {
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
                                        style: getRegularStyle(
                                          fontSize: FontSize.s16,
                                          color: ColorManager.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (categories) {
                                agent = categories!;
                              },
                              value: agent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: size.width * 0.46,
                          margin: EdgeInsets.only(bottom: AppHeight.h10),
                          child: TextFormField(
                            readOnly: true,
                            keyboardType: TextInputType.number,
                            controller: balanceController,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                                fillColor: ColorManager.grey3,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h20, horizontal: AppWidth.w10),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                  borderRadius: BorderRadius.circular(AppRadius.r10),
                                ),
                                labelText: 'Balance',
                                hintText: 'Balance',
                                labelStyle: getMediumStyle(
                                  fontSize: FontSize.s16,
                                  color: labelAndHintTextColor,
                                ),
                                hintStyle: getMediumStyle(
                                  fontSize: FontSize.s16,
                                  color: labelAndHintTextColor,
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.always),
                          ),
                        ),
                        Container(
                          width: size.width * 0.46,
                          margin: EdgeInsets.only(bottom: AppHeight.h10),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: discountController,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h20, horizontal: AppWidth.w10),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                  borderRadius: BorderRadius.circular(AppRadius.r10),
                                ),
                                labelText: 'Discount',
                                hintText: 'Discount',
                                labelStyle: getMediumStyle(
                                  fontSize: FontSize.s16,
                                  color: labelAndHintTextColor,
                                ),
                                hintStyle: getMediumStyle(
                                  fontSize: FontSize.s16,
                                  color: labelAndHintTextColor,
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.always),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: AppWidth.w5),
                    Row(
                      children: [
                        const Text('Inactive'),
                        Checkbox(
                          focusColor: ColorManager.black,
                          value: isActive,
                          onChanged: (value) {
                            setState(() {
                              isActive = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      width: size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(AppHeight.h10),
                          backgroundColor: ColorManager.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.r10),
                          ),
                        ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            AgentModel agentModel = AgentModel(
                              agtId: agentId ?? 0,
                              agtCompany: nameController.text,
                              agtAdress: addressController.text,
                              agtVatNo: vatNoController.text.isEmpty ? null : int.parse(vatNoController.text),
                              agtTel: telephoneController.text,
                              agtMobile: mobileController.text,
                              agtCategory: int.parse(category.toString()),
                              agtOpAmount: double.parse(openingDueController.text.isEmpty ? '0' : openingDueController.text),
                              agtAmount: double.parse(balanceController.text.isEmpty ? '0' : balanceController.text),
                              agtSrourceId: int.parse(agent.toString()),
                              agtOpDate: agentOpeningDate!,
                              agtInactive: isActive,
                              agtDiscount: double.parse(discountController.text.isEmpty ? '0' : discountController.text),
                            );

                            var response = await context.read<AddAgentProvider>().createAgent(agentModel);

                            if (response != null) {
                              if (response["success"] == true) {
                                Fluttertoast.showToast(
                                  msg: widget.agentModel != null ? 'Agent Updated Successfully' : 'Agent Added Succesfully',
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: ColorManager.black,
                                );
                                //clear all text field
                                nameController.clear();
                                addressController.clear();
                                vatNoController.clear();
                                mobileController.clear();
                                telephoneController.clear();
                                openingDueController.clear();
                                balanceController.clear();
                                paymentCategoryListController.clear();
                                agentListController.clear();
                                isActive = isActive;
                                if (!mounted) return;
                                if (addCustomerFromSales == true) {
                                  context.read<TabletSetupServiceProvider>().getTabletSetup();

                                  Navigator.pop(context, watchTabletSetupServiceProvider.tabletSetupModel.data);
                                  addCustomerFromSales == false;
                                }
                                if (addCustomerFromSales == false) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const AgentPage(),
                                      ),
                                      (route) => false);
                                }
                              } else {
                                Fluttertoast.cancel();
                                Fluttertoast.showToast(
                                  msg: 'Error occured',
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: ColorManager.error,
                                );
                              }
                            }
                          }
                        },
                        child: Text(
                          (widget.agentModel != null) ? 'Update Agent' : 'Add Agent',
                          style: getBoldStyle(fontSize: FontSize.s18, color: ColorManager.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
