import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';
import 'package:webshop/view/homepage/home_screen.dart';
import 'package:webshop/widgets/search_widgets.dart';

class ItemAppBarWidget extends StatelessWidget {
  const ItemAppBarWidget({
    Key? key,
    required this.searchController,
  }) : super(key: key);

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    TabletSetupServiceProvider readTabletSetupServiceProvider = context.read<TabletSetupServiceProvider>();
    return Container(
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
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: ColorManager.white,
                ),
              ),
              Text(
                'Brand',
                style: getBoldStyle(
                  fontSize: FontSize.s20,
                  color: ColorManager.white,
                ),
              ),
              SizedBox(
                width: AppWidth.w40,
              ),
            ],
          ),
          SearchWidget(
            searchTextEditingController: searchController,
            onChanged: (value) {
              readTabletSetupServiceProvider.searchItemBrand(value);
            },
            onPressed: () {
              searchController.clear();
              FocusScope.of(context).requestFocus(FocusNode());
              readTabletSetupServiceProvider.searchItemBrand('');
            },
          ),
        ],
      ),
    );
  }
}
