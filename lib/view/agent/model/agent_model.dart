class AgentModel {
  int? agtId;
  String? agtCompany;
  String? agtAdress;
  int? agtVatNo;
  String? agtTel;
  String? agtMobile;
  int? agtCategory;
  int? agtCreditLimit;
  double? agtOpAmount;
  double? agtAmount;
  bool? agtInactive;
  int? agtSrourceId;
  String? agtOpDate;
  double? agtDiscount;

  AgentModel({
    this.agtId,
    this.agtCompany,
    this.agtAdress,
    this.agtVatNo,
    this.agtTel,
    this.agtMobile,
    this.agtCategory,
    this.agtCreditLimit,
    this.agtOpAmount,
    this.agtAmount,
    this.agtInactive,
    this.agtSrourceId,
    this.agtOpDate,
    this.agtDiscount,
  });

  AgentModel.fromJson(Map<String, dynamic> json) {
    agtId = json['AgtId'];
    agtCompany = json['AgtCompany'];
    agtAdress = json['AgtAdress'];
    agtVatNo = json['AgtVatNo'];
    agtTel = json['AgtTel'];
    agtMobile = json['AgtMobile'];
    agtCategory = json['AgtCategory'];
    agtCreditLimit = json['AgtCreditLimit'];
    agtOpAmount = json['AgtOpAmount'];
    agtAmount = json['AgtAmount'];
    agtInactive = json['AgtInactive'];
    agtSrourceId = json['AgtSrourceId'];
    agtOpDate = json['AgtOpDate'];
    agtDiscount = json['AgtDiscount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AgtId'] = agtId;
    data['AgtCompany'] = agtCompany;
    data['AgtAdress'] = agtAdress;
    data['AgtVatNo'] = agtVatNo;
    data['AgtTel'] = agtTel;
    data['AgtMobile'] = agtMobile;
    data['AgtCategory'] = agtCategory;
    data['AgtCreditLimit'] = agtCreditLimit;
    data['AgtOpAmount'] = agtOpAmount;
    data['AgtAmount'] = agtAmount;
    data['AgtInactive'] = agtInactive;
    data['AgtSrourceId'] = agtSrourceId;
    data['AgtOpDate'] = agtOpDate;
    data['AgtDiscount'] = agtDiscount;
    return data;
  }
}
