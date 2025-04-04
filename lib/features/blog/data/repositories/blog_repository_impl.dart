import 'dart:developer';
import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:microblog/core/error/exceptions.dart';
import 'package:microblog/core/error/failures.dart';
import 'package:microblog/core/network/connection_checker.dart';
import 'package:microblog/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:microblog/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:microblog/features/blog/data/models/blog_model.dart';
import 'package:microblog/features/blog/domain/entity/blog.dart';
import 'package:microblog/features/blog/domain/repositories/blog_repository.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/constants.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  final BlogLocalDataSource blogLocalDataSource;
  final ConnectionChecker connectionChecker;
  BlogRepositoryImpl(this.blogRemoteDataSource, this.blogLocalDataSource,
      this.connectionChecker);
  @override
  Future<Either<Failures, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failures(Constants.noConnection));
      }
      String blogId = const Uuid().v4();
      log("Generated UUID: $blogId"); // Debugging UUID output
      log("Poster ID: $posterId");

      BlogModel blogModel = BlogModel(
        id: const Uuid().v4().toString(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
      );
      final imageUrl = await blogRemoteDataSource.uploadBlogImage(
        image: image,
        blog: blogModel,
      );

      blogModel = blogModel.copyWith(
        imageUrl: imageUrl,
      );

      final uploadedblog = await blogRemoteDataSource.uploadBlog(blogModel);
      return right(uploadedblog);
    } on ServerExceptions catch (e) {
      return Left(Failures(e.message));
    }
  }

  @override
  Future<Either<Failures, List<Blog>>> getAllBlogs() async {
    try {
      if (!await connectionChecker.isConnected) {
        final blogs = blogLocalDataSource.loadBlogs();
        return right(blogs);
      }
      final blogs = await blogRemoteDataSource.getAllBlogs();
      blogLocalDataSource.uploadLocalBlogs(blogs: blogs);
      return right(blogs);
    } on ServerExceptions catch (e) {
      return left((Failures(e.message)));
    }
  }
}
