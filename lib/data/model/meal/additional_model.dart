import 'package:go_go/data/model/cart/pivotCart_additional_model.dart';

class AdditionalsModel {
  int? id;
  String? name;
  double? price;
  int? quantity;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  PivotcartAdditionalModel? pivot;

  AdditionalsModel(
      {this.id,
      this.name,
      this.price,
      this.quantity,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.pivot});

  AdditionalsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'] != null
        ? double.tryParse(json['price'].toString())
        : null;
    quantity = json['quantity'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    pivot = json['pivot'] != null
        ? PivotcartAdditionalModel.fromJson(json['pivot'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    //data['name'] = this.name;
    //data['price'] = this.price;
    // data['created_at'] = this.createdAt;
    // data['updated_at'] = this.updatedAt;
    // data['deleted_at'] = this.deletedAt;
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }
}
