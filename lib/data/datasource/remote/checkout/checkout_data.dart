import 'package:go_go/core/class/crud.dart';
import 'package:go_go/data/model/cart/cart_model.dart';
import 'package:go_go/linkapi.dart';

class CheckoutData {
  Crud crud;
  CheckoutData(this.crud);
  confirm(
      String? notes,
      String address,
      double productsPrice,
      double deliveryPrice,
      int? couponId,
      int? discount,
      int cartcount,
      double totalPrice,
      double totalBeforeDiscount,
      int? linkedOrderId,
      String paymentMethod) async {
    try {
      Map<dynamic, dynamic> data = {
        'address': address,
        'price': productsPrice.toString(),
        'delivery_price': deliveryPrice.toString(),
        'total_price': totalPrice.toString(),
        'total_before_discount': totalBeforeDiscount.toString(),
        //'linked_order_id': linkedOrderId.toString(),
        'payment_method': paymentMethod,
        'cart_count': cartcount
      };

      if (notes != null && notes.trim().isNotEmpty) {
        data['notes'] = notes;
      }
      if (linkedOrderId != null) {
        data['linked_order_id'] = linkedOrderId;
      }
      if (couponId != null) data['coupon_id'] = couponId;
      if (discount != null) data['discount'] = discount.toString();

      var response = await crud.postDatawitherror(AppLink.checkout, data);
      return response.fold((l) => l, (r) => r);
    } catch (e) {
      print("Error in confirm: $e");
    }
  }

  confirmOrderAfterPayment(
      String? notes,
      String address,
      double productsPrice,
      double deliveryPrice,
      int? couponId,
      int? discount,
      int cartcount,
      double totalPrice,
      double totalBeforeDiscount,
      int? linkedOrderId,
      String paymentIntentId) async {
    try {
      Map<dynamic, dynamic> data = {
        'address': address,
        'price': productsPrice.toString(),
        'delivery_price': deliveryPrice.toString(),
        'total_price': totalPrice.toString(),
        'total_before_discount': totalBeforeDiscount.toString(),
        // 'linked_order_id': linkedOrderId,
        'payment_intent_id': paymentIntentId,
        // 'currency': 'usd',
        'cart_count': cartcount
      };

      if (couponId != null) {
        data['coupon_id'] = couponId;
      }

      if (linkedOrderId != null) {
        data['linked_order_id'] = linkedOrderId;
      }

// إذا عندك discount ضيفو
      if (discount != null) {
        data['discount'] = discount.toString();
      }

      if (couponId != null) {
        data['notes'] = notes;
      }

      var response =
          await crud.postDatawitherror(AppLink.checkoutAfterPayment, data);
      return response.fold((l) => l, (r) => r);
    } catch (e) {
      print("Error in confirm: $e");
    }
  }

  editdata(
      String? orderId,
      String? notes,
      String address,
      double productsPrice,
      double deliveryPrice,
      int? couponId,
      int? discount,
      int cartcount,
      double totalPrice,
      double totalBeforeDiscount,
      int? linkedOrderId,
      String paymentMethod,
      List<CartModel> cartItems) async {
    try {
      Map<dynamic, dynamic> data = {
        'address': address,
        'price': productsPrice.toString(),
        'delivery_price': deliveryPrice.toString(),
        'total_price': totalPrice.toString(),
        'total_before_discount': totalBeforeDiscount.toString(),
        //'linked_order_id': linkedOrderId.toString(),
        'payment_method': paymentMethod,
        'cart_count': cartcount,
        'cart_items': cartItems.map((item) => item.toJson()).toList(),
      };

      if (linkedOrderId != null) {
        data['linked_order_id'] = linkedOrderId;
      }

      if (notes != null && notes.trim().isNotEmpty) {
        data['notes'] = notes;
      }
      if (couponId != null) data['coupon_id'] = couponId;
      if (discount != null) data['discount'] = discount.toString();

      var response = await crud.postDatawitherror(
          AppLink.ordersedit + '/' + orderId.toString(), data);
      return response.fold((l) => l, (r) => r);
    } catch (e) {
      print("Error in confirm: $e");
    }
  }

  editdataAfterPayment(
      String? orderId,
      String? notes,
      String address,
      double productsPrice,
      double deliveryPrice,
      int? couponId,
      int? discount,
      int cartcount,
      double totalPrice,
      double totalBeforeDiscount,
      int? linkedOrderId,
      String paymentIntentId,
      List<CartModel> cartItems) async {
    try {
      Map<dynamic, dynamic> data = {
        'address': address,
        'price': productsPrice.toString(),
        'delivery_price': deliveryPrice.toString(),
        'total_price': totalPrice.toString(),
        'total_before_discount': totalBeforeDiscount.toString(),
        //'linked_order_id': linkedOrderId.toString(),
        'payment_intent_id': paymentIntentId,
        // 'currency': 'usd',
        'cart_count': cartcount,
        'cart_items': cartItems.map((item) => item.toJson()).toList(),
      };

      if (linkedOrderId != null) {
        data['linked_order_id'] = linkedOrderId;
      }

      if (notes != null && notes.trim().isNotEmpty) {
        data['notes'] = notes;
      }
      if (couponId != null) data['coupon_id'] = couponId;
      if (discount != null) data['discount'] = discount.toString();

      var response = await crud.postDatawitherror(
          AppLink.updatePaymentAndOrder + '/' + orderId.toString(), data);
      return response.fold((l) => l, (r) => r);
    } catch (e) {
      print("Error in confirm: $e");
    }
  }
}
