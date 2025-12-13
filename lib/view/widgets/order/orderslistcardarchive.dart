// import 'package:go_go/controller/orders/archive_controller.dart';
// import 'package:go_go/core/constant/approute.dart';
// import 'package:go_go/core/constant/color.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class CardOrdersListArchive extends GetView<OrdersArchiveController> {
//   // final OrdersModel listdata;

//   const CardOrdersListArchive();

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Container(
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Text(
//                       "Order Number :1"
//                       // #${listdata.ordersId}"
//                       ,
//                       style: const TextStyle(
//                           fontSize: 18, fontWeight: FontWeight.bold)),
//                   const Spacer(),
//                   Text(
//                     "3 days ago",
//                     //Jiffy.parse(listdata.ordersDatetime!).fromNow(),
//                     style: const TextStyle(
//                         color: AppColor.primaryColor,
//                         fontWeight: FontWeight.bold),
//                   )
//                 ],
//               ),
//               const Divider(),
//               Text("Order Type : ${controller.printOrderType('0')}"),
//               Text("Order Price : 600 \$"),
//               Text("Delivery Price : 10 \$ "),
//               Text("Payment Method : ${controller.printPaymentMethod('1')} "),
//               Text("Order Status : ${controller.printOrderStatus('0')} "),
//               const Divider(),
//               Row(
//                 children: [
//                   Text("Total Price : 610 \$ ",
//                       style: const TextStyle(
//                           color: AppColor.primaryColor,
//                           fontWeight: FontWeight.bold)),
//                   const Spacer(),
//                   MaterialButton(
//                     onPressed: () {
//                       Get.toNamed(
//                         AppRoute.ordersdetails,
//                         // arguments: {"ordersmodel": listdata}
//                       );
//                     },
//                     color: AppColor.thirdColor,
//                     textColor: AppColor.secondColor,
//                     child: const Text("Details"),
//                   ),
//                 ],
//               ),
//             ],
//           )),
//     );
//   }
// }
