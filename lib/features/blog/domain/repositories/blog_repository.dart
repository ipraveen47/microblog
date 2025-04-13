import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:microblog/core/error/failures.dart';
import 'package:microblog/features/blog/domain/entity/blog.dart';

abstract interface class BlogRepository {
  Future<Either<Failures, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  });

  Future<Either<Failures, List<Blog>>> getAllBlogs();
  Future<Either<Failures, void>> deleteBlog(String blogId);
}
