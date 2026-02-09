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
    id = _toInt(json['id']);
    userId = _toInt(json['user_id']);
    address = json['address']?.toString();
    status = json['status']?.toString();
    notes = json['notes']?.toString();
    x = json['x']?.toString();
    y = json['y']?.toString();

    // تأمين الأسعار النصية في حال جاءت كأرقام من السيرفر
    price = json['price']?.toString();
    deliveryPrice = json['delivery_price']?.toString();
    totalPrice = json['total_price']?.toString();
    calculatedtotalprice = json['calculated_total_price']?.toString();

    couponId = _toInt(json['coupon_id']);
    discount = _toInt(json['discount']);
    paymentMethod = json['payment_method']?.toString();
    isPaid = json['is_paid']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    deletedAt = json['deleted_at']?.toString();
    deleteReason = json['delete_reason']?.toString();

    if (json['carts'] != null) {
      carts = <CartModel>[];
      json['carts'].forEach((v) {
        carts!.add(new CartModel.fromJson(v));
      });
    }

    coupon = json['coupon'] != null
        ? new CouponModel.fromJson(json['coupon'])
        : null;

    // تأمين عدد العناصر في السلة
    oldCartCount = _toInt(json['cart_count']) ?? 0;
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

  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is double) return value.toInt();
    return null;
  }
}
