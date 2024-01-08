import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:db_homework/database/database_helper.dart';
import 'package:db_homework/models/category.dart';
import 'package:db_homework/models/course.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddCourseWidget extends StatefulWidget {
  const AddCourseWidget({
    super.key,
    required this.teacherEmail,
  });

  final String teacherEmail;

  @override
  State<AddCourseWidget> createState() => _AddCourseWidgetState();
}

class _AddCourseWidgetState extends State<AddCourseWidget> {
  final DatabaseHelper db = DatabaseHelper.instance;

  List<Category> _categories = [];
  Category? selectedCategory;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  final _priceController = TextEditingController();
  final _startDateController = TextEditingController();

  DateTime? dateTime;

  Future<void> initCategories() async {
    List<Category> result = await db.getAllCategories();

    setState(() {
      _categories = result;
    });
  }

  @override
  void initState() {
    super.initState();

    initCategories();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add course'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: 'Title',
              hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              hintText: 'Description',
              hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          TextField(
            controller: _durationController,
            decoration: InputDecoration(
              hintText: 'Duration',
              hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _priceController,
            decoration: InputDecoration(
              hintText: 'Price',
              hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          DateTimeField(
            controller: _startDateController,
            decoration: InputDecoration(
              hintText: 'Start date',
              hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            format: DateFormat("yyyy-MM-dd HH:mm"),
            onShowPicker: (context, currentValue) async {
              DateTime? dateTime = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(2100),
              ).then(
                (DateTime? date) async {
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                    );
                    return DateTimeField.combine(date, time);
                  } else {
                    return currentValue;
                  }
                },
              );

              setState(() {
                this.dateTime = dateTime;
              });

              return dateTime;
            },
          ),
          DropdownButtonFormField<Category>(
            isExpanded: true,
            value: selectedCategory,
            hint: Text('Category'),
            onChanged: (newValue) {
              setState(() {
                selectedCategory = newValue!;
              });
            },
            items: _categories.map<DropdownMenuItem<Category>>((Category category) {
              return DropdownMenuItem<Category>(
                value: category,
                child: Text(
                  category.title,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            print(dateTime);

            db.insertCourse(
              title: _titleController.text,
              description: _descriptionController.text,
              duration: double.parse(_durationController.text),
              price: double.parse(_priceController.text),
              date: dateTime!.millisecondsSinceEpoch,
              categoryId: selectedCategory!.id,
              teacherEmail: widget.teacherEmail,
            );

            Navigator.of(context).pop();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
