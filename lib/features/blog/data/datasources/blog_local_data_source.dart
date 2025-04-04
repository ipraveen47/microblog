import 'package:hive/hive.dart';
import 'package:microblog/features/blog/data/models/blog_model.dart';

abstract interface class BlogLocalDataSource {
  void uploadLocalBlogs({required List<BlogModel> blogs});
  List<BlogModel> loadBlogs();
}

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final Box box;
  BlogLocalDataSourceImpl(this.box);

  @override
  void uploadLocalBlogs({required List<BlogModel> blogs}) async {
    await box.clear(); // Clears the box before saving new data

    for (int i = 0; i < blogs.length; i++) {
      await box.put(i.toString(), blogs[i].toJson());
    }
  }

  @override
  List<BlogModel> loadBlogs() {
    List<BlogModel> blogs = [];

    for (int i = 0; i < box.length; i++) {
      final data = box.get(i.toString());

      if (data != null && data is Map<String, dynamic>) {
        blogs.add(BlogModel.fromJson(data));
      } else if (data != null && data is Map) {
        // fallback in case Hive returns a Map instead of Map<String, dynamic>
        blogs.add(BlogModel.fromJson(Map<String, dynamic>.from(data)));
      }
    }

    return blogs;
  }
}
