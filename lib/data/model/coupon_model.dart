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
    id = _toInt(json['id']); // تحويل آمن
    name = json['name']?.toString();
    discount = _toInt(
        json['discount']); // تحويل آمن (غالباً ما يأتي كـ String من السيرفر)
    count = _toInt(json['count']); // تحويل آمن
    notes = json['notes']?.toString();
    details = json['details']?.toString();
    validFrom = json['valid_from']?.toString();
    validTo = json['valid_to']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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

  // دوال التحويل الآمنة لضمان استقرار الأنواع
  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is double) return value.toInt();
    return null;
  }
}
