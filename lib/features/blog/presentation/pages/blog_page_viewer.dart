import 'package:flutter/material.dart';
import 'package:microblog/core/utils/calculate_reading_time.dart';
import 'package:microblog/core/utils/format_date.dart';
import 'package:microblog/features/blog/domain/entity/blog.dart';

class BlogPageViewer extends StatelessWidget {
  static route(Blog blog) => MaterialPageRoute(
      builder: (context) => BlogPageViewer(
            blog: blog,
          ));
  final Blog blog;
  const BlogPageViewer({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blog.title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'By ${blog.posterName}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 15),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                    '${formatDateByMMMYYYY(blog.updatedAt)} . ${calculateReadingTime(blog.content)} min'),
                const SizedBox(
                  height: 20,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(blog.imageUrl),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  blog.content,
                  style: TextStyle(fontSize: 16, height: 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
