import 'package:flutter/material.dart';
import '../models/item.dart';
import '../widgets/message.dart';
import '../widgets/text_box.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<StatefulWidget> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  late TextEditingController dateController;
  late TextEditingController typeController;
  late TextEditingController durationController;
  late TextEditingController priorityController;
  late TextEditingController categoryController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    dateController = TextEditingController();
    descriptionController = TextEditingController();
    typeController = TextEditingController();
    categoryController = TextEditingController();
    durationController = TextEditingController();
    priorityController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: ListView(
        children: [
          TextBox(dateController, 'Date'),
          TextBox(descriptionController, 'Description'),
          TextBox(typeController, 'Type'),
          TextBox(categoryController, 'Category'),
          TextBox(durationController, 'Duration'),
          TextBox(priorityController, 'Priority'),
          ElevatedButton(
              onPressed: () {
                String date = dateController.text;
                String description = descriptionController.text;
                String type = typeController.text;
                String category = categoryController.text;
                String priority = priorityController.text;
                double? duration = double.tryParse(durationController.text);
                if (date.isNotEmpty &&
                    validateDate(date) &&
                    description.isNotEmpty &&
                    type.isNotEmpty &&
                    category.isNotEmpty &&
                    priority.isNotEmpty &&
                    duration != null) {
                  Navigator.pop(
                      context,
                      Item(
                          date: date,
                          type: type,
                          priority: priority,
                          duration: duration,
                          category: category,
                          description: description));
                } else {
                  if (date.isEmpty) {
                    message(context, 'Name is required', "Error");
                  } else if (description.isEmpty) {
                    message(context, 'Description is required', "Error");
                  } else if (type.isEmpty) {
                    message(context, 'Type is required', "Error");
                  } else if (category.isEmpty) {
                    message(context, 'Category is required', "Error");
                  } else if (duration == null) {
                    message(context, 'Duration must be an integer', "Error");
                  } else if (priority.isEmpty) {
                    message(context, 'Priority is required', "Error");
                  }
                }
              },
              child: const Text('Save'))
        ],
      ),
    );
  }

  bool validateDate(String date) {
    // date is yyyy-mm-dd
    RegExp regExp = RegExp(
        r'^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
    return regExp.hasMatch(date);
  }
}
