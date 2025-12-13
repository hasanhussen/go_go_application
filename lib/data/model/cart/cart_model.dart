import 'package:go_go/data/model/meal/additional_model.dart';
import 'package:go_go/data/model/meal/meal_model.dart';
import 'package:go_go/data/model/my_store_model.dart';
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
    id = json['id'];
    mealId = json['meal_id'];
    userId = json['user_id'];
    quantity = json['quantity'];
    newquantity = json['newquantity'] ?? json['quantity'];
    oldMealPrice = json['old_meal_price'] != null
        ? double.tryParse(json['old_meal_price'].toString())
        : null;
    price = json['price'] != null
        ? double.tryParse(json['price'].toString())
        : null;
    oldPrice = json['old_price'] != null
        ? double.tryParse(json['old_price'].toString())
        : null;
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();

    orderId = json['order_id'];
    variantId = json['variant_id'];
    meal = json['meal'] != null ? new MealModel.fromJson(json['meal']) : null;
    if (json['additional_items'] != null) {
      additionalItems = <AdditionalsModel>[];
      json['additional_items'].forEach((v) {
        additionalItems!.add(new AdditionalsModel.fromJson(v));
      });
    }
    // store =
    //     json['store'] != null ? new MyStoreModel.fromJson(json['store']) : null;
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
    //data['created_at'] = this.createdAt;
    //data['updated_at'] = this.updatedAt;
    //data['order_id'] = this.orderId;
    // if (this.meal != null) {
    //   data['meal'] = this.meal!.toJson();
    // }
    if (this.additionalItems != null) {
      data['additional_items'] =
          this.additionalItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
