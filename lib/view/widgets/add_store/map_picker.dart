import 'package:flutter/material.dart';

class MapPicker extends StatelessWidget {
  final Map<String, double> location;
  final Function(Map<String, double>) onPick;

  const MapPicker({Key? key, required this.location, required this.onPick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('الموقع: (${location['lat']}, ${location['lng']})'),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => onPick({'lat': 37.7749, 'lng': -122.4194}),
          child: const Text('حدد الموقع على الخريطة'),
        ),
      ],
    );
  }
}
