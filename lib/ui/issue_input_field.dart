import 'package:flutter/material.dart';

import 'issue_additional_input_row.dart';



class IssueInputField extends StatefulWidget {
  const IssueInputField({
    Key? key,
    required this.textEditingController,
    required this.addIssue,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final void Function() addIssue;

  @override
  _IssueInputFieldState createState() => _IssueInputFieldState();
}

class _IssueInputFieldState extends State<IssueInputField> {
  bool _isAdditionalFieldsVisible = false;

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
                    controller: widget.textEditingController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      hintText: 'Enter Issue',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    ),
                    onTap: () {
                      setState(() {
                        _isAdditionalFieldsVisible = !_isAdditionalFieldsVisible;
                      });
                    },
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: widget.addIssue,
              ),
            ],
          ),
        ),
        if (_isAdditionalFieldsVisible)
          AdditionalInputFields(),
      ],
    );
  }
}
