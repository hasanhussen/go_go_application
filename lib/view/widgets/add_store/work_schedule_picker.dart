import 'package:flutter/material.dart';

class WorkSchedulePicker extends StatelessWidget {
  final Map<String, String> schedule;
  final Function(Map<String, String>) onChanged;

  const WorkSchedulePicker(
      {Key? key, required this.schedule, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text('أيام العمل:'),
            TextButton(
              onPressed: () {
                onChanged({'السبت': 'مفتوح دائمًا'});
              },
              child: const Text('مفتوح دائمًا'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (schedule.isNotEmpty)
          Text(
              'الجدول: ${schedule.entries.map((e) => '${e.key}: ${e.value}').join(', ')}'),
      ],
    );
  }
}
