import 'package:flutter/material.dart';



class IssueInputField extends StatelessWidget {
  const IssueInputField({
    Key? key,
    required this.textEditingController,
    required this.addIssue,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final void Function() addIssue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(9.0),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    controller: textEditingController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      hintText: 'Enter Issue',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: addIssue,
              ),
            ],
          ),
        ),
        AdditionalFields(), 
      ],
    );
  }
}

class AdditionalFields extends StatelessWidget {
  const AdditionalFields({
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
