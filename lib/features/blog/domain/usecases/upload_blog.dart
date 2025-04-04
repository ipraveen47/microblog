import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:microblog/core/error/failures.dart';
import 'package:microblog/core/usecase/usecase.dart';
import 'package:microblog/features/blog/domain/entity/blog.dart';
import 'package:microblog/features/blog/domain/repositories/blog_repository.dart';

class UploadBlog implements UseCase<Blog, UploadBlogParms> {
  final BlogRepository blogRepository;

  UploadBlog(this.blogRepository);

  @override
  Future<Either<Failures, Blog>> call(UploadBlogParms parms) async {
    return await blogRepository.uploadBlog(
      image: parms.image,
      title: parms.title,
      content: parms.content,
      posterId: parms.posterId,
      topics: parms.topics,
    );
  }
}

class UploadBlogParms {
  final String posterId;
  final String title;
  final String content;
  final File image;
  final List<String> topics;

  UploadBlogParms({
    required this.posterId,
    required this.title,
    required this.content,
    required this.image,
    required this.topics,
  });
}
