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
    id = json['id'];
    storeId = json['store_id'];
    name = json['name'];
    description = json['description'];
    note = json['note'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    banReason = json['ban_reason'];
    appeal = json['appeal'];
    banUntil = json['ban_until'];
    deleteReason = json['delete_reason'];
    points = json['points'];
    quantity = json['quantity'];
    isActive = json['is_active'];
    status = json['status'];
    price = json['price'] != null
        ? double.tryParse(json['price'].toString())
        : null;

    if (json.containsKey('additionals') && json['additionals'] != null) {
      additionals = <AdditionalsModel>[];
      json['additionals'].forEach((v) {
        additionals!.add(new AdditionalsModel.fromJson(v));
      });
    } else if (json['additionals_with_trashed'] != null) {
      additionals = <AdditionalsModel>[];
      json['additionals_with_trashed'].forEach((v) {
        additionals!.add(new AdditionalsModel.fromJson(v));
      });
    }

    if (json.containsKey('variants') && json['variants'] != null) {
      variants = <MealVariants>[];
      json['variants'].forEach((v) {
        variants!.add(new MealVariants.fromJson(v));
      });
    } else if (json['variants_with_trashed'] != null) {
      variants = <MealVariants>[];
      json['variants_with_trashed'].forEach((v) {
        variants!.add(new MealVariants.fromJson(v));
      });
    } else {
      variants = <MealVariants>[];
    }

    store =
        json['store'] != null ? new MyStoreModel.fromJson(json['store']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['store_id'] = this.storeId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['note'] = this.note;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['ban_reason'] = this.banReason;
    data['appeal'] = this.appeal;
    data['ban_until'] = this.banUntil;
    data['delete_reason'] = this.deleteReason;
    data['points'] = this.points;
    data['quantity'] = this.quantity;
    data['is_active'] = this.isActive;
    data['status'] = this.status;
    data['price'] = this.price;
    if (this.additionals != null) {
      data['additionals'] = this.additionals!.map((v) => v.toJson()).toList();
    }
    if (this.variants != null) {
      data['variants'] = this.variants!.map((v) => v.toJson()).toList();
    }
    return data;
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
    id = json['id'];
    name = json['name'];
    price = json['price'] != null
        ? double.tryParse(json['price'].toString())
        : null;
    quantity = json['quantity'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    return data;
  }
}
