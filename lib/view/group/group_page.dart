import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/group/provider/group_provider.dart';
import 'widget/appbar_widget_item_page.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController searchController = TextEditingController();
  TextEditingController groupController = TextEditingController();

  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  Future<void> refresh() async {
    await context.read<TabletSetupServiceProvider>().getTabletSetup();
  }

  @override
  Widget build(BuildContext context) {
    GroupProvider readGroupProvider = context.read<GroupProvider>();
    TabletSetupServiceProvider watchTabletSetupServiceProvider = context.watch<TabletSetupServiceProvider>();

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
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Column(
            children: [
              ItemAppBarWidget(searchController: searchController),
              Consumer<TabletSetupServiceProvider>(
                builder: (context, getGroup, child) {
                  return RefreshIndicator(
                    onRefresh: refresh,
                    child: SingleChildScrollView(
                      child: Container(
                        height: size.height * .74,
                        width: size.width,
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          itemCount: (searchController.text.isNotEmpty)
                              ? watchTabletSetupServiceProvider.searchGroupList.length
                              : getGroup.tabletSetupModel.data!.itemGroupList!.length,
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            crossAxisSpacing: size.width * 0.02,
                            mainAxisSpacing: size.height * 0.015,
                            childAspectRatio: 1 / 1,
                            maxCrossAxisExtent: size.width * 0.3,
                            mainAxisExtent: size.height * 0.06,
                          ),
                          itemBuilder: (context, index) {
                            ItemGroupList data;
                            (searchController.text.isNotEmpty)
                                ? data = watchTabletSetupServiceProvider.searchGroupList[index]
                                : data = getGroup.tabletSetupModel.data!.itemGroupList![index];
                            return Container(
                              padding: EdgeInsets.only(right: AppHeight.h2, left: AppHeight.h2),
                              decoration: BoxDecoration(
                                color: ColorManager.blueGrey,
                                border: Border.all(
                                  color: ColorManager.blackOpacity38,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(AppRadius.r10),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  data.itemGroupName.toString().toUpperCase(),
                                  style: getMediumStyle(
                                    fontSize: FontSize.s12,
                                    color: ColorManager.black,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            getReportPop(context, size, groupController, readGroupProvider);
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void getReportPop(BuildContext context, Size size, TextEditingController groupController, GroupProvider groupProvider) {
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
                    key: formKey,
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
                    onCreate(groupController, groupProvider, 0);
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

  onCreate(TextEditingController groupController, GroupProvider groupProvider, int? groupId) async {
    if (formKey.currentState!.validate()) {
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
}
