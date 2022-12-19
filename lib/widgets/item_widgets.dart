import 'package:webshop/commons/exporter.dart';

class ItemWidget extends StatefulWidget {
  final Function() onTap;
  final String code;
  final String productName;
  final String productAddress;
  final double price;
  final String phoneNumber;
  final String date;
  final String type;
  const ItemWidget({
    super.key,
    required this.onTap,
    required this.code,
    required this.productName,
    required this.productAddress,
    required this.price,
    required this.phoneNumber,
    required this.date,
    required this.type,
  });

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  String? typeText;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    if (widget.type == "Agent") {
      (widget.price == 0.0)
          ? typeText = 'Settled'
          : (widget.price > 0.0)
              ? typeText = 'To Receive'
              : typeText = 'To Give';
    } else {
      (widget.price == 0.0)
          ? typeText = 'Settled'
          : (widget.price > 0.0)
              ? typeText = 'To Give'
              : typeText = 'To Receive';
    }

    return GestureDetector(
      onTap: () {},
      child: Stack(
        children: [
          SizedBox(
            width: size.width,
            height: size.height * .068,
            child: Container(
              padding: EdgeInsets.only(left: AppWidth.w10, right: AppWidth.w10),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: AppHeight.h10),
                      SizedBox(
                        width: size.width * .5,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Center(
                            child: Text(
                              widget.productName,
                              style: getMediumStyle(
                                fontSize: FontSize.s16,
                                color: ColorManager.black,
                              ),
                              overflow: TextOverflow.fade,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * .5,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Center(
                            child: Text(
                              (widget.phoneNumber == '' && widget.productAddress == '')
                                  ? ''
                                  : (widget.phoneNumber == "")
                                      ? widget.productAddress
                                      : widget.phoneNumber,
                              style: getBoldStyle(
                                fontSize: FontSize.s12,
                                color: ColorManager.grey,
                              ),
                              overflow: TextOverflow.fade,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 20,
            child: Padding(
              padding: EdgeInsets.only(right: AppWidth.w10),
              child: CustomPaint(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.price.toStringAsFixed(2),
                    style: getBoldStyle(
                      fontSize: FontSize.s14,
                      color: (typeText == "Settled")
                          ? ColorManager.black
                          : (typeText == "To Give")
                              ? ColorManager.error
                              : ColorManager.green,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Positioned(
          //   right: 0,
          //   bottom: 15,
          //   child: Padding(
          //     padding: EdgeInsets.only(right: AppWidth.w5),
          //     child: SizedBox(
          //       height: AppHeight.h20,
          //       width: AppWidth.w100,
          //       child: Align(
          //         alignment: Alignment.centerRight,
          //         child: Icon(
          //           size: FontSize.s18,
          //           Icons.arrow_forward_ios,
          //           color: ColorManager.grey2,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
