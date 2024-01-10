import 'package:db_homework/database/database_helper.dart';
import 'package:db_homework/models/category.dart';
import 'package:db_homework/models/teacher.dart';
import 'package:db_homework/screens/category_courses.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class CategoryItemWidget extends StatefulWidget {
  const CategoryItemWidget({
    super.key,
    required this.category,
    required this.studentEmail,
    this.showCheckMark,
  });

  final Category category;
  final String studentEmail;
  final bool? showCheckMark;

  @override
  State<CategoryItemWidget> createState() => _CategoryItemWidgetState();
}

class _CategoryItemWidgetState extends State<CategoryItemWidget> {
  final DatabaseHelper db = DatabaseHelper.instance;

  List<Teacher> teachers = [];

  Future<void> initTeachers() async {
    List<Teacher> result = await db.getAllTeachersFromCategory(
      categoryId: widget.category.id,
    );

    setState(() {
      teachers = result;
    });
  }

  @override
  void initState() {
    super.initState();

    initTeachers();
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      child: ScrollOnExpand(
        child: Card(
          margin: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 6,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.hardEdge,
          elevation: 2,
          child: InkWell(
            onTap: () {
              if (context.mounted) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return CategoryCourses(
                        category: widget.category,
                        studentEmail: widget.studentEmail,
                      );
                    },
                  ),
                );
              }
            },
            splashColor: Theme.of(context).primaryColor,
            child: Column(
              children: [
                Stack(
                  children: [
                    FadeInImage(
                      placeholder: MemoryImage(kTransparentImage),
                      image: NetworkImage(widget.category.imageUrl),
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                    ),
                    if (widget.showCheckMark ?? false)
                      const Positioned(
                        top: 10,
                        right: 10,
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 50,
                        ),
                      ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 44,
                              ),
                              color: Colors.black54,
                              child: ListTile(
                                title: Text(widget.category.title),
                                subtitle: Text(widget.category.description ?? ''),
                              ),
                            ),
                          ),
                          Builder(
                            builder: (context) {
                              final controller = ExpandableController.of(context, required: true);
                              return IconButton(
                                onPressed: () {
                                  controller.toggle();
                                },
                                icon: Icon(
                                  controller!.expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expandable(
                  collapsed: Container(),
                  expanded: Container(
                    height: 400,
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 44,
                    ),
                    color: Colors.black54,
                    child: ListView.builder(
                      itemCount: teachers.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            '${teachers[index].firstName} ${teachers[index].lastName}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            teachers[index].email,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
