import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/brand/provider/brand_provider.dart';
import 'package:webshop/view/group/provider/group_provider.dart';
import 'package:webshop/view/stock/model/add_stock_model.dart';
import 'package:webshop/view/stock/services/add_stock_provider.dart';
import 'package:webshop/view/stock/services/get_stock_detail_provider.dart';
import 'package:webshop/widgets/no_data_dialog.dart';

class AddStockPage extends StatefulWidget {
  final StockModel? stockModel;
  final String? brandName;
  const AddStockPage({super.key, this.stockModel, this.brandName});

  @override
  State<AddStockPage> createState() => _AddStockPageState();
}

class _AddStockPageState extends State<AddStockPage> {
  TextEditingController itemNameController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController reOrderController = TextEditingController();
  TextEditingController salesController = TextEditingController();
  TextEditingController currentBalanceController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController qtyController = TextEditingController(text: '');
  TextEditingController openingRateController = TextEditingController(text: '');
  TextEditingController openingBalanceController = TextEditingController(text: '');
  TextEditingController currentqtyController = TextEditingController(text: '0.0');
  TextEditingController currentRateController = TextEditingController(text: '0.0');
  TextEditingController brandController = TextEditingController();
  TextEditingController groupController = TextEditingController();

  double oValue = 0.0;
  final formKeyState = GlobalKey<FormState>();
  final formKeyBrand = GlobalKey<FormState>();
  final formKeyGroup = GlobalKey<FormState>();
  int? stkId;
  String? groupName, brandName;

  @override
  void initState() {
    if (widget.stockModel != null) {
      groupName = widget.stockModel!.stItemGroupName;
      brandName = widget.brandName;
      brandId = widget.stockModel!.stBrandId;
      groupId = widget.stockModel!.stItemGroupId;
      itemNameController = TextEditingController(text: widget.stockModel!.stDes);
      codeController = TextEditingController(text: widget.stockModel!.stCode);
      reOrderController = TextEditingController(text: widget.stockModel!.stReOrder.toString());
      salesController = TextEditingController(text: widget.stockModel!.stSalesRate.toString());
      qtyController = TextEditingController(text: widget.stockModel!.stOBal.toString());
      openingRateController = TextEditingController(text: widget.stockModel!.stORate.toString());
      currentqtyController = TextEditingController(text: widget.stockModel!.stCurBal.toString());
      currentRateController = TextEditingController(text: widget.stockModel!.stCurRate.toString());
      currentBalanceController.text = (double.parse(currentqtyController.text.toString()) * double.parse(currentRateController.text.toString())).toString();
      context.read<TabletSetupServiceProvider>().selectBrandName(widget.stockModel!.stBrandId);
      context.read<TabletSetupServiceProvider>().selectGroupName(widget.stockModel!.stItemGroupId);
      openingBalanceController.text = widget.stockModel!.stOVal.toString();
      stkId = widget.stockModel!.stId;
    }
    currentBalanceController.text = (double.parse(currentqtyController.text.toString()) * double.parse(currentRateController.text.toString())).toStringAsFixed(2);
    if (double.parse(currentBalanceController.text) == -0.0) {
      currentBalanceController.text = double.parse(currentBalanceController.text).abs().toStringAsFixed(2);
    }
    super.initState();
  }

