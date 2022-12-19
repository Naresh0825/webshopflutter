import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/supplier/model/supplier_model.dart';
import 'package:webshop/view/supplier/provider/add_supplier_provider.dart';

class AddSupplierScreen extends StatefulWidget {
  final SupplierModel? supplierModel;
  const AddSupplierScreen({super.key, this.supplierModel});

  @override
  State<AddSupplierScreen> createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends State<AddSupplierScreen> {
  int? supplierId;
  String? openingDate;
  String? supplierOpeningDate;
  bool isChecked = false;

  DateTime selectedDate = DateTime.now();

  final formKey = GlobalKey<FormState>();

  TextEditingController supplierTextEditingController = TextEditingController();
  TextEditingController addressTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController mobileTextEditingController = TextEditingController();
  TextEditingController vatTextEditingController = TextEditingController();
  TextEditingController dueTextEditingController = TextEditingController();
  TextEditingController balanceTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.supplierModel != null) {
      supplierId = widget.supplierModel!.supId;
      supplierTextEditingController.text = widget.supplierModel!.supName;
      addressTextEditingController.text = widget.supplierModel!.supAddress;
      phoneTextEditingController.text = widget.supplierModel!.supPhone;
      mobileTextEditingController.text = widget.supplierModel?.supMobile ?? '';
      vatTextEditingController.text = (widget.supplierModel!.supVat == 0) ? '' : widget.supplierModel!.supVat.toString();
      dueTextEditingController.text = widget.supplierModel!.supOpAmt.toString();
      balanceTextEditingController.text = widget.supplierModel!.supAmt.toString();
      isChecked = widget.supplierModel!.supInActive;
      if (widget.supplierModel?.supMobile == null || widget.supplierModel!.supMobile == "null") {
        mobileTextEditingController.text = '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Color labelAndHintTextColor = ColorManager.blackOpacity54;

    if (widget.supplierModel == null) {
      if (openingDate == null) {
        supplierOpeningDate = selectedDate.toString().split(" ")[0].toString();
      } else {
        supplierOpeningDate = openingDate;
      }
    } else {
      if (widget.supplierModel?.supOpDate == null || widget.supplierModel?.supOpDate == "null") {
        supplierOpeningDate = DateTime.parse(DateTime.now().toString()).toIso8601String().split("T")[0].toString();
      } else {
        supplierOpeningDate = DateTime.parse(widget.supplierModel!.supOpDate.toString()).toIso8601String().split("T")[0].toString();
      }
    }

    Widget labelStartDate = InkWell(
      onTap: (widget.supplierModel != null)
          ? () {}
          : () {
              selectFromDate();
            },
      child: Container(
        height: size.height * 0.07,
        width: size.width * 0.25,
        padding: EdgeInsets.all(AppHeight.h4),
        child: Center(
          child: Text(
            supplierOpeningDate.toString(),
            style: getMediumStyle(
              fontSize: FontSize.s14,
              color: ColorManager.black,
            ),
          ),
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          (widget.supplierModel != null) ? 'Update Supplier'.toUpperCase() : 'Add Supplier'.toUpperCase(),
          style: getBoldStyle(
            color: ColorManager.white,
            fontSize: FontSize.s14,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                ColorManager.blueBright,
                ColorManager.blue,
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
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Consumer<ConnectivityProvider>(
              builder: (context, connectivity, child) {
                return (connectivity.isOnline == false)
                    ? const NoInternet()
                    : Padding(
                        padding: EdgeInsets.all(AppHeight.h10),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: AppHeight.h10,
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: AppHeight.h10),
                                child: TextFormField(
                                  style: TextStyle(color: ColorManager.black),
                                  textCapitalization: TextCapitalization.words,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  controller: supplierTextEditingController,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h20, horizontal: AppWidth.w10),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                        borderRadius: BorderRadius.circular(AppRadius.r10),
                                      ),
                                      labelText: 'Name',
                                      hintText: 'Supplier Name',
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
                                      textCapitalization: TextCapitalization.words,
                                      controller: addressTextEditingController,
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
                                    width: size.width * 0.46,
                                    margin: EdgeInsets.only(bottom: AppHeight.h10),
                                    child: TextFormField(
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        String patttern = r'(^(?:[+0]9)?[0-9]{9}$)';
                                        RegExp regExp = RegExp(patttern);
                                        if (value == null || value.isEmpty) {
                                          return null;
                                        } else if (!regExp.hasMatch(value)) {
                                          return 'Enter valid number';
                                        } else {
                                          return null;
                                        }
                                      },
                                      style: TextStyle(color: ColorManager.black),
                                      controller: vatTextEditingController,
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h20, horizontal: AppWidth.w10),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                            borderRadius: BorderRadius.circular(AppRadius.r10),
                                          ),
                                          labelText: 'Vat number',
                                          hintText: 'Vat number',
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
                                    margin: EdgeInsets.only(bottom: AppHeight.h10),
                                    width: size.width * 0.46,
                                    child: TextFormField(
                                      style: TextStyle(color: ColorManager.black),
                                      keyboardType: TextInputType.phone,
                                      controller: phoneTextEditingController,
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h20, horizontal: AppWidth.w10),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                            borderRadius: BorderRadius.circular(AppRadius.r10),
                                          ),
                                          labelText: 'Phone',
                                          hintText: 'Phone',
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
                                    width: size.width * 0.46,
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
                                      style: TextStyle(color: ColorManager.black),
                                      controller: mobileTextEditingController,
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h20, horizontal: AppWidth.w10),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                            borderRadius: BorderRadius.circular(AppRadius.r10),
                                          ),
                                          labelText: 'Mobile',
                                          hintText: 'Mobile',
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
                                    padding: EdgeInsets.symmetric(horizontal: AppWidth.w07),
                                    margin: EdgeInsets.only(bottom: AppHeight.h10),
                                    width: size.width * .46,
                                    height: size.height * 0.075,
                                    child: InputDecorator(
                                      decoration: InputDecoration(
                                        labelText: 'Date',
                                        labelStyle: getMediumStyle(
                                          fontSize: FontSize.s16,
                                          color: labelAndHintTextColor,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(AppRadius.r10),
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
                                    margin: EdgeInsets.only(bottom: AppHeight.h10),
                                    width: size.width * .46,
                                    child: TextFormField(
                                      style: TextStyle(color: ColorManager.black),
                                      controller: dueTextEditingController,
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.number,
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
                                children: [
                                  Container(
                                    width: size.width * 0.46,
                                    margin: EdgeInsets.only(bottom: AppHeight.h10),
                                    child: TextFormField(
                                      readOnly: true,
                                      style: TextStyle(color: ColorManager.black),
                                      controller: balanceTextEditingController,
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.phone,
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
                                ],
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
                                      SupplierModel supplierModel = SupplierModel(
                                        supId: supplierId ?? 0,
                                        supName: supplierTextEditingController.text,
                                        supVat: (vatTextEditingController.text.isEmpty) ? 0 : int.parse(vatTextEditingController.text.toString()),
                                        supAddress: addressTextEditingController.text,
                                        supMobile: mobileTextEditingController.text,
                                        supPhone: phoneTextEditingController.text,
                                        supOpDate: supplierOpeningDate!,
                                        supOpAmt: (dueTextEditingController.text.isEmpty) ? 0.0 : double.parse(dueTextEditingController.text),
                                        supAmt: (balanceTextEditingController.text.isEmpty) ? 0.0 : double.parse(balanceTextEditingController.text),
                                        supInActive: isChecked,
                                      );
                                      var response = await context.read<AddSupplierProvider>().createSupplier(supplierModel);

                                      if (response != null) {
                                        if (response["success"] == true) {
                                          if (!mounted) return;

                                          Fluttertoast.showToast(
                                            msg: 'Supplier Added Succesfully',
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: ColorManager.black,
                                          );
                                          clear();
                                          context.read<TabletSetupServiceProvider>().getTabletSetup();
                                          if (!mounted) return;
                                          Navigator.pop(context);
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
                                    (widget.supplierModel != null) ? 'Update Supplier' : 'Add Supplier',
                                    style: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
              },
            ),
          ),
        ),
      ),
    );
  }

  void selectFromDate() async {
    selectedDate = DateTime.parse(supplierOpeningDate.toString());

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

  clear() {
    supplierTextEditingController.clear();
    addressTextEditingController.clear();
    phoneTextEditingController.clear();
    mobileTextEditingController.clear();
    vatTextEditingController.clear();
    dueTextEditingController.clear();
    balanceTextEditingController.clear();
  }
}
