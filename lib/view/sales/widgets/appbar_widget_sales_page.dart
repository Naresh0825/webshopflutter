import 'package:flutter/material.dart';

import '../../../commons/exporter.dart';

class SalesAppBarWidget extends StatefulWidget {
  const SalesAppBarWidget({Key? key, required}) : super(key: key);

  @override
  State<SalesAppBarWidget> createState() => _SalesAppBarWidgetState();
}

class _SalesAppBarWidgetState extends State<SalesAppBarWidget> {
  String? taskStartDate;
  DateTime selectedFromDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    taskStartDate = selectedFromDate.toString().split(" ")[0].toString();
    Widget labelStartDate = InkWell(
      onTap: () {
        selectFromDate();
      },
      child: Container(
        height: size.height * 0.05,
        width: size.width * 0.3,
        padding: EdgeInsets.all(AppHeight.h4),
        decoration: BoxDecoration(
          border: Border.all(color: ColorManager.primary),
          borderRadius: BorderRadius.circular(AppRadius.r10),
        ),
        child: Center(
          child: Text(
            taskStartDate.toString(),
            style: getBoldStyle(
              fontSize: FontSize.s12,
              color: ColorManager.white,
            ),
          ),
        ),
      ),
    );
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
            blurRadius: 5,
            offset: const Offset(0.0, 1.0),
            color: ColorManager.grey,
          )
        ],
        // borderRadius: const BorderRadius.only(
        //   bottomLeft: Radius.circular(10.0),
        //   bottomRight: Radius.circular(10.0),
        // ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: ColorManager.white,
                ),
              ),
              Text(
                'Sales',
                style: getBoldStyle(
                  fontSize: FontSize.s20,
                  color: ColorManager.white,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.filter_list,
                  color: ColorManager.white,
                ),
              ),
            ],
          ),
          SizedBox(height: AppHeight.h10),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: ColorManager.white),
              borderRadius: BorderRadius.circular(AppRadius.r10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: ColorManager.white,
                  ),
                ),
                labelStartDate,
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: ColorManager.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void selectFromDate() async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedFromDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2090),
    );
    if (selected != null && selected != selectedFromDate) {
      setState(() {
        selectedFromDate = selected;
      });
    }
  }
}
