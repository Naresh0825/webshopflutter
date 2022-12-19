import 'package:flutter/material.dart';
import 'package:webshop/commons/exporter.dart';

class NoDataErrorBox extends StatelessWidget {
  const NoDataErrorBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Image.asset('assets/images/no_data.png'), const Text('Make sure data is available in server')],
    );
  }
}

class LoadingBox extends StatelessWidget {
  const LoadingBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          //Image.asset('assets/images/loading1.gif'),

          Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              SizedBox(width: AppWidth.w10),
              Text(
                'Loading...',
                textAlign: TextAlign.center,
                style: getBoldStyle(
                  fontSize: FontSize.s20,
                  color: ColorManager.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
