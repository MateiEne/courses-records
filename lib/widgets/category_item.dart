import 'package:db_homework/models/category.dart';
import 'package:db_homework/screens/category_courses.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class CategoryItemWidget extends StatelessWidget {
  const CategoryItemWidget({
    super.key,
    required this.category,
  });

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Card(
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
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return const CategoryCourses();
              },
            ),
          );
        },
        splashColor: Theme.of(context).primaryColor,
        child: Stack(
          children: [
            FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(category.imageUrl),
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 44,
                ),
                color: Colors.black54,
                child: ListTile(
                  title: Text(category.title),
                  subtitle: Text(category.description ?? ''),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
