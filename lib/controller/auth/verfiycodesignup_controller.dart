// import 'package:go_go/core/class/statusrequest.dart';
// import 'package:go_go/core/constant/approute.dart';
// import 'package:go_go/core/functions/handingdatacontroller.dart';
// //import 'package:go_go/data/datasource/remote/auth/verfiycodesignup.dart';
// import 'package:get/get.dart';
// import 'package:go_go/data/datasource/remote/auth/verfiycodesignup.dart';

// abstract class VerifyCodeSignUpController extends GetxController {
//   checkCode();
//   goToSuccessSignUp(String verfiyCodeSignUp);
// }

// class VerifyCodeSignUpControllerImp extends VerifyCodeSignUpController {
//   VerfiyCodeSignUpData verfiyCodeSignUpData = VerfiyCodeSignUpData(Get.find());

//   String? email;

//   StatusRequest statusRequest = StatusRequest.none;

//   @override
//   checkCode() {}

//   // @override
//   // goToSuccessSignUp(String verfiyCodeSignUp) {
//   //   Get.offNamed(AppRoute.successSignUp);
//   // }

//   @override
//   goToSuccessSignUp(verfiyCodeSignUp) async {
//     statusRequest = StatusRequest.loading;
//     update();
//     var response =
//         await verfiyCodeSignUpData.postdata(email!, verfiyCodeSignUp);
//     statusRequest = handlingData(response);
//     if (StatusRequest.success == statusRequest) {
//       if (response['status'] == "success") {
//         Get.offNamed(AppRoute.successSignUp);
//       } else {
//         Get.defaultDialog(
//             title: "ُWarning", middleText: "Verify Code Not Correct");
//         statusRequest = StatusRequest.failure;
//       }
//     }
//     update();
//   }

//   @override
//   void onInit() {
//     email = Get.arguments['email'];
//     super.onInit();
//   }

//   void reSend() {}

//   // reSend() {
//   //   verfiyCodeSignUpData.resendData(email!);
//   // }
// }
