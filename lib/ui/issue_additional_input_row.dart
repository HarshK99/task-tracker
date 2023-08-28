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
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Theme.of(context).dividerColor),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<int>(
              isExpanded: true,
              value: 1, // Set the selected value
              icon: Icon(Icons.arrow_drop_down),
              iconDisabledColor: Colors.black,
              underline: Container(),
              onChanged: (value) {
                // Call the function to update the selected story point
                onStoryPointChanged(value);
              },
              items: ['1', '2', '3', '5', '8'].map((point) {
                return DropdownMenuItem<int>(
                  value: int.parse(point),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      point,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                );
              }).toList(),
              style: TextStyle(color: Colors.black),
              itemHeight: null,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: DropdownButton<String>(
              isExpanded: true,
              value: 'High', // Set the selected value
              icon: Icon(Icons.arrow_drop_down),
              iconDisabledColor: Colors.black,
              underline: Container(),
              onChanged: (value) {
                // Call the function to update the selected priority
                onPriorityChanged(value);
              },
              items: ['Very High', 'High', 'Low'].map((priority) {
                return DropdownMenuItem<String>(
                  value: priority,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      priority,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                );
              }).toList(),
              style: TextStyle(color: Colors.black),
              itemHeight: null,
            ),
          ),
        ],
      ),
    );
  }
}
