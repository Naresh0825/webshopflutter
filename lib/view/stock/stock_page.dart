import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grouped_list/grouped_list.dart';

import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/homepage/home_screen.dart';
import 'package:webshop/view/stock/model/add_stock_model.dart';
import 'package:webshop/view/stock/model/stock_list_model.dart';
import 'package:webshop/view/stock/reports/stock_detail_report.dart';
import 'package:webshop/view/stock/services/add_stock_provider.dart';
import 'package:webshop/widgets/no_data_dialog.dart';
import 'package:webshop/widgets/search_widgets.dart';

import 'screens/add_item.dart';
import 'services/get_stock_detail_provider.dart';
import 'widgets/tag.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPage();
}

class _StockPage extends State<StockPage> {
  TextEditingController searchController = TextEditingController();
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  int? brandId;

  @override
  void initState() {
    getApiCall();
    super.initState();
  }

  getApiCall() async {
    await context.read<GetStockListProvider>().getStockList(brandId);
  }

  Future<void> refresh() async {
    TabletSetupServiceProvider readTabletSetupServiceProvider = context.read<TabletSetupServiceProvider>();
    readTabletSetupServiceProvider.brandList = null;
    brandId = null;
    await context.read<GetStockListProvider>().getStockList(brandId);
  }

  @override
  Widget build(BuildContext context) {
    TabletSetupServiceProvider watchTabletSetupServiceProvider = context.watch<TabletSetupServiceProvider>();
    GetStockListProvider watchGetStockListProvider = context.watch<GetStockListProvider>();
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        if (isDialOpen.value) {
          isDialOpen.value = false;
          return false;
        } else {
          return true;
        }
      },
      child: Consumer<ConnectivityProvider>(
        builder: (context, connectivity, child) {
          return (connectivity.isOnline == false)
              ? const NoInternet()
              : Scaffold(
                  body: SafeArea(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(AppHeight.h14),
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
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil(
                                          context,
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
                                    'Stock',
                                    style: getBoldStyle(
                                      fontSize: FontSize.s20,
                                      color: ColorManager.white,
                                    ),
                                  ),
                                  SizedBox(width: AppWidth.w30),
                                ],
                              ),
                              SizedBox(height: AppHeight.h10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SearchWidget(
                                    reqWidth: size.width * 0.45,
                                    searchTextEditingController: searchController,
                                    onChanged: (value) {
                                      watchGetStockListProvider.searchStock(value);
                                    },
                                    onPressed: () {
                                      searchController.clear();
                                      FocusScope.of(context).requestFocus(FocusNode());
                                      watchGetStockListProvider.searchStock('');
                                    },
                                  ),
                                  SingleChildScrollView(
                                    child: Container(
                                      width: size.width * 0.45,
                                      height: size.height * 0.065,
                                      decoration: BoxDecoration(
                                        color: ColorManager.white,
                                        borderRadius: BorderRadius.circular(AppRadius.r10),
                                      ),
                                      child: DropdownButtonFormField<BrandList>(
                                        decoration: InputDecoration(
                                          hintText: 'Select Brand',
                                          hintStyle: getSemiBoldStyle(
                                            fontSize: FontSize.s16,
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
                                        iconSize: FontSize.s20,
                                        items: watchTabletSetupServiceProvider.tabletSetupModel.data!.brandList!.map((project) {
                                          return DropdownMenuItem<BrandList>(
                                            value: project,
                                            child: Container(
                                              margin: EdgeInsets.only(left: AppWidth.w1),
                                              padding: EdgeInsets.only(left: AppWidth.w10),
                                              height: size.height * 0.08,
                                              width: double.infinity,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  project.brandName.toString(),
                                                  style: getRegularStyle(
                                                    fontSize: FontSize.s16,
                                                    color: ColorManager.blackOpacity54,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (project) {
                                          watchTabletSetupServiceProvider.brandList = project;
                                          brandId = watchTabletSetupServiceProvider.brandList!.brandId;
                                          getApiCall();
                                        },
                                        value: watchTabletSetupServiceProvider.brandList,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Consumer<GetStockListProvider>(
                            builder: (context, stock, index) {
                              return SizedBox(
                                child: RefreshIndicator(
                                  onRefresh: refresh,
                                  child: SingleChildScrollView(
                                    child: stock.getStockListModel.data == null
                                        ? SizedBox(
                                            height: size.height,
                                            width: size.width,
                                            child: const Center(
                                              child: LoadingBox(),
                                            ),
                                          )
                                        : SizedBox(
                                            height: size.height * 0.7,
                                            width: size.width,
                                            child: (stock.getStockListModel.data!.isEmpty)
                                                ? const NoDataErrorBox()
                                                : RefreshIndicator(
                                                    onRefresh: refresh,
                                                    child: GroupedListView<StockDetailList, String>(
                                                      useStickyGroupSeparators: true,
                                                      elements: (searchController.text.isNotEmpty)
                                                          ? watchGetStockListProvider.searchStockList
                                                          : stock.getStockListModel.data!,
                                                      groupBy: (element) => element.itemGroupName!,
                                                      groupSeparatorBuilder: (String value) => Container(
                                                        width: size.width,
                                                        padding: EdgeInsets.all(AppWidth.w10),
                                                        color: Colors.grey.shade300,
                                                        child: Text(
                                                          value.toUpperCase(),
                                                          style: getBoldStyle(
                                                            fontSize: FontSize.s18,
                                                            color: ColorManager.black,
                                                          ),
                                                        ),
                                                      ),
                                                      itemComparator: (item1, item2) => item1.stDes!.compareTo(item2.stDes!),
                                                      groupComparator: (value1, value2) => value1.compareTo(value2),
                                                      itemBuilder: (context, element) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                builder: (context) => StockDetailReport(
                                                                  stId: element.stId,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Container(
                                                            padding: EdgeInsets.symmetric(horizontal: AppWidth.w6, vertical: AppHeight.h6),
                                                            child: Slidable(
                                                                endActionPane: ActionPane(
                                                                  extentRatio: 0.25,
                                                                  motion: const ScrollMotion(),
                                                                  children: [
                                                                    SlidableAction(
                                                                      onPressed: (context) {
                                                                        StockModel stockModel = StockModel(
                                                                          stItemGroupName: element.itemGroupName!,
                                                                          stDes: element.stDes!,
                                                                          stItemGroupId: element.stItemGroupId!,
                                                                          stBrandId: element.stBrandId!,
                                                                          stCode: element.stCode!,
                                                                          stInActive: element.stInActive!,
                                                                          stOBal: element.stOBal!,
                                                                          stORate: element.stORate!,
                                                                          stOVal: element.stOVal!,
                                                                          stCurBal: element.stCurBal!,
                                                                          stCurRate: element.stCurRate!,
                                                                          stReOrder: element.stReOrder!,
                                                                          stId: element.stId!,
                                                                          stODate: DateTime.parse(DateTime.now().toIso8601String().split("T")[0])
                                                                              .toIso8601String(),
                                                                          stSalesRate: element.stSalesRate!,
                                                                          stImage: null,
                                                                        );
                                                                        Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                            builder: (context) => AddStockPage(
                                                                              stockModel: stockModel,
                                                                              brandName: element.brandName,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                      borderRadius: BorderRadius.circular(AppRadius.r5),
                                                                      backgroundColor: const Color(0xFF21B7CA),
                                                                      foregroundColor: ColorManager.white,
                                                                      icon: Icons.edit,
                                                                      label: 'Edit',
                                                                    ),
                                                                    // SlidableAction(
                                                                    //   onPressed: (context) {
                                                                    //     showDialog<String>(
                                                                    //       context: context,
                                                                    //       builder: (BuildContext context) => AlertDialog(
                                                                    //         title: const Text('Delete Stock'),
                                                                    //         content: const Text('Are you sure you want to delete the item?'),
                                                                    //         actions: <Widget>[
                                                                    //           TextButton(
                                                                    //             child: const Text('Cancel'),
                                                                    //             onPressed: () {
                                                                    //               Navigator.of(context).pop();
                                                                    //             },
                                                                    //           ),
                                                                    //           TextButton(
                                                                    //             child: const Text('Yes'),
                                                                    //             onPressed: () {
                                                                    //               deleteStock(element.stId!, readAddRemoveStockProvider);
                                                                    //               Navigator.of(context).pop();
                                                                    //             },
                                                                    //           ),
                                                                    //         ],
                                                                    //       ),
                                                                    //     );
                                                                    //   },
                                                                    //   backgroundColor: ColorManager.error,
                                                                    //   foregroundColor: ColorManager.white,
                                                                    //   icon: Icons.delete,
                                                                    //   label: 'Delete',
                                                                    // )
                                                                  ],
                                                                ),
                                                                child: Padding(
                                                                  padding: EdgeInsets.symmetric(horizontal: AppWidth.w8),
                                                                  child: Container(
                                                                    height: size.height * .10,
                                                                    width: size.width,
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(AppRadius.r5),
                                                                      color: ColorManager.white,
                                                                      boxShadow: const [
                                                                        BoxShadow(
                                                                          color: Colors.grey,
                                                                          blurRadius: 1.0,
                                                                          spreadRadius: 0.0,
                                                                          offset: Offset(2.0, 2.0),
                                                                        ),
                                                                        BoxShadow(
                                                                          color: Colors.grey,
                                                                          blurRadius: 1.0,
                                                                          spreadRadius: 0.0,
                                                                          offset: Offset(-1.0, -1.0),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    child: Stack(
                                                                      children: [
                                                                        Positioned(
                                                                          right: 0,
                                                                          bottom: 5,
                                                                          child: Column(
                                                                            children: [
                                                                              Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    element.brandName.toString(),
                                                                                    style: getMediumStyle(
                                                                                        fontSize: FontSize.s12, color: ColorManager.grey),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                height: AppHeight.h20,
                                                                                width: AppWidth.w90,
                                                                                child: CustomPaint(
                                                                                  painter: PriceTagPaint(),
                                                                                  child: Center(
                                                                                    child: Text('${element.stSalesRate}',
                                                                                        style: getBoldStyle(
                                                                                            fontSize: FontSize.s12, color: ColorManager.white)),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Container(
                                                                              decoration: BoxDecoration(
                                                                                color: ColorManager.grey3,
                                                                                borderRadius: BorderRadius.only(
                                                                                  bottomLeft: Radius.circular(AppRadius.r5),
                                                                                  topLeft: Radius.circular(AppRadius.r5),
                                                                                ),
                                                                              ),
                                                                              width: size.width * .3,
                                                                              height: size.height * .17,
                                                                              child: Stack(children: [
                                                                                Center(
                                                                                  child: Text(
                                                                                    element.brandName.toString()[0],
                                                                                    style: getBoldStyle(
                                                                                        fontSize: FontSize.s60,
                                                                                        color: ColorManager.grey.withOpacity(.5)),
                                                                                  ),
                                                                                )
                                                                              ]),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsets.symmetric(
                                                                                  horizontal: AppWidth.w5, vertical: AppHeight.h4),
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  SizedBox(
                                                                                    width: size.width * .5,
                                                                                    height: size.height * .05,
                                                                                    child: Text(
                                                                                      element.stDes.toString(),
                                                                                      maxLines: 2,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      style: getMediumStyle(
                                                                                          fontSize: FontSize.s15, color: ColorManager.black),
                                                                                    ),
                                                                                  ),
                                                                                  Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Row(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Text(
                                                                                            'Qty: ',
                                                                                            style: getMediumStyle(
                                                                                                fontSize: FontSize.s12, color: ColorManager.grey),
                                                                                          ),
                                                                                          Text(
                                                                                            element.stCurBal.toString(),
                                                                                            style: getSemiBoldStyle(
                                                                                                fontSize: FontSize.s12, color: ColorManager.black),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      Row(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Text(
                                                                                            'Cost: ',
                                                                                            style: getMediumStyle(
                                                                                                fontSize: FontSize.s12, color: ColorManager.grey),
                                                                                          ),
                                                                                          Text(
                                                                                            element.stCurRate.toString(),
                                                                                            style: getSemiBoldStyle(
                                                                                                fontSize: FontSize.s12, color: ColorManager.black),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                                // StockExpansionWidget(
                                                                //   stockData: element,
                                                                // ),
                                                                ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                          ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => const AddStockPage(),
                            fullscreenDialog: true,
                          ));
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (BuildContext context) => const AddStockPage(),
                      //       fullscreenDialog: true,
                      //     ));
                    },
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.add),
                  ),
                );
        },
      ),
    );
  }

  deleteStock(int stId, AddRemoveStockProvider addRemoveStockProvider) async {
    bool status = await addRemoveStockProvider.removeStock(stId);
    if (status) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: 'Stock Removed',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: ColorManager.grey,
      );
      refresh();
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: 'Failed to remove Stock',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: ColorManager.error,
      );
    }
  }
}
