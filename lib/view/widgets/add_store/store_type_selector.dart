import 'package:flutter/material.dart';

class StoreTypeSelector extends StatelessWidget {
  final String selectedType;
  final Function(String) onSelect;

  const StoreTypeSelector(
      {Key? key, required this.selectedType, required this.onSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildOption('مطعم'),
          _buildOption('مخبز'),
          _buildOption('محل تجميل'),
          _buildOption('متجر الكتروني'),
        ],
      ),
    );
  }

  Widget _buildOption(String type) {
    return InkWell(
      onTap: () => onSelect(type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: selectedType == type ? Colors.red : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red),
        ),
        child: Text(
          type,
          style: TextStyle(
            color: selectedType == type ? Colors.white : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
