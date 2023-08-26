import 'package:flutter/material.dart';

class AdditionalInputFields extends StatelessWidget {
  const AdditionalInputFields({
    Key? key,
    required this.onStoryPointChanged,
    required this.onPriorityChanged,
  }) : super(key: key);

  final void Function(int?) onStoryPointChanged;
  final void Function(String?) onPriorityChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: 'Story Point',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: ['1', '2', '3', '5', '8'].map((point) {
                return DropdownMenuItem<int>(
                  value: int.parse(point),
                  child: Text(point),
                );
              }).toList(),
              onChanged: onStoryPointChanged, // Call the callback
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: ['Very High', 'High', 'Low'].map((priority) {
                return DropdownMenuItem<String>(
                  value: priority,
                  child: Text(priority),
                );
              }).toList(),
              onChanged: onPriorityChanged, // Call the callback
            ),
          ),
        ],
      ),
    );
  }
}
