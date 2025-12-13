// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';

// class LogoPicker extends StatelessWidget {
//   final String image;
//   final Function(String) onPick;

//   const LogoPicker({Key? key, required this.image, required this.onPick})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         image.isEmpty
//             ? Icon(Icons.image, size: 100, color: Colors.grey)
//             : CachedNetworkImage(
//                 imageUrl: image, height: 100, width: 100, fit: BoxFit.cover),
//         const SizedBox(height: 8),
//         ElevatedButton(
//           onPressed: () => onPick('https://example.com/logo.png'),
//           child: const Text('اختر اللوغو'),
//         ),
//       ],
//     );
//   }
// }
