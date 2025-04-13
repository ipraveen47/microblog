import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:microblog/core/utils/calculate_reading_time.dart';
import 'package:microblog/core/utils/show_snackbar.dart';
import 'package:microblog/features/blog/domain/entity/blog.dart';
import 'package:microblog/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:microblog/features/blog/presentation/pages/blog_page_viewer.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final Color color;
  const BlogCard({super.key, required this.blog, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, BlogPageViewer.route(blog));
      },
      child: Container(
        margin: const EdgeInsets.all(16).copyWith(bottom: 4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 215,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: blog.topics
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Chip(label: Text(e)),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Text(
                  blog.title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  blog.content,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Row(
              children: [
                Text('${calculateReadingTime(blog.content)} min'),
                IconButton(
                  onPressed: () {
                    context.read<BlogBloc>().add(DeleteCurrentBlog(blog.id));
                  },
                  icon: Icon(
                    Icons.delete,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
