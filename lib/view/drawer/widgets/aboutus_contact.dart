import 'package:webshop/commons/exporter.dart';

class AboutUsContact extends StatelessWidget {
  const AboutUsContact({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.contactName,
    required this.iconColor,
  }) : super(key: key);

  final VoidCallback onTap;
  final IconData icon;
  final String contactName;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          margin: EdgeInsets.only(
            left: size.width * 0.05,
            right: size.width * 0.05,
            top: size.height * 0.02,
            bottom: size.height * 0.02,
          ),
          height: size.height * 0.08,
          width: size.width,
          decoration: BoxDecoration(
            border: Border.all(
              color: ColorManager.blackOpacity38,
            ),
            borderRadius: BorderRadius.circular(
              AppRadius.r30,
            ),
            color: ColorManager.grey3,
          ),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: AppWidth.w10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: FaIcon(
                  icon,
                  size: FontSize.s25,
                  color: iconColor,
                ),
              ),
              SizedBox(
                width: size.width * 0.05,
              ),
              Text(
                contactName,
                style: getSemiBoldStyle(
                  fontSize: FontSize.s12,
                  color: ColorManager.black,
                ),
              ),
              const Spacer(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
