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
    return Padding(
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
    );
  }
}