  bool shouldPop = true;
  bool isChecked = false;
  String? gender = 'm';
  int? groupId;
  int? brandId;
  @override
  Widget build(BuildContext context) {
    AddRemoveStockProvider readAddRemoveStockProvider = context.read<AddRemoveStockProvider>();
    BrandProvider readBrandProvider = context.read<BrandProvider>();
    GroupProvider readGroupProvider = context.read<GroupProvider>();
    TabletSetupServiceProvider watchTabletSetupProvider = context.watch<TabletSetupServiceProvider>();

    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        watchTabletSetupProvider.groupName = null;
        watchTabletSetupProvider.brandList = null;
        brandId = null;
        groupId = null;
        Navigator.pop(context);
        return shouldPop;
      },
      child: Consumer<ConnectivityProvider>(builder: (context, connectivity, child) {
        return (connectivity.isOnline == false)
            ? const NoInternet()
            : Scaffold(
                backgroundColor: Theme.of(context).colorScheme.background,
                appBar: AppBar(
                  centerTitle: true,
                  elevation: 1,
                  backgroundColor: ColorManager.white,
                  title: Text(
                    (widget.stockModel != null) ? 'Update Stock' : 'Add Stock',
                    style: getMediumStyle(fontSize: FontSize.s18, color: ColorManager.black),
                  ),
                  leading: IconButton(
                    onPressed: () {
                      watchTabletSetupProvider.groupName = null;
                      watchTabletSetupProvider.brandList = null;
                      brandId = null;
                      groupId = null;
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: ColorManager.black,
                    ),
                  ),
                ),
                body: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppWidth.w10),
                  child: watchTabletSetupProvider.tabletSetupModel.data!.itemGroupList == null
                      ? SizedBox(
                          height: size.height,
                          width: size.width,
                          child: const Center(
                            child: LoadingBox(),
                          ),
                        )
                      : Form(
                          key: formKeyState,
                          child: ListView(
                            children: <Widget>[
                              SizedBox(height: AppHeight.h10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: widget.stockModel != null ? size.width * .94 : size.width * .7,
                                    child: SingleChildScrollView(
                                      padding: EdgeInsets.only(bottom: AppHeight.h10),
                                      child: DropdownButtonFormField<BrandList>(
                                        hint: Text(
                                          'Brand',
                                          style: getMediumStyle(fontSize: FontSize.s15, color: ColorManager.black),
                                        ),
                                        validator: (value) {
                                          if (value == null) {
                                            return '*Required';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'Select brand',
                                          hintStyle: getMediumStyle(
                                            fontSize: FontSize.s16,
                                            color: ColorManager.black,
                                          ),
                                          labelText: 'Brand',
                                          labelStyle: getMediumStyle(
                                            fontSize: FontSize.s16,
                                            color: ColorManager.black,
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                            borderRadius: BorderRadius.circular(AppRadius.r10),
                                          ),
                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                        ),
                                        itemHeight: size.height * 0.08,
                                        isExpanded: true,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        iconEnabledColor: ColorManager.skyBlue,
                                        iconSize: FontSize.s30,
                                        items: watchTabletSetupProvider.tabletSetupModel.data!.brandList!
                                            .map(
                                              (e) => DropdownMenuItem<BrandList>(
                                                value: e,
                                                child: Container(
                                                  padding: EdgeInsets.only(left: AppWidth.w10),
                                                  height: size.height * 0.08,
                                                  width: double.infinity,
                                                  child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(
                                                      e.brandName.toString(),
                                                      style: getRegularStyle(
                                                        fontSize: FontSize.s16,
                                                        color: ColorManager.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (group) {
                                          watchTabletSetupProvider.brandList = group;
                                          brandId = widget.stockModel != null ? widget.stockModel!.stBrandId : group!.brandId;
                                        },
                                        value: watchTabletSetupProvider.brandList,
                                      ),
                                    ),
                                  ),
                                  widget.stockModel != null
                                      ? Container()
                                      : Padding(
                                          padding: EdgeInsets.only(bottom: AppHeight.h10),
                                          child: InkWell(
                                            onTap: () {
                                              getReportPopBrand(context, size, brandController, readBrandProvider);
                                            },
                                            customBorder: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            splashColor: ColorManager.grey,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(vertical: AppHeight.h2, horizontal: AppWidth.w2),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.black38, // red as border color
                                                ),
                                                borderRadius: BorderRadius.circular(AppRadius.r10),
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: size.height * .075,
                                                    width: size.width * .2,
                                                    decoration: const BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage("assets/images/brand.png"),
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: widget.stockModel != null ? size.width * .94 : size.width * .7,
                                    child: SingleChildScrollView(
                                      padding: EdgeInsets.only(bottom: AppHeight.h10),
                                      child: DropdownButtonFormField<ItemGroupList>(
                                        validator: (value) {
                                          if (value == null) {
                                            return '*Required';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Group',
                                          hintText: 'Select group',
                                          hintStyle: getMediumStyle(
                                            fontSize: FontSize.s16,
                                            color: ColorManager.black,
                                          ),
                                          labelStyle: getMediumStyle(
                                            fontSize: FontSize.s16,
                                            color: ColorManager.black,
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                            borderRadius: BorderRadius.circular(AppRadius.r10),
                                          ),
                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                        ),
                                        itemHeight: size.height * 0.08,
                                        isExpanded: true,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        iconEnabledColor: ColorManager.skyBlue,
                                        iconSize: FontSize.s30,
                                        items: watchTabletSetupProvider.tabletSetupModel.data!.itemGroupList!
                                            .map(
                                              (e) => DropdownMenuItem<ItemGroupList>(
                                                value: e,
                                                child: Container(
                                                  padding: EdgeInsets.only(left: AppWidth.w10),
                                                  height: size.height * 0.08,
                                                  width: double.infinity,
                                                  child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(
                                                      e.itemGroupName.toString(),
                                                      style: getRegularStyle(
                                                        fontSize: FontSize.s16,
                                                        color: ColorManager.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (group) {
                                          watchTabletSetupProvider.groupName = group;
                                          groupId = widget.stockModel != null ? widget.stockModel!.stItemGroupId : group!.itemGroupId;
                                        },
                                        value: watchTabletSetupProvider.groupName,
                                      ),
                                    ),
                                  ),
                                  widget.stockModel != null
                                      ? Container()
                                      : Padding(
                                          padding: EdgeInsets.only(bottom: AppHeight.h10),
                                          child: InkWell(
                                            onTap: () {
                                              getReportPopGroup(context, size, groupController, readGroupProvider);
                                            },
                                            customBorder: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            splashColor: ColorManager.grey,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(vertical: AppHeight.h2, horizontal: AppWidth.w2),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.black38, // red as border color
                                                ),
                                                borderRadius: BorderRadius.circular(AppRadius.r10),
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: size.height * .075,
                                                    width: size.width * .2,
                                                    decoration: const BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage("assets/images/group.png"),
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                ],
                              ),
                              SizedBox(
                                width: size.width * .75,
                                child: TextFormField(
                                  style: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '*Required';
                                    }
                                    return null;
                                  },
                                  controller: itemNameController,
                                  textCapitalization: TextCapitalization.sentences,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h20, horizontal: AppWidth.w10),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                        borderRadius: BorderRadius.circular(AppRadius.r10),
                                      ),
                                      labelText: 'Item Name',
                                      labelStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                      hintText: 'Enter Item Name',
                                      hintStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                      floatingLabelBehavior: FloatingLabelBehavior.always),
                                ),
                              ),
                              SizedBox(
                                height: AppHeight.h4,
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: AppHeight.h4, top: AppHeight.h10),
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: 'Opening',
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: size.width * .25,
                                        margin: EdgeInsets.only(bottom: AppHeight.h4),
                                        child: TextFormField(
                                          style: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                          controller: qtyController,
                                          textInputAction: TextInputAction.done,
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h20, horizontal: AppWidth.w10),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                                borderRadius: BorderRadius.circular(AppRadius.r10),
                                              ),
                                              labelText: 'Qty',
                                              labelStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                              hintText: 'Qty',
                                              hintStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                              floatingLabelBehavior: FloatingLabelBehavior.always),
                                          onChanged: (value) {
                                            if (openingRateController.text.isNotEmpty && value.isNotEmpty) {
                                              openingBalanceController.text = (double.parse(qtyController.text) * double.parse(openingRateController.text)).toString();
                                            }
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                      Container(
                                        width: size.width * .3,
                                        margin: EdgeInsets.only(bottom: AppHeight.h4),
                                        child: TextFormField(
                                          style: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                          controller: openingRateController,
                                          textInputAction: TextInputAction.done,
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h20, horizontal: AppWidth.w10),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                                borderRadius: BorderRadius.circular(AppRadius.r10),
                                              ),
                                              labelText: 'Rate',
                                              labelStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                              hintText: 'Rate',
                                              hintStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                              floatingLabelBehavior: FloatingLabelBehavior.always),
                                          onChanged: (value) {
                                            if (qtyController.text.isNotEmpty && value.isNotEmpty) {
                                              openingBalanceController.text = (double.parse(qtyController.text) * double.parse(openingRateController.text)).toString();
                                            }
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                      Container(
                                        width: size.width * .3,
                                        margin: EdgeInsets.only(bottom: AppHeight.h4),
                                        child: TextFormField(
                                          style: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                          controller: openingBalanceController,
                                          textInputAction: TextInputAction.done,
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h20, horizontal: AppWidth.w10),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                                borderRadius: BorderRadius.circular(AppRadius.r10),
                                              ),
                                              labelText: 'Balance',
                                              labelStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                              hintText: 'Balance',
                                              hintStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                              floatingLabelBehavior: FloatingLabelBehavior.always),
                                          onChanged: (value) {
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  bottom: AppHeight.h14,
                                  top: AppHeight.h10,
                                ),
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: 'Current',
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: size.width * .25,
                                        margin: EdgeInsets.only(bottom: AppHeight.h4),
                                        child: TextFormField(
                                          style: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                          readOnly: true,
                                          controller: currentqtyController,
                                          textInputAction: TextInputAction.done,
                                          decoration: InputDecoration(
                                              fillColor: ColorManager.grey3,
                                              filled: true,
                                              contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h20, horizontal: AppWidth.w10),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                                borderRadius: BorderRadius.circular(AppRadius.r10),
                                              ),
                                              labelText: 'Qty',
                                              labelStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                              hintText: 'Qty',
                                              hintStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                              floatingLabelBehavior: FloatingLabelBehavior.always),
                                        ),
                                      ),
                                      Container(
                                        width: size.width * .25,
                                        margin: EdgeInsets.only(bottom: AppHeight.h4),
                                        child: TextFormField(
                                          style: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                          readOnly: true,
                                          controller: currentRateController,
                                          textInputAction: TextInputAction.done,
                                          decoration: InputDecoration(
                                              fillColor: ColorManager.grey3,
                                              filled: true,
                                              contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h20, horizontal: AppWidth.w10),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                                borderRadius: BorderRadius.circular(AppRadius.r10),
                                              ),
                                              labelText: 'Rate',
                                              labelStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                              hintText: 'Rate',
                                              hintStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                              floatingLabelBehavior: FloatingLabelBehavior.always),
                                        ),
                                      ),
                                      Container(
                                        width: size.width * .3,
                                        margin: EdgeInsets.only(bottom: AppHeight.h4),
                                        child: TextFormField(
                                          readOnly: true,
                                          style: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                          controller: currentBalanceController,
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
                                              labelStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                              hintText: 'Balance',
                                              hintStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                              floatingLabelBehavior: FloatingLabelBehavior.always),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: size.width * .3,
                                    margin: EdgeInsets.only(bottom: AppHeight.h10),
                                    child: TextFormField(
                                      style: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                      keyboardType: TextInputType.number,
                                      controller: codeController,
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h20, horizontal: AppWidth.w10),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                            borderRadius: BorderRadius.circular(AppRadius.r10),
                                          ),
                                          labelText: 'Code',
                                          labelStyle: getMediumStyle(
                                            fontSize: FontSize.s14,
                                            color: ColorManager.black,
                                          ),
                                          hintText: 'Code',
                                          hintStyle: getMediumStyle(
                                            fontSize: FontSize.s14,
                                            color: ColorManager.black,
                                          ),
                                          floatingLabelBehavior: FloatingLabelBehavior.always),
                                    ),
                                  ),
                                  Container(
                                    width: size.width * .25,
                                    margin: EdgeInsets.only(bottom: AppHeight.h10),
                                    child: TextFormField(
                                      style: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                      controller: reOrderController,
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h20, horizontal: AppWidth.w10),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                            borderRadius: BorderRadius.circular(AppRadius.r10),
                                          ),
                                          labelText: 'Reorder',
                                          labelStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                          hintText: 'Reorder',
                                          hintStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                          floatingLabelBehavior: FloatingLabelBehavior.always),
                                    ),
                                  ),
                                  Container(
                                    width: size.width * .3,
                                    margin: EdgeInsets.only(bottom: AppHeight.h10),
                                    child: TextFormField(
                                      style: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                      controller: salesController,
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h20, horizontal: AppWidth.w10),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                            borderRadius: BorderRadius.circular(AppRadius.r10),
                                          ),
                                          labelText: 'Sales Rate',
                                          labelStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                          hintText: 'Sales Rate',
                                          hintStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
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
                                          _addStock(readAddRemoveStockProvider, watchTabletSetupProvider);
                                        },
                                        child: widget.stockModel == null
                                            ? Text(
                                                "Save Item",
                                                style: getBoldStyle(
                                                  fontSize: FontSize.s15,
                                                  color: ColorManager.white,
                                                ),
                                              )
                                            : Text(
                                                "Update Item",
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
                ));
      }),
    );
  }

  _addStock(AddRemoveStockProvider addStockProvider, TabletSetupServiceProvider watchTabletSetupProvider) async {
    if (formKeyState.currentState!.validate()) {
      StockModel stockModel = StockModel(
        stItemGroupName: groupName.toString(),
        stDes: itemNameController.text,
        stItemGroupId: groupId!,
        stBrandId: brandId!,
        stCode: (codeController.text.isEmpty) ? '' : codeController.text,
        stInActive: isChecked,
        stOBal: (qtyController.text.isEmpty) ? 0.0 : double.parse(qtyController.text),
        stORate: (openingRateController.text.isEmpty) ? 0.0 : double.parse(openingRateController.text),
        stOVal: (openingBalanceController.text.isEmpty) ? 0.0 : double.parse(openingBalanceController.text.toString()),
        stCurBal: (currentBalanceController.text.isEmpty) ? 0.0 : double.parse(currentBalanceController.text),
        stCurRate: (currentRateController.text.isEmpty) ? 0.0 : double.parse(currentRateController.text),
        stReOrder: (reOrderController.text.isEmpty) ? 0.0 : double.parse(reOrderController.text),
        stId: stkId ?? 0,
        stODate: DateTime.parse(DateTime.now().toIso8601String().split("T")[0]).toIso8601String(),
        stSalesRate: (salesController.text.isEmpty) ? 0.0 : double.parse(salesController.text),
        stImage: null,
      );
      var stock = await addStockProvider.addStock(stockModel);
      log(stock.toString(), name: 'stock update');

      if (stock != null) {
        if (stock["success"] == true) {
          watchTabletSetupProvider.groupName = null;
          watchTabletSetupProvider.brandList = null;

          Fluttertoast.showToast(
            msg: widget.stockModel == null ? 'Stock Added' : 'Stock Updated',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: ColorManager.green,
          );
          if (!mounted) return;
          refresh();
          Navigator.pop(context);
        }
      } else {
        Fluttertoast.cancel();
        return Fluttertoast.showToast(
          msg: "Something Went Wrong",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: ColorManager.error,
        );
      }
    }
  }

  void getReportPopBrand(BuildContext context, Size size, TextEditingController brandController, BrandProvider brandProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: ColorManager.white,
          insetPadding: const EdgeInsets.all(10),
          child: SizedBox(
            width: size.width,
            height: size.height * .35,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(AppRadius.r6), topRight: Radius.circular(AppRadius.r6)),
                    color: ColorManager.cadiumBlue,
                  ),
                  width: size.width,
                  height: size.height * 0.06,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          left: AppHeight.h8,
                        ),
                        child: Text(
                          'Add Brand'.toUpperCase(),
                          style: getBoldStyle(
                            color: ColorManager.white,
                            fontSize: FontSize.s14,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(
                          AppHeight.h10,
                        ),
                        child: CircleAvatar(
                          radius: AppRadius.r14,
                          backgroundColor: ColorManager.white,
                          child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(Icons.remove)),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // padding: EdgeInsets.only(top: AppHeight.h10),
                  padding: EdgeInsets.only(left: AppWidth.w20, right: AppWidth.w20, top: AppHeight.h10),
                  height: size.height * 0.2,
                  width: size.width,
                  child: Form(
                    key: formKeyBrand,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Brand Name',
                          style: getBoldStyle(fontSize: FontSize.s16, color: ColorManager.black),
                        ),
                        SizedBox(
                          height: AppHeight.h10,
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: AppHeight.h10),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.characters,
                            controller: brandController,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h20, horizontal: AppWidth.w10),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                borderRadius: BorderRadius.circular(AppRadius.r10),
                              ),
                              labelText: 'Name',
                              labelStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '*Required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(AppHeight.h10),
                    backgroundColor: ColorManager.green,
                  ),
                  onPressed: () {
                    onCreate(brandController, brandProvider, 0);
                    brandController.clear();
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Text(
                    'Add',
                    style: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  onCreate(TextEditingController brandController, BrandProvider brandProvider, int? groupId) async {
    if (formKeyBrand.currentState!.validate()) {
      var create = await brandProvider.createBrand(groupId ?? 0, brandController.text);

      if (create != null) {
        if (create["success"] == true) {
          Fluttertoast.showToast(
            msg: 'Brand Added',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: ColorManager.green,
          );
          if (!mounted) return;
          Navigator.pop(context);
          refresh();
        } else {
          Fluttertoast.cancel();
          return Fluttertoast.showToast(
            msg: 'Error occured',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: ColorManager.error,
          );
        }
      }
    }
  }

  void getReportPopGroup(BuildContext context, Size size, TextEditingController groupController, GroupProvider groupProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: ColorManager.white,
          insetPadding: const EdgeInsets.all(10),
          child: SizedBox(
            width: size.width,
            height: size.height * .35,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(AppRadius.r6), topRight: Radius.circular(AppRadius.r6)),
                    color: ColorManager.cadiumBlue,
                  ),
                  width: size.width,
                  height: size.height * 0.06,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          left: AppHeight.h8,
                        ),
                        child: Text(
                          'Add Group'.toUpperCase(),
                          style: getBoldStyle(
                            color: ColorManager.white,
                            fontSize: FontSize.s14,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(
                          AppHeight.h10,
                        ),
                        child: CircleAvatar(
                          radius: AppRadius.r14,
                          backgroundColor: ColorManager.white,
                          child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(Icons.remove)),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // padding: EdgeInsets.only(top: AppHeight.h10),
                  padding: EdgeInsets.only(left: AppWidth.w20, right: AppWidth.w20, top: AppHeight.h10),
                  height: size.height * 0.2,
                  width: size.width,
                  child: Form(
                    key: formKeyGroup,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Group Name',
                          style: getBoldStyle(fontSize: FontSize.s16, color: ColorManager.black),
                        ),
                        SizedBox(
                          height: AppHeight.h10,
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: AppHeight.h10),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.characters,
                            controller: groupController,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h20, horizontal: AppWidth.w10),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                borderRadius: BorderRadius.circular(AppRadius.r10),
                              ),
                              labelText: 'Name',
                              labelStyle: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.black),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '*Required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(AppHeight.h10),
                    backgroundColor: ColorManager.green,
                  ),
                  onPressed: () {
                    onCreateGroup(groupController, groupProvider, 0);
                    groupController.clear();
                  },
                  child: Text(
                    'Add Group',
                    style: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  onCreateGroup(TextEditingController groupController, GroupProvider groupProvider, int? groupId) async {
    if (formKeyGroup.currentState!.validate()) {
      var create = await groupProvider.createGroup(groupId ?? 0, groupController.text);

      if (create != null) {
        if (create["success"] == true) {
          Fluttertoast.showToast(
            msg: 'Group Added',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: ColorManager.green,
          );
          if (!mounted) return;
          Navigator.pop(context);
          refresh();
        } else {
          Fluttertoast.cancel();
          return Fluttertoast.showToast(
            msg: 'Error occured',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: ColorManager.error,
          );
        }
      }
    }
  }

  Future<void> refresh() async {
    await context.read<GetStockListProvider>().getStockList(brandId);
    if (!mounted) return;
    await context.read<TabletSetupServiceProvider>().getTabletSetup();
  }
}
