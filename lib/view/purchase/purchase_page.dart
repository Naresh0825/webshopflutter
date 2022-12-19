import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/homepage/home_screen.dart';
import 'package:webshop/view/purchase/model/purchase_model.dart';
import 'package:webshop/view/purchase/screens/purchase_details.dart';
import 'package:webshop/view/purchase/services/purchase_by_id_service.dart';
import 'package:webshop/view/purchase/services/purchase_service.dart';
import 'package:webshop/view/purchase/widgets/delete_purchase_widget.dart';
import 'package:webshop/widgets/no_data_dialog.dart';

class PurchasePage extends StatefulWidget {
  final bool isPurchaseReturn;
  const PurchasePage({super.key, required this.isPurchaseReturn});

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  PurchaseServiceProvider? readPurchaseServiceProvider;
  TabletSetupServiceProvider? tabletSetupServiceProvider;

  @override
  void initState() {
    tabletSetupServiceProvider = context.read<TabletSetupServiceProvider>();
    tabletSetupServiceProvider!.supplierList = null;
    readPurchaseServiceProvider = context.read<PurchaseServiceProvider>();
    super.initState();

    getApiCall();
  }

  getApiCall() async {
    await readPurchaseServiceProvider!
        .findPurchase(readPurchaseServiceProvider!.selectedFromDate, readPurchaseServiceProvider!.selectedToDate, readPurchaseServiceProvider!.supplierId, purType: widget.isPurchaseReturn ? 2 : 1);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    TabletSetupServiceProvider watchTabletSetupServiceProvider = context.watch<TabletSetupServiceProvider>();
    PurchaseServiceProvider watchPurchaseServiceProvider = context.watch<PurchaseServiceProvider>();

    readPurchaseServiceProvider!.fromDate = context.read<PurchaseServiceProvider>().selectedFromDate.toString().split(" ")[0].toString();

    readPurchaseServiceProvider!.toDate = context.read<PurchaseServiceProvider>().selectedToDate.toString().split(" ")[0].toString();

    Widget labelStartDate = InkWell(
      onTap: () {
        selectFromDate();
      },
      child: Container(
        height: size.height * 0.05,
        width: size.width * 0.25,
        padding: EdgeInsets.all(AppHeight.h4),
        decoration: BoxDecoration(
          border: Border.all(
            color: ColorManager.white,
          ),
          borderRadius: BorderRadius.circular(AppRadius.r10),
        ),
        child: Center(
          child: Text(
            readPurchaseServiceProvider!.fromDate.toString(),
            style: getBoldStyle(
              fontSize: FontSize.s14,
              color: ColorManager.white,
            ),
          ),
        ),
      ),
    );
    Widget labelEndDate = InkWell(
      onTap: () {
        selectToDate();
      },
      child: Container(
        height: size.height * 0.05,
        width: size.width * 0.25,
        padding: EdgeInsets.all(AppHeight.h4),
        decoration: BoxDecoration(
          border: Border.all(
            color: ColorManager.white,
          ),
          borderRadius: BorderRadius.circular(AppRadius.r10),
        ),
        child: Center(
          child: Text(
            readPurchaseServiceProvider!.toDate.toString(),
            style: getBoldStyle(
              fontSize: FontSize.s14,
              color: ColorManager.white,
            ),
          ),
        ),
      ),
    );

    return WillPopScope(
      onWillPop: () async {
        if (isDialOpen.value) {
          isDialOpen.value = false;
          return false;
        } else {
          return true;
        }
      },
      child: Consumer<ConnectivityProvider>(builder: (context, connectivity, child) {
        return (connectivity.isOnline == false)
            ? const NoInternet()
            : Scaffold(
                body: SafeArea(
                  child: Consumer<PurchaseServiceProvider>(
                    builder: (context, purchase, child) {
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(AppHeight.h2),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  ColorManager.blue,
                                  ColorManager.blueBright,
                                ],
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        getApiCall();
                                        readPurchaseServiceProvider!.setSupId(null);
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
                                    Text(
                                      widget.isPurchaseReturn ? 'Purchase Return' : 'Purchase',
                                      style: getBoldStyle(
                                        fontSize: FontSize.s20,
                                        color: ColorManager.white,
                                      ),
                                    ),
                                    SizedBox(
                                      width: AppWidth.w40,
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        watchPurchaseServiceProvider
                                            .setSelectedFromDate(watchPurchaseServiceProvider.selectedFromDate.subtract(const Duration(days: 1)));
                                        watchPurchaseServiceProvider
                                            .setSelectedToDate(watchPurchaseServiceProvider.selectedToDate.subtract(const Duration(days: 1)));
                                        getApiCall();
                                      },
                                      icon: Icon(
                                        Icons.arrow_circle_left_rounded,
                                        color: ColorManager.white,
                                        size: FontSize.s30,
                                      ),
                                    ),
                                    labelStartDate,
                                    Text(
                                      ' - ',
                                      style: getMediumStyle(fontSize: FontSize.s30, color: ColorManager.white),
                                    ),
                                    labelEndDate,
                                    IconButton(
                                      onPressed: () {
                                        watchPurchaseServiceProvider
                                            .setSelectedFromDate(watchPurchaseServiceProvider.selectedFromDate.add(const Duration(days: 1)));
                                        watchPurchaseServiceProvider
                                            .setSelectedToDate(watchPurchaseServiceProvider.selectedToDate.add(const Duration(days: 1)));
                                        getApiCall();
                                      },
                                      icon: Icon(
                                        Icons.arrow_circle_right_rounded,
                                        color: ColorManager.white,
                                        size: FontSize.s30,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          (purchase.purchaseModel.data == null)
                              ? SizedBox(
                                  height: size.height * .65,
                                  width: size.width,
                                  child: const LoadingBox(),
                                )
                              : (purchase.purchaseModel.data!.isEmpty)
                                  ? SizedBox(
                                      height: size.height * .65,
                                      width: size.width,
                                      child: const NoDataErrorBox(),
                                    )
                                  : SizedBox(
                                      height: size.height * .75,
                                      width: size.width,
                                      child: GroupedListView<Purchase, String>(
                                        useStickyGroupSeparators: true,
                                        elements: purchase.purchaseModel.data!,
                                        groupBy: (element) => element.purDate!.split('T')[0],
                                        groupSeparatorBuilder: (String value) => Container(
                                          color: ColorManager.green,
                                          width: size.width,
                                          padding: EdgeInsets.all(AppWidth.w10),
                                          child: Text(
                                            value.toString().split('T')[0].toString(),
                                            style: getBoldStyle(
                                              fontSize: FontSize.s18,
                                              color: ColorManager.white,
                                            ),
                                          ),
                                        ),
                                        itemComparator: (item1, item2) => item1.purDate!.compareTo(item2.purDate!),
                                        groupComparator: (value1, value2) => value1.compareTo(value2),
                                        itemBuilder: (context, element) {
                                          return Padding(
                                            padding: EdgeInsets.symmetric(horizontal: AppWidth.w6, vertical: AppHeight.h6),
                                            child: Slidable(
                                              endActionPane: ActionPane(
                                                extentRatio: 0.28,
                                                motion: const ScrollMotion(),
                                                children: [
                                                  // SlidableAction(
                                                  //   onPressed: (context) async {
                                                  //     pur.PurchaseByIdModel response = await context
                                                  //         .read<PurchaseByIdServiceProvider>()
                                                  //         .getPurchaseById(int.parse(element.purId.toString()));

                                                  //     pur.Data data = response.data!;

                                                  //     PurchaseDetails purchaseDetails = PurchaseDetails(
                                                  //       purId: data.purId,
                                                  //       purType: data.purType,
                                                  //       purDate: data.purDate,
                                                  //       purSupId: data.purSupId,
                                                  //       purMode: data.purMode,
                                                  //       purCashCredit: data.purCashCredit,
                                                  //       purInsertedDate: data.purInsertedDate,
                                                  //       purInsertedBy: data.purInsertedBy,
                                                  //       purSubAmount: data.purSubAmount,
                                                  //       purDiscAmount: data.purDiscAmount,
                                                  //       purTaxableAmount: data.purTaxableAmount,
                                                  //       purNonTaxableAmount: data.purNonTaxableAmount,
                                                  //       purVatAmount: data.purVatAmount,
                                                  //       purTotalAmount: data.purTotalAmount,
                                                  //       purInActive: data.purInActive,
                                                  //       supplier: data.supplier,
                                                  //       purBillNo: data.purBillNo,
                                                  //     );

                                                  //     for (var i = 0; i < data.purchaseDetailDtoList!.length; i++) {
                                                  //       PurchaseItemModel purchaseItemModel = PurchaseItemModel(
                                                  //         purDId: int.parse(data.purchaseDetailDtoList![i].purDId.toString()),
                                                  //         purDStkId: int.parse(data.purchaseDetailDtoList![i].purDStkId.toString()),
                                                  //         purDQty: double.parse(data.purchaseDetailDtoList![i].purDQty.toString()),
                                                  //         purchaseStkName: data.purchaseDetailDtoList![i].stDes.toString(),
                                                  //         purDRate: double.parse(data.purchaseDetailDtoList![i].purDRate.toString()),
                                                  //         stkTotal: double.parse(data.purchaseDetailDtoList![i].purDAmount.toString()),
                                                  //         purDSalesRate: data.purchaseDetailDtoList![i].purDSalesRate == null
                                                  //             ? 0.0
                                                  //             : double.parse(
                                                  //                 data.purchaseDetailDtoList![i].purDSalesRate.toString(),
                                                  //               ),
                                                  //       );
                                                  //       readPurchaseServiceProvider!.purchaseItemList.add(purchaseItemModel);
                                                  //       readPurchaseServiceProvider!.duplicatePurchaseItemList.add(purchaseItemModel);
                                                  //       readPurchaseServiceProvider!.tempPurchaseItemList.add(purchaseItemModel);
                                                  //     }

                                                  //     if (!mounted) return;
                                                  //     Navigator.pushAndRemoveUntil(
                                                  //         context,
                                                  //         MaterialPageRoute(
                                                  //           builder: (context) => PurchaseEntries(
                                                  //             purchaseDetails: purchaseDetails,
                                                  //             purchaseReturn: false,
                                                  //             fromPurchase: true,
                                                  //           ),
                                                  //         ),
                                                  //         (route) => false);
                                                  //   },
                                                  //   backgroundColor: const Color(0xFF21B7CA),
                                                  //   foregroundColor: ColorManager.white,
                                                  //   icon: Icons.edit,
                                                  //   label: 'edit',
                                                  // ),
                                                  SizedBox(width: AppWidth.w10),
                                                  SlidableAction(
                                                    onPressed: (context) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) => DeletePurchaseWidget(
                                                          purId: int.parse(
                                                            element.purId.toString(),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    borderRadius: BorderRadius.circular(AppRadius.r5),
                                                    backgroundColor: ColorManager.error,
                                                    foregroundColor: ColorManager.white,
                                                    icon: Icons.delete,
                                                    label: 'void',
                                                  ),
                                                ],
                                              ),
                                              child: Container(
                                                height: size.height * .10,
                                                width: size.width,
                                                padding: EdgeInsets.symmetric(horizontal: AppHeight.h6, vertical: AppHeight.h4),
                                                decoration: BoxDecoration(
                                                  color: ColorManager.white,
                                                  borderRadius: BorderRadius.circular(AppRadius.r5),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      blurRadius: 5.0, // soften the shadow
                                                      spreadRadius: 1.0, //extend the shadow
                                                      offset: Offset(1.0, 1.0),
                                                    )
                                                  ],
                                                ),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    context.read<PurchaseByIdServiceProvider>().purchaseByIdModel.data = null;
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => PurchaseDetailsPage(
                                                          purId: element.purId!,
                                                          fromPurchase: true,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: ListTile(
                                                    title: Text(
                                                      element.supplier.toString(),
                                                      style: getBoldStyle(
                                                        fontSize: FontSize.s14,
                                                        color: ColorManager.black,
                                                      ),
                                                    ),
                                                    subtitle: Row(
                                                      children: [
                                                        Text(
                                                          'Bill No: ',
                                                          style: getBoldStyle(
                                                            fontSize: FontSize.s12,
                                                            color: ColorManager.grey,
                                                          ),
                                                        ),
                                                        Text(
                                                          (element.purBillNo == null || element.purBillNo == '') ? '-' : element.purBillNo.toString(),
                                                          style: getRegularStyle(
                                                            fontSize: FontSize.s10,
                                                            color: ColorManager.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    trailing: Text(
                                                      element.purTotalAmount!.toStringAsFixed(2),
                                                      style: getSemiBoldStyle(
                                                        fontSize: FontSize.s14,
                                                        color: ColorManager.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                          // Slidable(
                                          //   endActionPane: ActionPane(
                                          //     extentRatio: 0.36,
                                          //     motion: const ScrollMotion(),
                                          //     children: [
                                          //       SlidableAction(
                                          //         onPressed: (context) {},
                                          //         backgroundColor: const Color(0xFF21B7CA),
                                          //         foregroundColor: ColorManager.white,
                                          //         icon: Icons.edit,
                                          //         label: 'Edit',
                                          //       ),
                                          //       SlidableAction(
                                          //         onPressed: (context) {},
                                          //         backgroundColor: ColorManager.error,
                                          //         foregroundColor: ColorManager.white,
                                          //         icon: Icons.delete,
                                          //         label: 'Delete',
                                          //       )
                                          //     ],
                                          //   ),
                                          //   child: PurchaseExpansionWidget(
                                          //     stockData: element,
                                          //   ),
                                          // );
                                        },
                                      ),
                                    ),
                        ],
                      );
                    },
                  ),
                ),
                bottomSheet: SizedBox(
                  height: size.height * 0.12,
                  child: Row(
                    children: [
                      const Spacer(),
                      SingleChildScrollView(
                        child: SizedBox(
                          width: size.width * 0.9,
                          height: size.height * 0.08,
                          child: DropdownButtonFormField<SupplierList>(
                            decoration: InputDecoration(
                              hintText: 'Select Supplier',
                              hintStyle: getSemiBoldStyle(
                                fontSize: FontSize.s10,
                                color: ColorManager.blackOpacity54,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: ColorManager.skyBlue, width: AppWidth.w2),
                                borderRadius: BorderRadius.circular(AppRadius.r10),
                              ),
                            ),
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down),
                            iconEnabledColor: ColorManager.skyBlue,
                            iconSize: FontSize.s15,
                            items: watchTabletSetupServiceProvider.tabletSetupModel.data!.supplierList!.map((project) {
                              return DropdownMenuItem<SupplierList>(
                                value: project,
                                child: Container(
                                  margin: EdgeInsets.only(left: AppWidth.w1),
                                  padding: EdgeInsets.only(left: AppWidth.w10),
                                  height: size.height * 0.06,
                                  width: double.infinity,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      project.supName.toString(),
                                      style: getRegularStyle(
                                        fontSize: FontSize.s10,
                                        color: ColorManager.blackOpacity54,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (project) {
                              watchTabletSetupServiceProvider.supplierList = project;
                              readPurchaseServiceProvider!.setSupId(project!.supId!);
                              getApiCall();
                            },
                            value: watchTabletSetupServiceProvider.supplierList,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Spacer(),
                    ],
                  ),
                ),
              );
      }),
    );
  }

  void selectFromDate() async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: context.read<PurchaseServiceProvider>().selectedFromDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2090),
    );
    if (selected != null && selected != readPurchaseServiceProvider!.selectedFromDate) {
      setState(() {
        readPurchaseServiceProvider!.setSelectedFromDate(selected);
        context.read<PurchaseServiceProvider>().purchaseModel.data = null;
        getApiCall();
      });
    }
  }

  void selectToDate() async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: readPurchaseServiceProvider!.selectedToDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2090),
    );
    if (selected != null && selected != readPurchaseServiceProvider!.selectedToDate) {
      if (!mounted) return;
      context.read<PurchaseServiceProvider>().purchaseModel.data = null;
      readPurchaseServiceProvider!.setSelectedToDate(selected);
      getApiCall();
      setState(() {});
    }
  }
}
