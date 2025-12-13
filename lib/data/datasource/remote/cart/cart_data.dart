import 'package:go_go/core/class/crud.dart';
import 'package:go_go/linkapi.dart';

class CartData {
  Crud crud;
  CartData(this.crud);
  getdata() async {
    var response = await crud.getData(AppLink.cartview);
    return response.fold((l) => l, (r) => r);
  }

  add(
      String orderId,
      int mealId,
      int quantity,
      List<Map<String, dynamic>> additionals,
      String oldPrice,
      String oldMealPrice,
      String? variantId) async {
    var response =
        await crud.mypostData(AppLink.cartadd + '/' + orderId.toString(), {
      "meal_id": mealId,
      "quantity": quantity,
      "additionals": additionals,
      "old_meal_price": oldMealPrice,
      "old_price": oldPrice,
      "variant_id": variantId,
    });
    return response.fold((l) => l, (r) => r);
  }

  updateItem(
      int cartId,
      int meal_id,
      int quantity,
      List<Map<String, dynamic>> additionals,
      String oldPrice,
      String oldMealPrice) async {
    var response =
        await crud.mypostData(AppLink.cartUpdate + '/' + cartId.toString(), {
      "meal_id": meal_id,
      "quantity": quantity,
      "additionals": additionals,
      "old_meal_price": oldMealPrice,
      "old_price": oldPrice
    });
    return response.fold((l) => l, (r) => r);
  }

  deleteItem(String cartId) async {
    var response = await crud.deleteData(AppLink.cartdelete + '/' + cartId);
    return response.fold((l) => l, (r) => r);
  }
}
