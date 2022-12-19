class SupplierModel {
  final int supId;
  final String supName;
  final int supVat;
  final String supAddress;
  final String supMobile;
  final String supPhone;
  final String supOpDate;
  final double supOpAmt;
  final double supAmt;
  final bool supInActive;

  SupplierModel({
    required this.supId,
    required this.supName,
    required this.supVat,
    required this.supAddress,
    required this.supMobile,
    required this.supPhone,
    required this.supOpDate,
    required this.supOpAmt,
    required this.supAmt,
    required this.supInActive,
  });
}
