class PivotcartAdditionalModel {
  int? cartId;
  int? additionalId;
  int? quantity;
  int? newquantity;
  double? oldAdditionalPrice;
  String? createdAt;
  String? updatedAt;

  PivotcartAdditionalModel(
      {this.cartId,
      this.additionalId,
      this.quantity,
      this.newquantity,
      this.oldAdditionalPrice,
      this.createdAt,
      this.updatedAt});

  PivotcartAdditionalModel.fromJson(Map<String, dynamic> json) {
    cartId = _toInt(json['cart_id']);
    additionalId = _toInt(json['additional_id']);
    quantity = _toInt(json['quantity']);

    // الحفاظ على منطق التحقق من newquantity أولاً ثم quantity
    newquantity = json['newquantity'] != null
        ? _toInt(json['newquantity'])
        : _toInt(json['quantity']);

    oldAdditionalPrice = _toDouble(json['old_additional_price']);

    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quantity'] = this.quantity;
    data['newquantity'] = this.newquantity;
    data['old_additional_price'] = this.oldAdditionalPrice;
    return data;
  }

  // دوال التحويل الآمنة لضمان عدم حدوث Type Mismatch
  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is double) return value.toInt();
    return null;
  }

  double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
