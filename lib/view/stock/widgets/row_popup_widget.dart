import '../../../commons/exporter.dart';

class RowPopUpWidget extends StatelessWidget {
  final String title;
  final String titleDetail;
  const RowPopUpWidget(
      {Key? key, required this.title, required this.titleDetail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          title,
          style: getBoldStyle(
            fontSize: FontSize.s12,
            color: const Color(0xff0074E3),
          ),
        ),
        Expanded(
          child: Text(
            titleDetail,
            style: getMediumStyle(
              fontSize: FontSize.s12,
              color: ColorManager.black,
            ),
          ),
        ),
      ],
    );
  }
}
