import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:grouped_list/grouped_list.dart';

import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/homepage/home_screen.dart';
import 'package:webshop/view/sales/model/find_sale_model.dart';
import 'package:webshop/view/sales/services/sales_service.dart';
import 'package:webshop/view/sales_return/provider/get_salesbyid_provider.dart';
import 'package:webshop/widgets/no_data_dialog.dart';
import 'screens/sales_details.dart';
import 'services/find_sale_service.dart';

class SalesPage extends StatefulWidget {
  final bool isSalesReturn;
  const SalesPage({super.key, required this.isSalesReturn});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  SaleSummaryServiceProvider? readSaleSummaryServiceProvider;
  TabletSetupServiceProvider? watchTabletSetupServiceProvider;

  @override
  void initState() {
    getApiCall();
    super.initState();
  }

  Future<void> getApiCall() async {
    readSaleSummaryServiceProvider = context.read<SaleSummaryServiceProvider>();

    readSaleSummaryServiceProvider!.getSaleSummary(
      readSaleSummaryServiceProvider!.selectedFromDate,
      readSaleSummaryServiceProvider!.selectedToDate,
      context.read<SalesServiceProvider>().getAgentId,
      traType: widget.isSalesReturn ? 2 : 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    watchTabletSetupServiceProvider = context.watch<TabletSetupServiceProvider>();
    SalesServiceProvider readSalesServiceProvider = context.read<SalesServiceProvider>();
    SaleSummaryServiceProvider watchSaleSummaryServiceProvider = context.watch<SaleSummaryServiceProvider>();

    readSaleSummaryServiceProvider!.fromDate = readSaleSummaryServiceProvider!.selectedFromDate.toString().split(" ")[0].toString();
    readSaleSummaryServiceProvider!.toDate = readSaleSummaryServiceProvider!.selectedToDate.toString().split(" ")[0].toString();

    Widget labelStartDate = InkWell(
      onTap: () {
        readSaleSummaryServiceProvider!.selectStartDate(context);
      },
      child: Container(
        height: size.height * 0.06,
        width: size.width * 0.25,
        decoration: BoxDecoration(
          border: Border.all(
            color: ColorManager.white,
          ),
          borderRadius: BorderRadius.circular(AppRadius.r10),
        ),
        padding: EdgeInsets.all(AppHeight.h4),
        child: Center(
          child: Text(
            readSaleSummaryServiceProvider!.fromDate.toString(),
            style: getBoldStyle(
              fontSize: FontSize.s12,
              color: ColorManager.white,
            ),
          ),
        ),
      ),
    );
    Widget labelEndDate = InkWell(
      onTap: () {
        readSaleSummaryServiceProvider!.selectEndDate(context);
      },
      child: Container(
        height: size.height * 0.06,
        width: size.width * 0.25,
        decoration: BoxDecoration(
          border: Border.all(
            color: ColorManager.white,
          ),
          borderRadius: BorderRadius.circular(AppRadius.r10),
        ),
        padding: EdgeInsets.all(AppHeight.h4),
        child: Center(
          child: Text(
            readSaleSummaryServiceProvider!.toDate.toString(),
            style: getBoldStyle(
              fontSize: FontSize.s12,
              color: ColorManager.white,
            ),
          ),
        ),
      ),
    );

    return WillPopScope(
      onWillPop: () async {
        if (watchSaleSummaryServiceProvider.isDialOpen.value) {
          watchSaleSummaryServiceProvider.isDialOpen.value = false;
          return false;
        } else {
          return true;
        }
      },
      child: Consumer<ConnectivityProvider>(builder: (context, connectivity, child) {
        return (connectivity.isOnline == false)
            ? const NoInternet()
            : Scaffold(
                backgroundColor: Theme.of(context).colorScheme.background,
                body: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: SingleChildScrollView(
                    child: SafeArea(
                      child: Column(
                        children: [
                          SizedBox(
                            width: size.width,
                            height: size.height * .95,
                            child: Consumer<SaleSummaryServiceProvider>(
                              builder: (context, findSale, child) {
                                watchSaleSummaryServiceProvider.data = findSale.findSaleModel.data;
                                return Column(
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
                                            blurRadius: AppRadius.r4,
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
                                                  readSalesServiceProvider.setAgentId(null);
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
                                                widget.isSalesReturn ? 'Sales Return' : 'Sales',
                                                style: getBoldStyle(
                                                  fontSize: FontSize.s20,
                                                  color: ColorManager.white,
                                                ),
                                              ),
                                              SizedBox(width: AppWidth.w40),
                                            ],
                                          ),
                                          SizedBox(height: AppHeight.h10),
                                          Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      watchSaleSummaryServiceProvider.setSelectedFromDate(
                                                          watchSaleSummaryServiceProvider.selectedFromDate.subtract(const Duration(days: 1)));
                                                      watchSaleSummaryServiceProvider.setSelectedToDate(
                                                          watchSaleSummaryServiceProvider.selectedToDate.subtract(const Duration(days: 1)));
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
                                                      watchSaleSummaryServiceProvider.setSelectedFromDate(
                                                          watchSaleSummaryServiceProvider.selectedFromDate.add(const Duration(days: 1)));
                                                      watchSaleSummaryServiceProvider.setSelectedToDate(
                                                          watchSaleSummaryServiceProvider.selectedToDate.add(const Duration(days: 1)));
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
                                              SizedBox(
                                                height: AppHeight.h10,
                                              ),
                                              SizedBox(
                                                height: size.height * 0.06,
                                                width: size.width * 0.75,
                                                child: TypeAheadFormField<AgentList>(
                                                  hideSuggestionsOnKeyboardHide: true,
                                                  textFieldConfiguration: TextFieldConfiguration(
                                                      controller: watchSaleSummaryServiceProvider.customerController,
                                                      decoration: InputDecoration(
                                                        contentPadding: EdgeInsets.zero,
                                                        suffixIcon: watchSaleSummaryServiceProvider.customerController.text == ""
                                                            ? Icon(
                                                                Icons.arrow_drop_down,
                                                                color: ColorManager.blueBright,
                                                              )
                                                            : IconButton(
                                                                onPressed: () {
                                                                  watchSaleSummaryServiceProvider.customerController.clear();
                                                                  readSalesServiceProvider.setAgentId(null);
                                                                  getApiCall();
                                                                  FocusScope.of(context).requestFocus(FocusNode());
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
                                                        hintStyle: getRegularStyle(
                                                          fontSize: FontSize.s14,
                                                          color: ColorManager.grey,
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: ColorManager.blueBright),
                                                          borderRadius: BorderRadius.circular(AppRadius.r10),
                                                        ),
                                                        errorBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: ColorManager.red),
                                                          borderRadius: BorderRadius.circular(AppRadius.r10),
                                                        ),
                                                      )),
                                                  onSuggestionSelected: (AgentList agent) {
                                                    watchSaleSummaryServiceProvider.customerController.text = agent.agtCompany!;
                                                    readSalesServiceProvider.setAgentId(agent.agtId);
                                                    getApiCall();
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
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    (watchSaleSummaryServiceProvider.data == null)
                                        ? const Expanded(
                                            child: LoadingBox(),
                                          )
                                        : (watchSaleSummaryServiceProvider.data.isEmpty)
                                            ? const Expanded(
                                                child: NoDataErrorBox(),
                                              )
                                            : Expanded(
                                                child: RefreshIndicator(
                                                  onRefresh: () => getApiCall(),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      FocusScope.of(context).requestFocus(FocusNode());
                                                    },
                                                    child: GroupedListView<FindSale, String>(
                                                      useStickyGroupSeparators: true,
                                                      elements: findSale.findSaleModel.data!,
                                                      groupBy: (element) => element.traDate!.split('T')[0],
                                                      groupSeparatorBuilder: (String value) => Container(
                                                        color: ColorManager.green,

                                                        width: size.width,
                                                        padding: EdgeInsets.all(AppWidth.w10),
                                                        // color: ColorManager.black,
                                                        child: Text(
                                                          value.toString().split('T')[0].toString(),
                                                          style: getBoldStyle(
                                                            fontSize: FontSize.s18,
                                                            color: ColorManager.white,
                                                          ),
                                                        ),
                                                      ),
                                                      itemComparator: (item1, item2) => item2.traBillNo!.compareTo(item1.traBillNo!),
                                                      groupComparator: (value1, value2) => value2.compareTo(value1),
                                                      itemBuilder: (context, element) {
                                                        return Padding(
                                                          padding: EdgeInsets.symmetric(horizontal: AppWidth.w6, vertical: AppHeight.h6),
                                                          child: Container(
                                                            height: size.height * .10,
                                                            width: size.width,
                                                            padding: EdgeInsets.symmetric(horizontal: AppHeight.h6, vertical: AppHeight.h4),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(AppRadius.r5),
                                                              color: ColorManager.white,
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
                                                                // Navigator.push(
                                                                //   context,
                                                                //   MaterialPageRoute(
                                                                //     builder: (context) => SalesDetailsPage(
                                                                //       salesId: element.traId!,
                                                                //     ),
                                                                //   ),
                                                                // );,
                                                                context.read<GetSalesByIdProvider>().getSalesByIdModel.data = null;
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) => SalesDetails(
                                                                      salesId: element.traId!,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              child: ListTile(
                                                                title: Text(
                                                                  element.traCustomerName.toString(),
                                                                  style: getBoldStyle(
                                                                    fontSize: FontSize.s14,
                                                                    color: ColorManager.black,
                                                                  ),
                                                                ),
                                                                subtitle: Row(
                                                                  children: [
                                                                    Text(
                                                                      'Bill No:',
                                                                      style: getRegularStyle(
                                                                        fontSize: FontSize.s12,
                                                                        color: ColorManager.grey,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      (element.traBillNo == null || element.traBillNo == '')
                                                                          ? '-'
                                                                          : element.traBillNo.toString(),
                                                                      style: getBoldStyle(
                                                                        fontSize: FontSize.s12,
                                                                        color: ColorManager.grey,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                trailing: Text(
                                                                  element.traTotalAmount!.toStringAsFixed(2),
                                                                  style: getSemiBoldStyle(
                                                                    fontSize: FontSize.s14,
                                                                    color: ColorManager.black,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
      }),
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
