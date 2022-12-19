import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/agent/model/agent_due_model.dart';
import 'package:webshop/view/agent/provider/agent_statement_provider.dart';
import 'package:webshop/view/agent/provider/get_agent_due_provider.dart';
import 'package:webshop/view/agent/screens/add_agent_screen.dart';
import 'package:webshop/view/agent/screens/agent_cash_receive_dialogue_screen.dart';
import 'package:webshop/view/agent/screens/agent_statement_screen.dart';
import 'package:webshop/view/homepage/home_screen.dart';
import 'package:webshop/widgets/item_widgets.dart';
import 'package:webshop/widgets/no_data_dialog.dart';
import 'package:webshop/widgets/search_widgets.dart';

import 'model/agent_model.dart';

class AgentPage extends StatefulWidget {
  const AgentPage({super.key});

  @override
  State<AgentPage> createState() => _AgentPageState();
}

class _AgentPageState extends State<AgentPage> {
  bool switchSelected = false;

  @override
  void initState() {
    super.initState();

    refresh();
    if (sharedPref!.getBool('switch_selected') == null) {
      sharedPref!.setBool('switch_selected', switchSelected);
    }
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController searchController = TextEditingController();

  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  Future<void> refresh() async {
    await context.read<AgentDueServiceProvider>().getAgentDue();
    if (!mounted) return;
    await context.read<TabletSetupServiceProvider>().getTabletSetup();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    AgentDueServiceProvider watchAgentDueServiceProvider = context.watch<AgentDueServiceProvider>();
    AgentStatementProvider watchAgentStatementProvider = context.watch<AgentStatementProvider>();
    TabletSetupServiceProvider readTabletSetupServiceProvider = context.read<TabletSetupServiceProvider>();

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
                backgroundColor: Theme.of(context).colorScheme.background,
                body: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SafeArea(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: AppHeight.h10),
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
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(AppRadius.r10),
                              bottomRight: Radius.circular(AppRadius.r10),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () {
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
                                    'Customers',
                                    style: getBoldStyle(
                                      fontSize: FontSize.s20,
                                      color: ColorManager.white,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      sharedPref!.getBool('switch_selected') == true
                                          ? Text(
                                              'Due Only',
                                              style: getMediumStyle(
                                                fontSize: FontSize.s14,
                                                color: ColorManager.white,
                                              ),
                                            )
                                          : Text(
                                              'Show All',
                                              style: getMediumStyle(
                                                fontSize: FontSize.s14,
                                                color: ColorManager.white,
                                              ),
                                            ),
                                      Switch(
                                        activeColor: ColorManager.darkGreen,
                                        value: sharedPref!.getBool('switch_selected')!,
                                        onChanged: (value) {
                                          setState(() {
                                            switchSelected = value;
                                            sharedPref!.setBool('switch_selected', switchSelected);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SearchWidget(
                                searchTextEditingController: searchController,
                                onChanged: (value) {
                                  (sharedPref!.getBool('switch_selected') == true)
                                      ? readTabletSetupServiceProvider.searchAgentListShowall(value)
                                      : watchAgentDueServiceProvider.searchAgent(value);
                                },
                                onPressed: () {
                                  searchController.clear();
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  watchAgentDueServiceProvider.searchAgent('');
                                  readTabletSetupServiceProvider.searchAgentListShowall('');
                                },
                              ),
                            ],
                          ),
                        ),
                        Consumer<ConnectivityProvider>(
                          builder: (context, connectivity, child) {
                            return (connectivity.isOnline == false)
                                ? const NoInternet()
                                : Consumer<AgentDueServiceProvider>(
                                    builder: (context, agentDue, child) {
                                      return agentDue.agentDueModel.data == null
                                          ? SizedBox(
                                              height: size.height * .75,
                                              width: size.width,
                                              child: const Center(
                                                child: LoadingBox(),
                                              ),
                                            )
                                          : RefreshIndicator(
                                              onRefresh: refresh,
                                              child: SingleChildScrollView(
                                                child: SizedBox(
                                                  height: size.height * .75,
                                                  width: size.width,
                                                  child: ListView.builder(
                                                    itemCount: (searchController.text.isNotEmpty)
                                                        ? agentDue.searchAgentList.length
                                                        : agentDue.agentDueModel.data!.length,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      AgentDue data;

                                                      // for show only with due agent

                                                      final sortedList = agentDue.agentDueModel.data!
                                                        ..sort(
                                                          (a, b) {
                                                            return a.agtCompany.toString().toLowerCase().compareTo(
                                                                  b.agtCompany.toString().toLowerCase(),
                                                                );
                                                          },
                                                        );

                                                      final sortedSearchList = agentDue.searchAgentList
                                                        ..sort(
                                                          (a, b) {
                                                            return a.agtCompany.toString().toLowerCase().compareTo(
                                                                  b.agtCompany.toString().toLowerCase(),
                                                                );
                                                          },
                                                        );

                                                      (searchController.text.isNotEmpty) ? data = sortedSearchList[index] : data = sortedList[index];

                                                      return (sharedPref!.getBool('switch_selected') == true && data.agtAmount! <= 0.0)
                                                          ? Container()
                                                          : gestureDetectorAgentMethod(
                                                              context, data, watchAgentStatementProvider, readTabletSetupServiceProvider);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            );
                                    },
                                  );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                bottomSheet: Consumer<ConnectivityProvider>(
                  builder: (context, connectivity, child) {
                    return Container(
                      height: size.height * 0.05,
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'To Receive: ',
                            style: getBoldStyle(
                              fontSize: FontSize.s18,
                              color: ColorManager.white,
                            ),
                          ),
                          (connectivity.isOnline == false)
                              ? Icon(
                                  Icons.signal_wifi_connected_no_internet_4,
                                  color: ColorManager.white,
                                )
                              : Text(
                                  watchAgentDueServiceProvider.debtorTotal.toString(),
                                  style: getRegularStyle(
                                    fontSize: FontSize.s16,
                                    color: ColorManager.darkWhite,
                                  ),
                                ),
                        ],
                      ),
                    );
                  },
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const AddAgentScreen(),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.add),
                ),
              );
      }),
    );
  }

  gestureDetectorAgentMethod(BuildContext context, AgentDue data, AgentStatementProvider watchAgentStatementProvider,
      TabletSetupServiceProvider tabletSetupServiceProvider) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.7,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              AgentModel agentModel = AgentModel(
                agtId: data.agtId,
                agtCompany: data.agtCompany,
                agtAdress: data.agtAdress,
                agtVatNo: data.agtVatNo,
                agtTel: data.agtTel,
                agtMobile: data.agtMobile,
                agtCategory: data.agtCategory,
                agtOpAmount: double.parse(data.agtOpAmount.toString()),
                agtAmount: data.agtAmount,
                agtSrourceId: data.agtSrourceId,
                agtOpDate: data.agtOpDate.toString().split("T")[0],
                agtInactive: data.agtInactive,
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddAgentScreen(
                    agentModel: agentModel,
                  ),
                  fullscreenDialog: true,
                ),
              );
            },
            backgroundColor: const Color(0xFF21B7CA),
            foregroundColor: ColorManager.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (context) {
              watchAgentStatementProvider
                  .setSelectedFromDate(DateTime.parse(tabletSetupServiceProvider.tabletSetupModel.data!.fiscalYear!.startDate!));
              watchAgentStatementProvider.selectedToDate = DateTime.now();
              watchAgentStatementProvider.balance = 0.0;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AgentStatementScreen(
                    agtId: int.parse(
                      data.agtId.toString(),
                    ),
                    agtMob: data.agtMobile,
                  ),
                ),
              );
            },
            backgroundColor: ColorManager.grey,
            foregroundColor: ColorManager.white,
            icon: Icons.history,
            label: 'Statement',
          ),
          SlidableAction(
            onPressed: (context) {
              showDialog(
                context: context,
                builder: (context) => AgentCashReciveDialogueScreen(
                  agtId: int.parse(
                    data.agtId.toString(),
                  ),
                  billDescription: data.agtCompany.toString(),
                ),
              );
            },
            backgroundColor: ColorManager.amber,
            foregroundColor: ColorManager.white,
            icon: Icons.receipt,
            label: 'Receive',
          ),
        ],
      ),
      child: Column(
        children: [
          ItemWidget(
            code: data.agtId.toString(),
            productName: data.agtCompany.toString(),
            productAddress: data.agtAdress.toString(),
            price: double.parse(data.agtAmount.toString()),
            onTap: () {},
            phoneNumber: data.agtMobile.toString(),
            date: data.agtOpDate!.toIso8601String().split("T")[0],
            type: 'Agent',
          ),
          Divider(
            height: AppHeight.h1,
            color: ColorManager.black,
          )
        ],
      ),
    );
  }
}
