import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:number_to_words_english/number_to_words_english.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/agent/screens/add_agent_screen.dart';
import 'package:webshop/view/homepage/home_screen.dart';
import 'package:webshop/view/sales/screens/add_sales.dart';
import 'package:webshop/view/sales/screens/credit_payment_page.dart';
import 'package:webshop/view/sales/services/update_sales_provider.dart';
import 'package:webshop/view/sales/widgets/sales_list.dart';
import 'package:webshop/view/sales/widgets/table_header_widget.dart';
import 'package:webshop/view/sales_return/models/get_sales_model.dart';
import 'package:webshop/view/sales_return/provider/get_salesbyid_provider.dart';
import 'model/sales_add_model.dart';
import 'services/sales_service.dart';

class SalesEntries extends StatefulWidget {
  const SalesEntries({super.key});

  @override
  State<SalesEntries> createState() => _SalesEntriesState();
}

class _SalesEntriesState extends State<SalesEntries> {
  TabletSetupServiceProvider? watchTabletSetupServiceProvider;
  SalesServiceProvider? readSalesServiceProvider;
  GetSalesByIdProvider? readGetSalesByIdProvider;
  FocusNode supplierFocusNode = FocusNode();
  bool showBottomSheet = true;

  @override
  void initState() {
    readSalesServiceProvider = context.read<SalesServiceProvider>();
    readSalesServiceProvider!.scrollController.addListener(() {
      setState(() {
        const SalesList();
      });
    });
    super.initState();
  }

  Future<void> refresh() async {
    await context.read<TabletSetupServiceProvider>().getTabletSetup();
  }

  final _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    watchTabletSetupServiceProvider = context.watch<TabletSetupServiceProvider>();
    readGetSalesByIdProvider = context.read<GetSalesByIdProvider>();

