import 'package:flutter/material.dart';

class AdditionalProductItem extends StatelessWidget {
  final String title;
  const AdditionalProductItem({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8, color: Colors.grey),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          const Spacer(),
          const Icon(Icons.add, size: 18, color: Colors.orange),
        ],
      ),
    );
  }
}
