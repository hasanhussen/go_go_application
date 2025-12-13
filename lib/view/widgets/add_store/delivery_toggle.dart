import 'package:flutter/material.dart';

class DeliveryToggle extends StatelessWidget {
  final bool hasDelivery;
  final bool isOnline;
  final Function(bool?) onDeliveryChanged;
  final Function(bool?) onTypeChanged;

  const DeliveryToggle({
    Key? key,
    required this.hasDelivery,
    required this.isOnline,
    required this.onDeliveryChanged,
    required this.onTypeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text('هل يوجد توصيل؟'),
            Checkbox(
              value: hasDelivery,
              onChanged: onDeliveryChanged,
            ),
          ],
        ),
        Row(
          children: [
            Text('هل هو متجر إلكتروني؟'),
            Checkbox(
              value: isOnline,
              onChanged: onTypeChanged,
            ),
          ],
        ),
      ],
    );
  }
}
