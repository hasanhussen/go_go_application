import 'package:flutter/material.dart';

class LocationSection extends StatelessWidget {
  final int distance;

  const LocationSection({super.key, required this.distance});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.access_time, color: Colors.grey),
      title: const Text('Ready in 5 - 20 Mins'),
      subtitle: Row(
        children: [
          const Icon(Icons.location_on, size: 16, color: Colors.grey),
          const SizedBox(width: 4),
          Text('13min distance', style: TextStyle(color: Colors.grey[700])),
          const Spacer(),
          TextButton(onPressed: () {}, child: const Text('Change')),
        ],
      ),
    );
  }
}
