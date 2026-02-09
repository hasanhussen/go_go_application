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
    id = _toInt(json['id']); // تحويل آمن
    name = json['name']?.toString();
    price = _toDouble(json['price']); // تحويل آمن
    quantity = _toInt(json['quantity']); // تحويل آمن
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    deletedAt = json['deleted_at']?.toString();
    pivot = json['pivot'] != null
        ? PivotcartAdditionalModel.fromJson(json['pivot'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }

  // دوال التحويل لضمان استقرار الأنواع
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