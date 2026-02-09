import 'package:go_go/data/model/meal/additional_model.dart';
import 'package:go_go/data/model/meal/meal_model.dart';
import 'package:go_go/data/model/order_model.dart';

class CartModel {
  int? id;
  int? mealId;
  int? userId;
  int? quantity;
  int? newquantity;
  double? oldMealPrice;
  double? price;
  double? oldPrice;
  String? createdAt;
  String? updatedAt;
  int? orderId;
  int? variantId;
  MealModel? meal;
  List<AdditionalsModel>? additionalItems;
  OrderModel? order;
  // MyStoreModel? store;
  MealVariants? variant;

  CartModel(
      {this.id,
      this.mealId,
      this.userId,
      this.quantity,
      this.newquantity,
      this.oldMealPrice,
      this.price,
      this.createdAt,
      this.updatedAt,
      this.orderId,
      this.variantId,
      this.meal,
      this.additionalItems,
      this.oldPrice,
      // this.store,
      this.variant});

  CartModel.fromJson(Map<String, dynamic> json) {
    // استخدام _toInt للحقول الرقمية الصحيحة
    id = _toInt(json['id']);
    mealId = _toInt(json['meal_id']);
    userId = _toInt(json['user_id']);
    quantity = _toInt(json['quantity']);
    
    // معالجة newquantity مع الحفاظ على المنطق الخاص بك
    newquantity = json['newquantity'] != null 
        ? _toInt(json['newquantity']) 
        : _toInt(json['quantity']);

    // استخدام _toDouble للحقول العشرية بشكل آمن
    oldMealPrice = _toDouble(json['old_meal_price']);
    price = _toDouble(json['price']);
    oldPrice = _toDouble(json['old_price']);

    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();

    orderId = _toInt(json['order_id']);
    variantId = _toInt(json['variant_id']);

    meal = json['meal'] != null ? new MealModel.fromJson(json['meal']) : null;
    
    if (json['additional_items'] != null) {
      additionalItems = <AdditionalsModel>[];
      json['additional_items'].forEach((v) {
        additionalItems!.add(new AdditionalsModel.fromJson(v));
      });
    }

    variant = json['variant'] != null
        ? new MealVariants.fromJson(json['variant'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['meal_id'] = this.mealId;
    // data['user_id'] = this.userId;
    data['quantity'] = this.quantity;
    data['newquantity'] = this.newquantity;
    data['old_meal_price'] = this.oldMealPrice;
    //data['price'] = this.price;
    data['old_price'] = this.oldPrice;
    data['variant_id'] = this.variantId;
    if (this.additionalItems != null) {
      data['additional_items'] =
          this.additionalItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  // دوال التحويل الآمنة
  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is double) return value.toInt();
    return null;
  }

  double? _toDouble(dynamic value) {
    if (value == null) return null; // عدلتها لترجع null إذا كانت القيمة null للحفاظ على دقة البيانات
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}