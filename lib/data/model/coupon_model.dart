class CouponModel {
  int? id;
  String? name;
  int? discount;
  int? count;
  String? notes;
  String? details;
  String? validFrom;
  String? validTo;
  String? createdAt;
  String? updatedAt;

  CouponModel(
      {this.id,
      this.name,
      this.discount,
      this.count,
      this.notes,
      this.details,
      this.validFrom,
      this.validTo,
      this.createdAt,
      this.updatedAt});

  CouponModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    discount = json['discount'];
    count = json['count'];
    notes = json['notes'];
    details = json['details'];
    validFrom = json['valid_from'];
    validTo = json['valid_to'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['discount'] = this.discount;
    data['count'] = this.count;
    data['notes'] = this.notes;
    data['details'] = this.details;
    data['valid_from'] = this.validFrom;
    data['valid_to'] = this.validTo;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
