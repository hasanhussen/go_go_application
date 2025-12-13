// // widgets/order/order_footer.dart
// import 'package:flutter/material.dart';

// class OrderFooter extends StatelessWidget {
//   const OrderFooter({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const SizedBox(height: 20),
//         ElevatedButton(
//           onPressed: () {},
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.white,
//             foregroundColor: Colors.grey,
//             side: const BorderSide(color: Colors.grey),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           ),
//           child: const Text("اضف كوبون"),
//         ),
//         const SizedBox(height: 20),
//         Container(
//           color: Colors.red,
//           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//           child: Row(
//             children: const [
//               Text("التالي", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//               Spacer(),
//               Text("22 ريال", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
