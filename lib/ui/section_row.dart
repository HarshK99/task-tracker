import 'package:flutter/material.dart';

class SectionRow extends StatelessWidget {
  final List<String> sections;
  final int currentSectionIndex;
  final Function(String) addSection;
  final Function(int) switchSection;

  const SectionRow({
    required this.sections,
    required this.currentSectionIndex,
    required this.addSection,
    required this.switchSection,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController _sectionController = TextEditingController();

    return Container(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: sections.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == sections.length) {
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Add Section'),
                      content: TextField(
                        controller: _sectionController,
                        decoration: const InputDecoration(
                          hintText: 'Enter a section',
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Add'),
                          onPressed: () {
                            String sectionName = _sectionController.text;
                            addSection(sectionName);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(Icons.add),
              ),
            );
          }

          return GestureDetector(
            onTap: () {
              switchSection(index);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: index == currentSectionIndex
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                sections[index],
                style: TextStyle(
                  color: index == currentSectionIndex
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
