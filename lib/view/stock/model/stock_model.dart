class StockDetail {
  int? stkId;
  String? stDes;
  dynamic stkDate;
  dynamic stTypeDes;
  dynamic catDes;
  String? itemGroupName;
  int? stkPurUnitId;
  int? stkTrackUnitId;
  dynamic stkPurUnitDes;
  dynamic stkTrackUnitDes;
  double? stkRate;
  dynamic tranType;
  double? stkOBAL;
  double? stkOVAL;
  double? stkPQTY;
  double? stkPVAL;
  double? stkIQTY;
  double? stkIVAL;
  double? stkLDQTY;
  double? stkLDVAL;
  double? stkCBAL;
  double? stkCVAL;
  dynamic supplier;
  dynamic purBillNo;
  dynamic customer;
  dynamic issueNo;
  dynamic lostComment;
  dynamic tranId;
  dynamic insertedDate;
  dynamic calRate;
  dynamic tranDId;

  StockDetail(
      {this.stkId,
      this.stDes,
      this.stkDate,
      this.stTypeDes,
      this.catDes,
      this.itemGroupName,
      this.stkPurUnitId,
      this.stkTrackUnitId,
      this.stkPurUnitDes,
      this.stkTrackUnitDes,
      this.stkRate,
      this.tranType,
      this.stkOBAL,
      this.stkOVAL,
      this.stkPQTY,
      this.stkPVAL,
      this.stkIQTY,
      this.stkIVAL,
      this.stkLDQTY,
      this.stkLDVAL,
      this.stkCBAL,
      this.stkCVAL,
      this.supplier,
      this.purBillNo,
      this.customer,
      this.issueNo,
      this.lostComment,
      this.tranId,
      this.insertedDate,
      this.calRate,
      this.tranDId});

  StockDetail.fromJson(Map<String, dynamic> json) {
    stkId = json['stkId'];
    stDes = json['stDes'];
    stkDate = json['stkDate'];
    stTypeDes = json['stTypeDes'];
    catDes = json['catDes'];
    itemGroupName = json['itemGroupName'];
    stkPurUnitId = json['stkPurUnitId'];
    stkTrackUnitId = json['stkTrackUnitId'];
    stkPurUnitDes = json['stkPurUnitDes'];
    stkTrackUnitDes = json['stkTrackUnitDes'];
    stkRate = json['stkRate'] == null ? null : double.parse(json['stkRate'].toString());
    tranType = json['tranType'] == null ? null : double.parse(json['tranType'].toString());
    stkOBAL = json['stkOBAL'];
    stkOVAL = json['stkOVAL'];
    stkPQTY = json['stkPQTY'];
    stkPVAL = json['stkPVAL'] == null ? null : double.parse(json['stkPVAL'].toString());
    stkIQTY = json['stkIQTY'];
    stkIVAL = json['stkIVAL'] == null ? null : double.parse(json['stkIVAL'].toString());
    stkLDQTY = json['stkLDQTY'].toDouble();
    stkLDVAL = json['stkLDVAL'] == null ? null : double.parse(json['stkLDVAL'].toString());
    stkCBAL = json['stkCBAL'];
    stkCVAL = json['stkCVAL'];
    supplier = json['supplier'];
    purBillNo = json['purBillNo'];
    customer = json['customer'];
    issueNo = json['issueNo'];
    lostComment = json['lostComment'];
    tranId = json['tranId'];
    insertedDate = json['insertedDate'];
    calRate = json['calRate'];
    tranDId = json['tranDId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stkId'] = stkId;
    data['stDes'] = stDes;
    data['stkDate'] = stkDate;
    data['stTypeDes'] = stTypeDes;
    data['catDes'] = catDes;
    data['itemGroupName'] = itemGroupName;
    data['stkPurUnitId'] = stkPurUnitId;
    data['stkTrackUnitId'] = stkTrackUnitId;
    data['stkPurUnitDes'] = stkPurUnitDes;
    data['stkTrackUnitDes'] = stkTrackUnitDes;
    data['stkRate'] = stkRate;
    data['tranType'] = tranType;
    data['stkOBAL'] = stkOBAL;
    data['stkOVAL'] = stkOVAL;
    data['stkPQTY'] = stkPQTY;
    data['stkPVAL'] = stkPVAL;
    data['stkIQTY'] = stkIQTY;
    data['stkIVAL'] = stkIVAL;
    data['stkLDQTY'] = stkLDQTY;
    data['stkLDVAL'] = stkLDVAL;
    data['stkCBAL'] = stkCBAL;
    data['stkCVAL'] = stkCVAL;
    data['supplier'] = supplier;
    data['purBillNo'] = purBillNo;
    data['customer'] = customer;
    data['issueNo'] = issueNo;
    data['lostComment'] = lostComment;
    data['tranId'] = tranId;
    data['insertedDate'] = insertedDate;
    data['calRate'] = calRate;
    data['tranDId'] = tranDId;
    return data;
  }
}
