// import 'package:go_go/data/model/cart/cart_model.dart';
// import 'package:go_go/data/model/coupon_model.dart';

// class DeliveryModel {
//   int? id;
//   int? userId;
//   String? address;
//   String? status;
//   String? notes;
//   String? x;
//   String? y;
//   String? price;

//   int? deliveryId;

//   String? deliveryPrice;
//   int? couponId;
//   int? discount;
//   String? totalPrice;
//   String? paymentMethod;
//   String? isPaid;
//   String? createdAt;
//   String? updatedAt;
//   String? deleteReason;
//   List<CartModel>? carts;
//   CouponModel? coupon;
//   int? oldCartCount;
//   String? calculatedtotalprice;

//   DeliveryModel(
//       {this.id,
//       this.userId,
//       this.status,
//       this.notes,
//       this.address,
//       this.x,
//       this.y,
//       this.price,
//       this.deliveryPrice,
//       this.deliveryId,
//       this.couponId,
//       this.couponName,
//       this.discount,
//       this.totalPrice,
//       this.paymentMethod,
//       this.isPaid,
//       this.cartCount,
//       this.deleteReason,
//       this.isEditing,
//       this.editingStartedAt,
//       this.deletedAt,
//       this.createdAt,
//       this.updatedAt,
//       this.linkedOrderId,
//       this.totalBeforeDiscount,
//       this.calculatedTotalPrice,
//       this.carts});

//   DeliveryModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     userId = json['user_id'];
//     status = json['status'];
//     notes = json['notes'];
//     address = json['address'];
//     x = json['x'];
//     y = json['y'];
//     price = json['price'];
//     deliveryPrice = json['delivery_price'];
//     deliveryId = json['delivery_id'];
//     couponId = json['coupon_id'];
//     couponName = json['coupon_name'];
//     discount = json['discount'];
//     totalPrice = json['total_price'];
//     paymentMethod = json['payment_method'];
//     isPaid = json['is_paid'];
//     cartCount = json['cart_count'];
//     deleteReason = json['delete_reason'];
//     isEditing = json['is_editing'];
//     editingStartedAt = json['editing_started_at'];
//     deletedAt = json['deleted_at'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     linkedOrderId = json['linked_order_id'];
//     totalBeforeDiscount = json['total_before_discount'];
//     calculatedTotalPrice = json['calculated_total_price'];
//     if (json['carts'] != null) {
//       carts = <Carts>[];
//       json['carts'].forEach((v) {
//         carts!.add(new Carts.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['user_id'] = this.userId;
//     data['status'] = this.status;
//     data['notes'] = this.notes;
//     data['address'] = this.address;
//     data['x'] = this.x;
//     data['y'] = this.y;
//     data['price'] = this.price;
//     data['delivery_price'] = this.deliveryPrice;
//     data['delivery_id'] = this.deliveryId;
//     data['coupon_id'] = this.couponId;
//     data['coupon_name'] = this.couponName;
//     data['discount'] = this.discount;
//     data['total_price'] = this.totalPrice;
//     data['payment_method'] = this.paymentMethod;
//     data['is_paid'] = this.isPaid;
//     data['cart_count'] = this.cartCount;
//     data['delete_reason'] = this.deleteReason;
//     data['is_editing'] = this.isEditing;
//     data['editing_started_at'] = this.editingStartedAt;
//     data['deleted_at'] = this.deletedAt;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['linked_order_id'] = this.linkedOrderId;
//     data['total_before_discount'] = this.totalBeforeDiscount;
//     data['calculated_total_price'] = this.calculatedTotalPrice;
//     if (this.carts != null) {
//       data['carts'] = this.carts!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
