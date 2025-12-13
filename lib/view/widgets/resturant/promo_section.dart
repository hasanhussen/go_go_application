import 'package:flutter/material.dart';

class PromoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF7DCE94), // لون نعناعي أنيق
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.card_giftcard, color: Colors.white),
          const SizedBox(width: 12),
          const Expanded(
            child: Text('100% Cashback! Code KA100',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Terms', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
