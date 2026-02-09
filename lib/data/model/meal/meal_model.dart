import 'package:go_go/data/model/meal/additional_model.dart';
import 'package:go_go/data/model/my_store_model.dart';

class MealModel {
  int? id;
  int? storeId;
  String? name;
  String? description;
  String? note;
  String? image;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? deleteReason;
  String? banReason;
  String? appeal;
  String? banUntil;
  int? points;
  int? quantity;
  int? isActive;
  String? status;
  double? price;
  List<AdditionalsModel>? additionals;
  List<MealVariants>? variants;
  MyStoreModel? store;

  MealModel(
      {this.id,
      this.storeId,
      this.name,
      this.description,
      this.note,
      this.image,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.deleteReason,
      this.banReason,
      this.appeal,
      this.banUntil,
      this.points,
      this.quantity,
      this.isActive,
      this.status,
      this.price,
      this.additionals,
      this.variants,
      this.store});

  MealModel.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    storeId = _toInt(json['store_id']);
    name = json['name']?.toString();
    description = json['description']?.toString();
    note = json['note']?.toString();
    image = json['image']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    deletedAt = json['deleted_at']?.toString();
    banReason = json['ban_reason']?.toString();
    appeal = json['appeal']?.toString();
    banUntil = json['ban_until']?.toString();
    deleteReason = json['delete_reason']?.toString();
    points = _toInt(json['points']);
    quantity = _toInt(json['quantity']);
    isActive = _toInt(json['is_active']);
    status = json['status']?.toString();
    price = _toDouble(json['price']);

    // معالجة Additionals بذكاء (الحفاظ على منطق with_trashed)
    if (json.containsKey('additionals') && json['additionals'] != null) {
      additionals = <AdditionalsModel>[];
      json['additionals'].forEach((v) {
        additionals!.add(AdditionalsModel.fromJson(v));
      });
    } else if (json['additionals_with_trashed'] != null) {
      additionals = <AdditionalsModel>[];
      json['additionals_with_trashed'].forEach((v) {
        additionals!.add(AdditionalsModel.fromJson(v));
      });
    }

    // معالجة Variants بذكاء
    if (json.containsKey('variants') && json['variants'] != null) {
      variants = <MealVariants>[];
      json['variants'].forEach((v) {
        variants!.add(MealVariants.fromJson(v));
      });
    } else if (json['variants_with_trashed'] != null) {
      variants = <MealVariants>[];
      json['variants_with_trashed'].forEach((v) {
        variants!.add(MealVariants.fromJson(v));
      });
    } else {
      variants = <MealVariants>[];
    }

    store = json['store'] != null ? MyStoreModel.fromJson(json['store']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['store_id'] = storeId;
    data['name'] = name;
    data['description'] = description;
    data['note'] = note;
    data['image'] = image;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['ban_reason'] = banReason;
    data['appeal'] = appeal;
    data['ban_until'] = banUntil;
    data['delete_reason'] = deleteReason;
    data['points'] = points;
    data['quantity'] = quantity;
    data['is_active'] = isActive;
    data['status'] = status;
    data['price'] = price;
    if (additionals != null) {
      data['additionals'] = additionals!.map((v) => v.toJson()).toList();
    }
    if (variants != null) {
      data['variants'] = variants!.map((v) => v.toJson()).toList();
    }
    return data;
  }

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

class MealVariants {
  int? id;
  String? name;
  double? price;
  int? quantity;
  String? deletedAt;

  MealVariants({this.id, this.name, this.price, this.quantity, this.deletedAt});

  MealVariants.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    name = json['name']?.toString();
    price = _toDouble(json['price']);
    quantity = _toInt(json['quantity']);
    deletedAt = json['deleted_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['quantity'] = quantity;
    return data;
  }

  // أضفت الدوال هنا أيضاً لضمان استقلال الكلاس
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
