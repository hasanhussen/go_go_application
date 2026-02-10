class AppLink {
  static const String imageststatic =
      'https://hasanhuseinprojects.site/storage';
  static const String server = 'https://hasanhuseinprojects.site/api';
//========================== Image ============================
  static const String imagestCategories = "$imageststatic/categories";
  static const String imagestItems = "$imageststatic/items";
// =============================================================
//
  static const String test = "$server/test.php";

  //static const String notification = "$server/notification.php";

// ================================= Auth ========================== //

  static const String signUp = "$server/register";
  static const String login = "$server/login";
  static const String logout = "$server/logout";
  static const String verifycodessignup = "$server/auth/verfiycode.php";
  static const String resend = "$server/auth/resend.php";

  static const String saveFcmToken = "$server/save-fcm-token";

// ================================= ForgetPassword ========================== //

  static const String checkEmail = "$server/forgot-password";
  static const String resetPassword = "$server/reset-password";
  static const String verifycodeforgetpassword = "$server/verify-code";

// Home

  static const String homepage = "$server/home.php";
  static const String profile = "$server/profile";
  static const String editProfile = "$server/updateProfile";
  static const String slider = "$server/slider";

  // stores
  // static const String myActiveStores = "$server/myActiveStores";
  // static const String myNewStores = "$server/myNewStores";
  // static const String myDeletedStores = "$server/myDeletedStores";

  static const String myStores = "$server/myStores";

  static const String addStoreModel = "$server/addstore";
  static const String editstore = "$server/editstore";
  static const String deletestore = "$server/deletestore";
  static const String profilestore = "$server/profilestore";
  static const String followstore = "$server/follow";
  static const String unfollowstore = "$server/unfollow";
  static const String checkfollowstore = "$server/checkfollow";
  static const String rateStore = "$server/rateStore";
  static const String getCategorystores = "$server/getCategorystores";
  static const String getFollowedStores = "$server/followedStores";
  static const String sendStoreAppeal = "$server/storeAppeal";

  static const String addAdditional = "$server/addAdditional";
  static const String getStoreAdditional = "$server/getStoreAdditional";
  static const String deleteadditional = "$server/deleteadditional";
  static const String editadditional = "$server/editadditional";

// items
  static const String getstoremeals = "$server/meals/getstoremeals";
  static const String getmeal = "$server/meals/getmeal";
  static const String mostSellingmeals = "$server/meals/mostSellingmeals";
  static const String getwaitingmeals = "$server/meals/getwaitingmeals";
  static const String getBanedgmeals = "$server/meals/getBanedgmeals";

  static const String addmeal = "$server/meals/addmeal";
  static const String editmeal = "$server/meals/editmeal";
  static const String deletemeal = "$server/meals/deletemeal";

  static const String gethidden = "$server/meals/gethidden";
  static const String trashedMeals = "$server/meals/trashed";
  static const String hideMeal = "$server/meals/hide";
  static const String restoreHiddenMeal = "$server/meals/restorehidden";
  static const String softDeleteMeal = "$server/meals/softdelete";
  static const String countTrashed = "$server/meals/countTrashed";
  static const String sendMealAppeal = "$server/meals/mealAppeal";
  //static const String restoreTrashedMeal = "$server/meals/restoretrashed";

  // Categories
  static const String categories = "$server/category";
  static const String notifications = "$server/getNotifications";
  static const String markAsRead = "$server/markAsRead";
  static const String markAllAsRead = "$server/markAllAsRead";

  // Cart
  static const String cartview = "$server/cart/getItems";
  static const String cartadd = "$server/cart/addItem";
  static const String cartUpdate = "$server/cart/updateItem";
  static const String cartdelete = "$server/cart/deleteItem";

  // Address

  static const String addressView = "$server/address/view.php";
  static const String addressAdd = "$server/address/add.php";
  static const String addressEdit = "$server/address/edit.php";
  static const String addressDelete = "$server/address/delete.php";

  // Coupon

  static const String checkcoupon = "$server/checkCoupon";

  // Checkout

  static const String checkout = "$server/order/add";
  static const String checkoutAfterPayment =
      "$server/payment/confirmOrderAfterPayment";

// payment
  static const String createPaymentIntent =
      "$server/payment/createPaymentIntent";

  static const String confirmOrderAfterPayment =
      "$server/payment/confirmOrderAfterPayment";

  static const String updatePaymentAmount =
      "$server/payment/updatePaymentAmount";

  static const String updatePaymentAndOrder =
      "$server/payment/updatePaymentAndOrder";

  static const String updateCard = "$server/payment/updateCard";

  static const String orders = "$server/order/getOrders";
  static const String pendingorders = "$server/order/getProcessing";
  static const String ordersarchive = "$server/order/getCompleted";
  static const String ordersRejected = "$server/order/getRejected";
  static const String ordersdetails = "$server/order/getDetails";
  static const String orderswaiting = "$server/order/getwaiting";
  static const String ordersdelete = "$server/order/delete";
  static const String ordersedit = "$server/order/update";

  static const String deliveryOrders = "$server/order/getDeliveryOrders";
  static const String pendingDeliveryorders =
      "$server/order/getDeliveryProcessing";
  static const String ordersDeliveryarchive =
      "$server/order/getDeliveryCompleted";
  static const String ordersDeliverywaiting =
      "$server/order/getDeliverywaiting";

  static const String deliveryAccept = "$server/order/deliveryAccept";
  static const String delivered = "$server/order/delivered";
  static const String deliveryOnTheWay = "$server/order/deliveryOnTheWay";
  static const String deliveryOnSite = "$server/order/deliveryOnSite";

  //support
  static const String support = "$server/support";
  static const String contactInfo = "$server/contact-info";
}
