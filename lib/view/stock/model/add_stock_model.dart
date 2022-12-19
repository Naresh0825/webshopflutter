class StockModel {
  String stDes;
  String stCode;
  int stItemGroupId;
  int stBrandId;
  String stItemGroupName;
  bool stInActive;
  String? stImage;
  double stOBal;
  double stORate;
  double stOVal;
  double stCurBal;
  double stCurRate;
  int stId;
  double stReOrder;
  String stODate;
  double stSalesRate;

  StockModel({
    required this.stDes,
    required this.stCode,
    required this.stItemGroupId,
    required this.stBrandId,
    required this.stItemGroupName,
    required this.stInActive,
    required this.stOBal,
    required this.stORate,
    required this.stOVal,
    required this.stCurBal,
    required this.stCurRate,
    required this.stReOrder,
    this.stImage,
    required this.stId,
    required this.stODate,
    required this.stSalesRate,
  });
}
