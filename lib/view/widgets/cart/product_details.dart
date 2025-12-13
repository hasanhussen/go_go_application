// import 'package:flutter/material.dart';

// class ProductDetails extends StatelessWidget {
//   const ProductDetails();

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         ClipRRect(
//           borderRadius: BorderRadius.circular(8),
//           child: Image.asset(
//             "assets/images/fries.png",
//             height: 80,
//             width: 80,
//             fit: BoxFit.cover,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "كرسيم تشيكن",
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey[800],
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 "كرسيم تشيكن مبلي",
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey[600],
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                 decoration: BoxDecoration(
//                   color: Colors.green[50],
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: Text(
//                   "سعودي %100",
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.green[800],
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Text(
//               "15 ر.س",
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.orange[800],
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Icon(
//               Icons.add_circle,
//               color: Colors.orange,
//               size: 28,
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
