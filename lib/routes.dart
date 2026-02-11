import 'package:go_go/core/constant/approute.dart';
import 'package:go_go/core/middleware/mymiddleware.dart';
import 'package:get/get.dart';
import 'package:go_go/view/screen/about_contact_screen.dart';
import 'package:go_go/view/screen/add_meal.dart';
import 'package:go_go/view/screen/cart/edit_cart_item.dart';
import 'package:go_go/view/screen/deletedAccountScreen.dart';
import 'package:go_go/view/screen/edit_meal.dart';
import 'package:go_go/view/screen/followed_stores.dart';
import 'package:go_go/view/screen/meal_trashed.dart';
import 'package:go_go/view/screen/my_delivery_screen.dart';
import 'package:go_go/view/screen/my_stores_screen.dart';
import 'package:go_go/view/screen/add_store_screen.dart';
import 'package:go_go/view/screen/auth/forgetpassword/forgetpassword.dart';
import 'package:go_go/view/screen/auth/forgetpassword/resetpassword.dart';
import 'package:go_go/view/screen/auth/forgetpassword/success_resetpassword.dart';
import 'package:go_go/view/screen/auth/forgetpassword/verifycode.dart';
import 'package:go_go/view/screen/auth/login.dart';
import 'package:go_go/view/screen/auth/signup.dart';
import 'package:go_go/view/screen/edit_profile.dart';
import 'package:go_go/view/screen/edit_store_screen.dart';
import 'package:go_go/view/screen/homepage.dart';
import 'package:go_go/view/screen/homescreen.dart';
import 'package:go_go/view/screen/cart/cart.dart';
import 'package:go_go/view/screen/orders/archive.dart';
import 'package:go_go/view/screen/orders/old_details.dart';
import 'package:go_go/view/screen/orders/check_out.dart';
import 'package:go_go/view/screen/orders/pending.dart';
import 'package:go_go/view/screen/resturant_list_screen.dart';
import 'package:go_go/view/screen/resturant_profile.dart';
import 'package:go_go/view/screen/splash_screen.dart';
import 'package:go_go/view/screen/support_page.dart';
import 'package:go_go/view/screen/welcome_screen.dart';
import 'package:go_go/view/screen/language_edit.dart';
import 'package:go_go/view/widgets/profile/wallet.dart';

List<GetPage<dynamic>>? routes = [
  GetPage(
      name: "/", page: () => SplashView()),
  GetPage(
      name: "/welcome", page: () => WelcomeScreen(), middlewares: [MyMiddleWare()]),
  GetPage(name: AppRoute.signUp, page: () => SignUp()),
  GetPage(name: AppRoute.login, page: () => Login()),
  GetPage(name: AppRoute.forgetPassword, page: () => const ForgetPassword()),
  GetPage(name: AppRoute.verfiyCode, page: () => const VerfiyCode()),
  GetPage(name: AppRoute.resetPassword, page: () => const ResetPassword()),
  GetPage(
      name: AppRoute.successResetpassword,
      page: () => const SuccessResetPassword()),
  GetPage(name: AppRoute.homepage, page: () => HomePage()),
  GetPage(name: AppRoute.homescreen, page: () => HomeScreen()),
  GetPage(name: AppRoute.editProfile, page: () => EditProfileScreen()),
  GetPage(name: AppRoute.wallet, page: () => Wallet()),
  GetPage(name: AppRoute.language, page: () => LanguageEdit()),
  GetPage(name: AppRoute.resturantList, page: () => RestaurantListScreen()),
  GetPage(name: AppRoute.resturantprofile, page: () => RestaurantProfile()),
  GetPage(name: AppRoute.cart, page: () => Cart()),
  GetPage(name: AppRoute.editcart, page: () => EditCartItem()),
  GetPage(name: AppRoute.orderspending, page: () => OrdersPending()),
  GetPage(name: AppRoute.ordersdetails, page: () => const OrdersDetails()),
  GetPage(name: AppRoute.ordersarchive, page: () => const OrdersArchice()),
  GetPage(name: AppRoute.checkout, page: () => CheckoutScreen()),
  GetPage(name: AppRoute.addStore, page: () => const AddStoreScreen()),
  GetPage(name: AppRoute.myStoresScreen, page: () => const MyStoresScreen()),
  GetPage(name: AppRoute.editstores, page: () => const EditStoreScreen()),
  GetPage(name: AppRoute.addMealView, page: () => AddMealView()),
  GetPage(name: AppRoute.editMealView, page: () => EditMealView()),
  GetPage(name: AppRoute.mealTrashScreen, page: () => MealTrashScreen()),
  GetPage(
      name: AppRoute.deletedAccountScreen, page: () => DeletedAccountScreen()),
  GetPage(name: AppRoute.supportPage, page: () => SupportPage()),
  GetPage(name: AppRoute.aboutContactScreen, page: () => AboutContactScreen()),
  GetPage(name: AppRoute.myDeliverScreen, page: () => const MyDeliveryScreen()),
  GetPage(name: AppRoute.followedStores, page: () => FollowedStores()),
];
