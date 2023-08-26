import 'package:flutter/material.dart';

class AdditionalInputFields extends StatelessWidget {
  const AdditionalInputFields({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Story Point',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: ['1', '2', '3', '5', '8'].map((point) {
                return DropdownMenuItem<String>(
                  value: point,
                  child: Text(point),
                );
              }).toList(),
              onChanged: (selectedPoint) {
                // Handle the selected story point
              },
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
              onChanged: (selectedPriority) {
                // Handle the selected priority
              },
            ),
          ),
        ],
      ),
    );
  }
}
