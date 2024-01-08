import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:db_homework/database/database_helper.dart';
import 'package:db_homework/models/category.dart';
import 'package:db_homework/models/course.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CourseDetailsScreen extends StatefulWidget {
  const CourseDetailsScreen({
    super.key,
    required this.course,
  });

  final Course course;

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  final DatabaseHelper db = DatabaseHelper.instance;

  List<Category> _categories = [];
  Category? selectedCategory;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  final _priceController = TextEditingController();
  final _startDateController = TextEditingController();

  DateTime? dateTime;

  bool _isLoading = false;

  Future<void> initCategories() async {
    setState(() {
      _isLoading = true;
    });

    List<Category> result = await db.getAllCategories();

    setState(() {
      selectedCategory = result.firstWhere((element) => element.id == widget.course.categoryId);
      _categories = result;

      _isLoading = false;
    });
  }

  Future<void> _onUpdate() async {
    setState(() {
      _isLoading = true;
    });

    await db.updateCourse(
      Course(
        id: widget.course.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        date: dateTime!.millisecondsSinceEpoch,
        duration: double.parse(_durationController.text.trim()),
        price: double.parse(_priceController.text.trim()),
        categoryId: selectedCategory!.id,
        teacherEmail: widget.course.teacherEmail,
      ),
    );

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    dateTime = DateTime.fromMicrosecondsSinceEpoch(widget.course.date);

    _titleController.text = widget.course.title;
    _descriptionController.text = widget.course.description ?? '';
    _durationController.text = widget.course.duration.toString();
    _priceController.text = widget.course.price.toString();
    _startDateController.text = widget.course.date.toString();

    initCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
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
                  hint: Text(
                    'Category',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
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
                          color: Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: _onUpdate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                  child: Text(
                    'Update',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
