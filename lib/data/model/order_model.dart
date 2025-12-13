import 'package:go_go/data/model/cart/cart_model.dart';
import 'package:go_go/data/model/coupon_model.dart';

class OrderModel {
  int? id;
  int? userId;
  String? address;
  String? status;
  String? notes;
  String? x;
  String? y;
  String? price;
  String? deliveryPrice;
  int? couponId;
  int? discount;
  String? totalPrice;
  String? paymentMethod;
  String? isPaid;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? deleteReason;
  List<CartModel>? carts;
  CouponModel? coupon;
  int? oldCartCount;
  String? calculatedtotalprice;

  OrderModel(
      {this.id,
      this.userId,
      this.address,
      this.status,
      this.notes,
      this.x,
      this.y,
      this.price,
      this.deliveryPrice,
      this.couponId,
      this.discount,
      this.totalPrice,
      this.paymentMethod,
      this.isPaid,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.deleteReason,
      this.carts,
      this.coupon,
      this.oldCartCount,
      this.calculatedtotalprice});

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    address = json['address'];
    status = json['status'];
    notes = json['notes'];
    x = json['x'];
    y = json['y'];
    price = json['price'];
    deliveryPrice = json['delivery_price'];
    couponId = json['coupon_id'];
    discount = json['discount'];
    totalPrice = json['total_price'];
    paymentMethod = json['payment_method'];
    isPaid = json['is_paid'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    deleteReason = json['delete_reason'];
    if (json['carts'] != null) {
      carts = <CartModel>[];
      json['carts'].forEach((v) {
        carts!.add(new CartModel.fromJson(v));
      });
    }
    coupon = json['coupon'] != null
        ? new CouponModel.fromJson(json['coupon'])
        : null;
    oldCartCount = json['cart_count'] ?? 0;
    calculatedtotalprice = json['calculated_total_price'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['address'] = this.address;
    data['status'] = this.status;
    data['notes'] = this.notes;
    data['x'] = this.x;
    data['y'] = this.y;
    data['price'] = this.price;
    data['delivery_price'] = this.deliveryPrice;
    data['coupon_id'] = this.couponId;
    data['discount'] = this.discount;
    data['total_price'] = this.totalPrice;
    data['payment_method'] = this.paymentMethod;
    data['is_paid'] = this.isPaid;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.carts != null) {
      data['carts'] = this.carts!.map((v) => v.toJson()).toList();
    }
    if (this.coupon != null) {
      data['coupon'] = this.coupon!.toJson();
    }
    data['cart_count'] = this.oldCartCount;
    data['calculated_total_price'] = this.calculatedtotalprice;
    return data;
  }
}
