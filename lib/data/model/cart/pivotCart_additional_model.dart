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
    cartId = json['cart_id'];
    additionalId = json['additional_id'];
    quantity = json['quantity'];
    newquantity = json['newquantity'] ?? json['quantity'];
    oldAdditionalPrice = json['old_additional_price'] != null
        ? double.tryParse(json['old_additional_price'].toString())
        : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    //data['cart_id'] = this.cartId;
    //data['additional_id'] = this.additionalId;
    data['quantity'] = this.quantity;
    data['newquantity'] = this.newquantity;
    data['old_additional_price'] = this.oldAdditionalPrice;
    //data['created_at'] = this.createdAt;
    //data['updated_at'] = this.updatedAt;
    return data;
  }
}
