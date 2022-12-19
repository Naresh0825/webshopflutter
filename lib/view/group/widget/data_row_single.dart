import '../../../commons/exporter.dart';

class TextRow extends StatelessWidget {
  const TextRow({
    Key? key,
    required this.rowHeadText,
    required this.rowHeadData,
    required this.rowHeadTextColor,
    required this.rowHeadDataColor,
  }) : super(key: key);

  final String rowHeadText;
  final String rowHeadData;
  final Color rowHeadTextColor;
  final Color rowHeadDataColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          rowHeadText,
          style: getBoldStyle(
            color: rowHeadTextColor,
            fontSize: FontSize.s12,
          ),
        ),
        Text(
          rowHeadData,
          style: getRegularStyle(
            color: rowHeadDataColor,
            fontSize: FontSize.s12,
          ),
        ),
      ],
    );
  }
}