    SalesServiceProvider watchSalesServiceProvider = context.watch<SalesServiceProvider>();
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        WillPopScope(
          onWillPop: () async {
            showBottomSheet = true;
            return true;
          },
          child: Scaffold(
            key: scaffoldState,
            backgroundColor: Theme.of(context).colorScheme.background,
            floatingActionButton: Padding(
              padding: EdgeInsets.only(bottom: size.height * .08),
              child: SizedBox(
                height: size.height * .055,
                width: size.height * .055,
                child: FloatingActionButton(
                  onPressed: () {
                    watchTabletSetupServiceProvider!.brandList = null;
                    readSalesServiceProvider!.isAdd = true;
                    readSalesServiceProvider!.salesAmount = 0.0;
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (readSalesServiceProvider!.discountPercentController.text.isNotEmpty) {
                      readSalesServiceProvider!.discountPercentController.text = '0';
                      FocusScope.of(context).requestFocus(FocusNode());
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => AddSales(
                            discountController: readSalesServiceProvider!.discountController,
                          ),
                          fullscreenDialog: true,
                        ));
                  },
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.add),
                ),
              ),
            ),
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
              centerTitle: false,
              elevation: 1,
              backgroundColor: ColorManager.white,
              title: Text(
                'Sales Entries',
                style: getMediumStyle(fontSize: FontSize.s18, color: ColorManager.white),
              ),
              leading: IconButton(
                onPressed: () {
                  readSalesServiceProvider!.salesSubTotal = 0.0;
                  readSalesServiceProvider!.salesTotalAmount = 0.0;
                  readSalesServiceProvider!.businessTotalAmount = 0.0;
                  readSalesServiceProvider!.custommerNameController.clear();
                  readSalesServiceProvider!.agtId = null;
                  readSalesServiceProvider!.discountController.clear();
                  readSalesServiceProvider!.discountPercentController.clear();
                  readSalesServiceProvider!.billToController.clear();
                  readSalesServiceProvider!.addressController.clear();
                  readSalesServiceProvider!.panNumberController.clear();
                  readSalesServiceProvider!.phoneNumberController.clear();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                      (route) => false);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: ColorManager.white,
                ),
              ),
            ),
            body: NotificationListener<UserScrollNotification>(
              onNotification: (notification) {
                final ScrollDirection direction = notification.direction;

                if (direction == ScrollDirection.reverse) {
                  readSalesServiceProvider!.setShowBottomFalse();
                } else if (direction == ScrollDirection.forward) {
                  readSalesServiceProvider!.setShowBottomTrue();
                }

                return true;
              },
              child: Consumer<ConnectivityProvider>(
                builder: (context, connectivity, child) {
                  return (connectivity.isOnline == false)
                      ? const NoInternet()
                      : GestureDetector(
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            showBottomSheet = true;
                          },
                          child: SingleChildScrollView(
                            child: GestureDetector(
                              onTap: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                                showBottomSheet = true;
                              },
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: AppWidth.w4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(AppRadius.r10),
                                        bottomRight: Radius.circular(AppRadius.r10),
                                      ),
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
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(vertical: AppHeight.h4),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      height: size.height * 0.06,
                                                      width: size.width * .75,
                                                      child: TypeAheadFormField<AgentList>(
                                                        textFieldConfiguration: TextFieldConfiguration(
                                                          focusNode: supplierFocusNode,
                                                          onChanged: (_) {
                                                            if (supplierFocusNode.hasFocus) {
                                                              showBottomSheet = false;
                                                            }
                                                          },
                                                          onTap: () {
                                                            showBottomSheet = false;
                                                          },
                                                          onSubmitted: (_) {
                                                            showBottomSheet = true;
                                                          },
                                                          controller: readSalesServiceProvider!.custommerNameController,
                                                          decoration: InputDecoration(
                                                            suffixIcon: readSalesServiceProvider!.custommerNameController.text == ""
                                                                ? Icon(
                                                                    Icons.arrow_drop_down,
                                                                    color: ColorManager.blueBright,
                                                                  )
                                                                : IconButton(
                                                                    onPressed: () {
                                                                      readSalesServiceProvider!.custommerNameController.clear();
                                                                      FocusScope.of(context).requestFocus(FocusNode());
                                                                      readSalesServiceProvider!.agtId = null;
                                                                      readSalesServiceProvider!.billToController.clear();
                                                                      readSalesServiceProvider!.addressController.clear();
                                                                      readSalesServiceProvider!.panNumberController.clear();
                                                                      readSalesServiceProvider!.phoneNumberController.clear();
                                                                    },
                                                                    icon: const Icon(Icons.close)),
                                                            prefixIcon: Icon(
                                                              Icons.person,
                                                              color: ColorManager.blueBright,
                                                            ),
                                                            border: OutlineInputBorder(
                                                              borderSide: BorderSide(width: 2, color: ColorManager.blackOpacity38),
                                                              borderRadius: BorderRadius.circular(AppRadius.r5),
                                                            ),
                                                            fillColor: ColorManager.white,
                                                            filled: true,
                                                            hintText: 'Customer',
                                                            hintStyle: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.grey),
                                                            labelText: 'Customer',
                                                            labelStyle: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.grey),
                                                            floatingLabelBehavior: FloatingLabelBehavior.always,
                                                            focusedBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(color: ColorManager.blueBright),
                                                              borderRadius: BorderRadius.circular(AppRadius.r10),
                                                            ),
                                                            errorBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(color: ColorManager.red),
                                                              borderRadius: BorderRadius.circular(AppRadius.r10),
                                                            ),
                                                          ),
                                                        ),
                                                        onSuggestionSelected: (AgentList agent) {
                                                          showBottomSheet = true;
                                                          readSalesServiceProvider!.custommerNameController.text = agent.agtCompany.toString();
                                                          readSalesServiceProvider!.agtId = agent.agtId;

                                                          if (readSalesServiceProvider!.custommerNameController.text.isNotEmpty) {
                                                            readSalesServiceProvider!.billToController.text = agent.agtCompany.toString();
                                                            readSalesServiceProvider!.addressController.text = agent.agtAdress.toString();
                                                            readSalesServiceProvider!.panNumberController.text =
                                                                agent.agtVatNo == null ? '' : agent.agtVatNo.toString();
                                                            readSalesServiceProvider!.phoneNumberController.text = agent.agtMobile.toString();
                                                          }
                                                          if (agent.agtDiscount != null) {
                                                            readSalesServiceProvider!.discountPercentController.text = agent.agtDiscount.toString();
                                                          }
                                                        },
                                                        itemBuilder: (context, AgentList agent) => ListTile(
                                                          title: Text(
                                                            agent.agtCompany.toString(),
                                                            style: getRegularStyle(
                                                              fontSize: FontSize.s12,
                                                              color: ColorManager.black,
                                                            ),
                                                          ),
                                                        ),
                                                        suggestionsCallback: getAgentSuggestion,
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        addCustomerFromSales = true;
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => const AddAgentScreen(),
                                                          ),
                                                        );
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
                                                          color: ColorManager.white,
                                                          borderRadius: BorderRadius.circular(AppRadius.r10),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              height: size.height * .035,
                                                              width: size.width * .07,
                                                              decoration: const BoxDecoration(
                                                                image: DecorationImage(
                                                                  image: AssetImage("assets/images/addCustomer.png"),
                                                                  fit: BoxFit.fill,
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              'Add Customer',
                                                              style: getMediumStyle(fontSize: FontSize.s12, color: ColorManager.black),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          TextFormField(
                                            keyboardType: TextInputType.name,
                                            textCapitalization: TextCapitalization.sentences,
                                            controller: readSalesServiceProvider!.billToController,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h4, horizontal: AppWidth.w10),
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(width: 1.5, color: Colors.blue),
                                                borderRadius: BorderRadius.circular(AppRadius.r5),
                                              ),
                                              labelText: 'Bill To.',
                                              hintText: 'Bill To',
                                              labelStyle: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                              hintStyle: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(bottom: AppHeight.h4, top: AppHeight.h4),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: size.width * .49,
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
                                                    controller: readSalesServiceProvider!.phoneNumberController,
                                                    keyboardType: TextInputType.number,
                                                    decoration: InputDecoration(
                                                      contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h4, horizontal: AppWidth.w10),
                                                      border: OutlineInputBorder(
                                                        borderSide: const BorderSide(width: 1.5, color: Colors.blue),
                                                        borderRadius: BorderRadius.circular(AppRadius.r5),
                                                      ),
                                                      labelText: 'Mobile',
                                                      hintText: 'Mobile',
                                                      labelStyle: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                                      hintStyle: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: size.width * .45,
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
                                                    controller: readSalesServiceProvider!.panNumberController,
                                                    keyboardType: TextInputType.number,
                                                    decoration: InputDecoration(
                                                      contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h4, horizontal: AppWidth.w10),
                                                      border: OutlineInputBorder(
                                                        borderSide: const BorderSide(width: 1.5, color: Colors.blue),
                                                        borderRadius: BorderRadius.circular(AppRadius.r5),
                                                      ),
                                                      labelText: 'Pan No',
                                                      hintText: 'Pan No',
                                                      labelStyle: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                                      hintStyle: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          TextFormField(
                                            textCapitalization: TextCapitalization.sentences,
                                            controller: readSalesServiceProvider!.addressController,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h4, horizontal: AppWidth.w10),
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(width: 1.5, color: Colors.blue),
                                                borderRadius: BorderRadius.circular(AppRadius.r5),
                                              ),
                                              labelText: 'Address',
                                              hintText: 'Address',
                                              labelStyle: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                              hintStyle: getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                            ),
                                          ),
                                          SizedBox(
                                            height: AppHeight.h6,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Divider(
                                  //   color: ColorManager.grey2,
                                  //   thickness: AppHeight.h1,
                                  // ),
                                  // (watchSalesServiceProvider.salesItemList.isEmpty)
                                  //     ? const SizedBox()
                                  //     : Align(
                                  //         alignment: Alignment.centerLeft,
                                  //         child: Text(
                                  //           'Sales:',
                                  //           style: getBoldStyle(
                                  //             fontSize: FontSize.s16,
                                  //             color: ColorManager.black,
                                  //           ),
                                  //         ),
                                  //       ),
                                  (readSalesServiceProvider!.salesItemList.isNotEmpty)
                                      ? GestureDetector(
                                          onTap: () {
                                            FocusScope.of(context).requestFocus(FocusNode());
                                            showBottomSheet = true;
                                          },
                                          child: Column(
                                            children: [
                                              const TableSalesHeaderWidget(),
                                              Container(
                                                color: ColorManager.white,
                                                width: size.width,
                                                height: size.height,
                                                child: ListView(
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  children: [
                                                    DataTable(
                                                      dataRowColor: MaterialStateProperty.resolveWith((states) => ColorManager.white),
                                                      columnSpacing: 0.0,
                                                      headingRowHeight: 0.0,
                                                      dataRowHeight: 55.0,
                                                      horizontalMargin: 0,
                                                      columns: _createColumn(),
                                                      rows: watchSalesServiceProvider.salesItemList
                                                          .map(
                                                            (sales) => _purchaseReportRow(sales, size),
                                                          )
                                                          .toList(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            FocusScope.of(context).requestFocus(FocusNode());
                                            showBottomSheet = true;
                                          },
                                          child: SizedBox(
                                            height: size.height * 0.5,
                                            width: size.width,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        );
                },
              ),
            ),
            bottomSheet: Consumer<ConnectivityProvider>(builder: (context, connectivity, child) {
              return (connectivity.isOnline == false)
                  ? SizedBox(width: size.width, height: size.height * .01)
                  : readSalesServiceProvider!.showBottom
                      ? showBottomSheet
                          ? GestureDetector(
                              onTap: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(AppRadius.r10), topRight: Radius.circular(AppRadius.r10)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: ColorManager.blackOpacity38,
                                      blurRadius: 25.0, // soften the shadow
                                      spreadRadius: 5.0, //extend the shadow
                                      offset: const Offset(
                                        15.0, // Move to right 10  horizontally
                                        15.0, // Move to bottom 10 Vertically
                                      ),
                                    )
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: size.width * .7,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: AppHeight.h10, left: AppWidth.w10, right: AppWidth.w10),
                                        child: SizedBox(
                                          width: size.width,
                                          height: size.height * .15,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Subtotal  ',
                                                        style: getRegularStyle(
                                                          fontSize: FontSize.s15,
                                                          color: ColorManager.black,
                                                        ),
                                                      ),
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          SizedBox(
                                                            width: size.width * .25,
                                                            height: size.height * .035,
                                                            child: TextField(
                                                              style: getMediumStyle(
                                                                fontSize: FontSize.s15,
                                                                color: ColorManager.black,
                                                              ),
                                                              onTap: () {
                                                                if (readSalesServiceProvider!.discountPercentController.text == '0.00' ||
                                                                    readSalesServiceProvider!.discountPercentController.text.isEmpty) {
                                                                  readSalesServiceProvider!.discountPercentController.clear();
                                                                }
                                                              },
                                                              textAlign: TextAlign.end,
                                                              keyboardType: TextInputType.number,
                                                              controller: readSalesServiceProvider!.discountPercentController,
                                                              onChanged: (value) {
                                                                readSalesServiceProvider!.discountController.text =
                                                                    ((double.parse(value.isEmpty ? 0.toString() : value.toString())) /
                                                                            100 *
                                                                            watchSalesServiceProvider.salesSubTotal)
                                                                        .toStringAsFixed(2);
                                                                readSalesServiceProvider!.calculateSalesSubTotal(
                                                                    discount: double.parse((readSalesServiceProvider!.discountController.text.isEmpty)
                                                                        ? '0'
                                                                        : readSalesServiceProvider!.discountController.text));
                                                              },
                                                              decoration: InputDecoration(
                                                                hintText: 'Discount (%)',
                                                                contentPadding: EdgeInsets.zero,
                                                                border: const OutlineInputBorder(
                                                                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                                                                ),
                                                                enabledBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(color: ColorManager.blackOpacity38, width: 1.0),
                                                                  borderRadius: BorderRadius.all(Radius.circular(AppRadius.r5)),
                                                                ),
                                                                focusedBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(color: ColorManager.blackOpacity38, width: 2.0),
                                                                  borderRadius: BorderRadius.all(Radius.circular(AppRadius.r5)),
                                                                ),
                                                              ),
                                                            ),
                                                          ),

                                                          // Text(
                                                          //   'Discount (%)',
                                                          //   style: getRegularStyle(
                                                          //     fontSize: FontSize.s14,
                                                          //     color: ColorManager.black,
                                                          //   ),
                                                          // ),
                                                        ],
                                                      ),
                                                      Text(
                                                        'Total  ',
                                                        style: getRegularStyle(
                                                          fontSize: FontSize.s15,
                                                          color: ColorManager.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        watchSalesServiceProvider.salesSubTotal.toStringAsFixed(2),
                                                        style: getRegularStyle(
                                                          fontSize: FontSize.s15,
                                                          color: ColorManager.black,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: size.width * .2,
                                                        height: size.height * .035,
                                                        child: TextField(
                                                          style: getMediumStyle(
                                                            fontSize: FontSize.s15,
                                                            color: ColorManager.black,
                                                          ),
                                                          textAlign: TextAlign.end,
                                                          keyboardType: TextInputType.number,
                                                          controller: readSalesServiceProvider!.discountController,
                                                          onChanged: (value) {
                                                            if (watchSalesServiceProvider.salesSubTotal > 0) {
                                                              readSalesServiceProvider!.calculateSalesSubTotal(
                                                                  discount: double.parse((readSalesServiceProvider!.discountController.text.isEmpty)
                                                                      ? '0'
                                                                      : readSalesServiceProvider!.discountController.text));

                                                              readSalesServiceProvider!.discountPercentController.text = ((double.parse(
                                                                              readSalesServiceProvider!.discountController.text.isEmpty
                                                                                  ? 0.toString()
                                                                                  : readSalesServiceProvider!.discountController.text) *
                                                                          100.0) /
                                                                      watchSalesServiceProvider.salesSubTotal)
                                                                  .toStringAsFixed(2);
                                                            }
                                                          },
                                                          decoration: InputDecoration(
                                                            hintText: 'Discount',
                                                            contentPadding: EdgeInsets.zero,
                                                            border: const OutlineInputBorder(
                                                              borderRadius: BorderRadius.all(Radius.circular(32.0)),
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(color: ColorManager.blackOpacity38, width: 1.0),
                                                              borderRadius: BorderRadius.all(Radius.circular(AppRadius.r5)),
                                                            ),
                                                            focusedBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(color: ColorManager.blackOpacity38, width: 2.0),
                                                              borderRadius: BorderRadius.all(Radius.circular(AppRadius.r5)),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        watchSalesServiceProvider.salesTotalAmount.toStringAsFixed(2),
                                                        style: getBoldStyle(
                                                          fontSize: FontSize.s15,
                                                          color: ColorManager.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: size.width,
                                                height: size.height * 0.06,
                                                child: TextFormField(
                                                  controller: readSalesServiceProvider!.remarkController,
                                                  textInputAction: TextInputAction.done,
                                                  decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.symmetric(vertical: AppHeight.h10, horizontal: AppWidth.w10),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: ColorManager.blackOpacity54, width: AppWidth.w1),
                                                      borderRadius: BorderRadius.circular(AppRadius.r10),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderSide: BorderSide(color: ColorManager.blueBright, width: AppWidth.w2),
                                                      borderRadius: BorderRadius.circular(AppRadius.r10),
                                                    ),
                                                    labelText: 'Remark',
                                                    labelStyle: getMediumStyle(fontSize: FontSize.s12, color: ColorManager.blackOpacity38),
                                                    hintText: 'Remark',
                                                    hintStyle: getMediumStyle(fontSize: FontSize.s12, color: ColorManager.blackOpacity38),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width * .3,
                                      height: size.height * .14,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              readSalesServiceProvider!.setLoadingTrue();
                                              readSalesServiceProvider!.business.clear();

                                              if (_formKey.currentState!.validate()) {
                                                if (readSalesServiceProvider!.salesItemList.isNotEmpty) {
                                                  Sales salesDetails = Sales(
                                                    traId: 0,
                                                    traDate: readSalesServiceProvider!.traDate ??
                                                        DateTime.parse(
                                                                '${DateTime.now().toIso8601String().split("T")[0]}T${NepaliDateTime.now().toIso8601String().split("T")[1]}')
                                                            .toIso8601String(),
                                                    traType: 1,
                                                    traAgtId: readSalesServiceProvider!.agtId ?? 0,
                                                    traBillNo: readSalesServiceProvider!.billToController.text,
                                                    traInsertedBy: int.parse(sharedPref!.getString('staffId').toString()),
                                                    traDiscPercent: double.parse((readSalesServiceProvider!.discountPercentController.text == '')
                                                        ? 0.toString()
                                                        : readSalesServiceProvider!.discountPercentController.text),
                                                    traDiscAmount: double.parse(readSalesServiceProvider!.discountController.text.isEmpty
                                                        ? 0.0.toString()
                                                        : readSalesServiceProvider!.discountController.text),
                                                    traSubAmount: readSalesServiceProvider!.salesSubTotal,
                                                    traTotalAmount: readSalesServiceProvider!.salesTotalAmount,
                                                    traRemark: readSalesServiceProvider!.remarkController.text,
                                                    traInActive: false,
                                                    traCustomerName: (readSalesServiceProvider!.billToController.text == '')
                                                        ? 'Trade Sales'
                                                        : readSalesServiceProvider!.billToController.text,
                                                    traCustomerPanNo: readSalesServiceProvider!.panNumberController.text,
                                                    traCustomerAddress: readSalesServiceProvider!.addressController.text,
                                                    traCustomerMobileNo: readSalesServiceProvider!.phoneNumberController.text,
                                                    traInsertedStaff: sharedPref!.getString('userType').toString(),
                                                    billPModeDes: '1',
                                                  );
                                                  Businesslist businesslist = Businesslist(
                                                    billId: 0,
                                                    billPMode: 1,
                                                    billDescription: 'Cash',
                                                    billDate: DateTime.parse(DateTime.now().toIso8601String().split("T")[0]).toIso8601String(),
                                                    billTotalAmt: readSalesServiceProvider!.salesTotalAmount,
                                                    billCodeId: 1,
                                                    billAgtId: readSalesServiceProvider!.agtId,
                                                    billAddedBy: int.parse(sharedPref!.getString('staffId').toString()),
                                                  );
                                                  //For Only Cash Purpose

                                                  readSalesServiceProvider!.business.add(businesslist);

                                                  var response = await context.read<UpdateSalesProvider>().updateSales(
                                                      salesDetails, readSalesServiceProvider!.salesItemList, readSalesServiceProvider!.business);

                                                  if (response['responseType'] == 6 || response['data'] != null) {
                                                    if (printIp != null || printIp == '') {
                                                      const PaperSize paper = PaperSize.mm80;
                                                      final profile = await CapabilityProfile.load();
                                                      final printer = NetworkPrinter(paper, profile);
                                                      var data = await readGetSalesByIdProvider!.getSalesById(response['data']);

                                                      PosPrintResult res = await printer.connect(printIp!, port: 9100);
                                                      // var printResId = response['data'];

                                                      if (res == PosPrintResult.success) {
                                                        if (data.data != null) {
                                                          readSalesServiceProvider!
                                                              .setPaymentModes(readGetSalesByIdProvider!.getSalesByIdModel.data!.businessDtoList!);
                                                          billPrint(printer, watchTabletSetupServiceProvider!, readSalesServiceProvider!,
                                                              readGetSalesByIdProvider!.getSalesByIdModel);
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
                                                    // printToken(printIp, response, watchTabletSetupServiceProvider!, watchSalesServiceProvider, readSalesServiceProvider!.billToController.text);
                                                    readSalesServiceProvider!.salesItemList.clear();
                                                    readSalesServiceProvider!.duplicateSalesItemList.clear();
                                                    readSalesServiceProvider!.tempSalesItemList.clear();
                                                    readSalesServiceProvider!.custommerNameController.clear();
                                                    readSalesServiceProvider!.agtId = null;
                                                    readSalesServiceProvider!.billToController.clear();
                                                    readSalesServiceProvider!.addressController.clear();
                                                    readSalesServiceProvider!.panNumberController.clear();
                                                    readSalesServiceProvider!.discountController.clear();
                                                    readSalesServiceProvider!.discountPercentController.clear();
                                                    readSalesServiceProvider!.phoneNumberController.clear();
                                                    readSalesServiceProvider!.salesSubTotal = 0.0;
                                                    readSalesServiceProvider!.salesTotalAmount = 0.0;
                                                    readSalesServiceProvider!.setCustomerName(null);
                                                    readSalesServiceProvider!.setCustomerId(null);
                                                    readSalesServiceProvider!.setPMode(null);
                                                    readSalesServiceProvider!.business.clear();
                                                    readSalesServiceProvider!.businessTotalAmount = 0.0;
                                                    Fluttertoast.cancel();
                                                    Fluttertoast.showToast(
                                                      msg: 'Sales Successful',
                                                      toastLength: Toast.LENGTH_LONG,
                                                      gravity: ToastGravity.BOTTOM,
                                                      backgroundColor: ColorManager.green,
                                                    );

                                                    if (!mounted) return;
                                                    Navigator.pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => const SalesEntries(),
                                                        ),
                                                        (route) => false);
                                                    if (printIp == null) {
                                                      showDialog<String>(
                                                        context: context,
                                                        builder: (BuildContext context) => AlertDialog(
                                                          title: const Text('Printer Alert'),
                                                          content: const Text(
                                                              'Printer\'s ip is not set, to add your printer ip go to Drawer->Add printer.'),
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
                                                    msg: 'Item is Empty',
                                                    toastLength: Toast.LENGTH_LONG,
                                                    gravity: ToastGravity.BOTTOM,
                                                    backgroundColor: ColorManager.error,
                                                  );
                                                }
                                              } else {
                                                Fluttertoast.cancel();
                                                Fluttertoast.showToast(
                                                  msg: 'Provide Valid Information',
                                                  toastLength: Toast.LENGTH_LONG,
                                                  gravity: ToastGravity.BOTTOM,
                                                  backgroundColor: ColorManager.error,
                                                );
                                              }
                                              readSalesServiceProvider!.setLoadingFalse();
                                            },
                                            style: ButtonStyle(
                                              backgroundColor: readSalesServiceProvider!.salesItemList.isEmpty
                                                  ? MaterialStateProperty.all(Colors.blue.shade200)
                                                  : MaterialStateProperty.all(ColorManager.blueBright),
                                              padding:
                                                  MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: AppWidth.w10, vertical: AppHeight.h1)),
                                              textStyle: MaterialStateProperty.all(getMediumStyle(fontSize: FontSize.s14, color: ColorManager.white)),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: size.width * .05),
                                              child: Text(
                                                'Cash  ',
                                                style: getMediumStyle(fontSize: FontSize.s15, color: ColorManager.white),
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              if (_formKey.currentState!.validate()) {
                                                if (readSalesServiceProvider!.salesItemList.isNotEmpty) {
                                                  Sales salesDetails = Sales(
                                                    traId: 0,
                                                    traDate: DateTime.parse(
                                                            '${DateTime.now().toIso8601String().split("T")[0]}T${NepaliDateTime.now().toIso8601String().split("T")[1]}')
                                                        .toIso8601String(),
                                                    traType: 1,
                                                    traAgtId: readSalesServiceProvider!.agtId ?? 0,
                                                    traBillNo: readSalesServiceProvider!.billToController.text,
                                                    traInsertedBy: int.parse(sharedPref!.getString('staffId').toString()),
                                                    traDiscPercent: double.parse((readSalesServiceProvider!.discountPercentController.text == '')
                                                        ? 0.toString()
                                                        : readSalesServiceProvider!.discountPercentController.text),
                                                    traDiscAmount: double.parse(readSalesServiceProvider!.discountController.text.isEmpty
                                                        ? 0.0.toString()
                                                        : readSalesServiceProvider!.discountController.text),
                                                    traSubAmount: readSalesServiceProvider!.salesSubTotal,
                                                    traTotalAmount: readSalesServiceProvider!.salesTotalAmount,
                                                    traRemark: readSalesServiceProvider!.remarkController.text,
                                                    traInActive: false,
                                                    traCustomerName: (readSalesServiceProvider!.custommerNameController.text == '')
                                                        ? 'Trade Sales'
                                                        : readSalesServiceProvider!.custommerNameController.text,
                                                    traCustomerPanNo: readSalesServiceProvider!.panNumberController.text,
                                                    traCustomerAddress: readSalesServiceProvider!.addressController.text,
                                                    traCustomerMobileNo: readSalesServiceProvider!.phoneNumberController.text,
                                                  );
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => CreditPayment(
                                                                scaffoldKey: scaffoldState,
                                                                agentId: readSalesServiceProvider!.agtId,
                                                                agentName: (readSalesServiceProvider!.custommerNameController.text == '' ||
                                                                        readSalesServiceProvider!.custommerNameController.text.isEmpty)
                                                                    ? null
                                                                    : readSalesServiceProvider!.custommerNameController.text,
                                                                salesDetails: salesDetails,
                                                              ),
                                                          fullscreenDialog: true));
                                                } else {
                                                  Fluttertoast.cancel();
                                                  Fluttertoast.showToast(
                                                    msg: 'Item is Empty',
                                                    toastLength: Toast.LENGTH_LONG,
                                                    gravity: ToastGravity.BOTTOM,
                                                    backgroundColor: ColorManager.error,
                                                  );
                                                }
                                              } else {
                                                Fluttertoast.cancel();
                                                Fluttertoast.showToast(
                                                  msg: 'Provide Valid Information',
                                                  toastLength: Toast.LENGTH_LONG,
                                                  gravity: ToastGravity.BOTTOM,
                                                  backgroundColor: ColorManager.error,
                                                );
                                              }
                                            },
                                            style: ButtonStyle(
                                              backgroundColor: readSalesServiceProvider!.salesItemList.isEmpty
                                                  ? MaterialStateProperty.all(Colors.red.shade200)
                                                  : MaterialStateProperty.all(ColorManager.redAccent),
                                              padding:
                                                  MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: AppWidth.w10, vertical: AppHeight.h1)),
                                              textStyle: MaterialStateProperty.all(getMediumStyle(fontSize: FontSize.s14, color: ColorManager.white)),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: size.width * .05),
                                              child: Text(
                                                'Credit',
                                                style: getMediumStyle(fontSize: FontSize.s15, color: ColorManager.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : SizedBox(width: size.width, height: size.height * .01)
                      : SizedBox(width: size.width, height: size.height * .01);
            }),
          ),
        ),
        if (readSalesServiceProvider!.loading)
          Container(
            alignment: Alignment.center,
            color: Colors.white70,
            child: const SpinKitCubeGrid(
              color: Colors.indigoAccent,
              size: 70,
            ),
          )
      ],
    );
  }

  _createColumn() {
    return <DataColumn>[
      DataColumn(label: Container()),
      DataColumn(label: Container()),
      DataColumn(label: Container()),
      DataColumn(label: Container()),
    ];
  }

  billPrint(NetworkPrinter printer, TabletSetupServiceProvider tabletSetupServiceProvider, SalesServiceProvider saleServiceProvider,
      GetSalesByIdModel getSalesByIdModel) {
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
      "Time        : ${getSalesByIdModel.data!.traDate.toString().split('T')[1].split(':')[0]}:${getSalesByIdModel.data!.traDate.toString().split('T')[1].split(':')[1]} ",
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
        text:
            double.parse(saleServiceProvider.discountController.text.isEmpty ? '0' : saleServiceProvider.discountController.text).toStringAsFixed(2),
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
      "${tabletSetupServiceProvider.tabletSetupModel.data!.settingList!.where((element) => element.settingName == 'POSTEXT').first.settingValue}",
      styles: PosStyles(align: PosAlign.center, fontType: fontType),
    );

    printer.text("        ");
    printer.text("        ");
    printer.text("        ");
    printer.cut();
    printer.beep(n: 2);
  }

  DataRow _purchaseReportRow(SalesItemModel salesItem, Size size) {
    return DataRow(
      cells: [
        DataCell(
          Container(
            padding: EdgeInsets.all(AppHeight.h10),
            width: size.width * .44,
            child: Text(
              salesItem.traDStkName.toString(),
              style: getMediumStyle(
                fontSize: FontSize.s12,
                color: ColorManager.black,
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            width: size.width * .13,
            padding: EdgeInsets.all(AppHeight.h10),
            child: Center(
              child: Text(
                double.parse(salesItem.traDQty.toString().split('.')[1].toString()) > 0
                    ? salesItem.traDQty.toString()
                    : salesItem.traDQty!.toStringAsFixed(0),
                style: getMediumStyle(
                  fontSize: FontSize.s12,
                  color: ColorManager.black,
                ),
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            width: size.width * .19,
            padding: EdgeInsets.all(AppHeight.h10),
            child: Center(
              child: Text(
                salesItem.traDRate.toString(),
                style: getMediumStyle(
                  fontSize: FontSize.s12,
                  color: ColorManager.black,
                ),
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            width: size.width * .25,
            padding: EdgeInsets.all(AppHeight.h10),
            child: SizedBox(
              width: size.width * .35,
              child: Center(
                child: Text(
                  salesItem.traDAmount.toString(),
                  style: getMediumStyle(
                    fontSize: FontSize.s12,
                    color: ColorManager.black,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<AgentList> getAgentSuggestion(String query) => List.of(watchTabletSetupServiceProvider!.tabletSetupModel.data!.agentList!)
          .where((element) => element.agtCategory == 1)
          .where((AgentList agent) {
        final stockNameLower = agent.agtCompany!.toLowerCase();
        final queryLower = query.toLowerCase();
        return stockNameLower.contains(queryLower);
      }).toList();
}
