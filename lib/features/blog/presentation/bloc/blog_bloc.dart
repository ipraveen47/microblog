import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:microblog/core/usecase/usecase.dart';
import 'package:microblog/features/blog/domain/entity/blog.dart';
import 'package:microblog/features/blog/domain/usecases/delete_blog.dart';
import 'package:microblog/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:microblog/features/blog/domain/usecases/upload_blog.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  final DeleteBlog _deleteBlog;
  BlogBloc(
      {required UploadBlog uploadBlog,
      required GetAllBlogs getAllBlogs,
      required DeleteBlog deleteBlog})
      : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        _deleteBlog = deleteBlog,
        super(BlogInitial()) {
    on<BlogUpload>(_onBlogUpload);
    on<BlogFetchAllBlogs>(_onFetchAllBlogs);
    on<DeleteCurrentBlog>(_deletecurrentBlog);
  }

  void _deletecurrentBlog(
      DeleteCurrentBlog event, Emitter<BlogState> emit) async {
    emit(BlogLoading());
    final res = await _deleteBlog(
      DeleteBlogParms(event.blogId),
    );

    res.fold((l) => emit(BlogFailure(l.message)),
        (_) async => emit(BlogDeleteSuccess()));
    add(BlogFetchAllBlogs());
  }

  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    final res = await _uploadBlog(
      UploadBlogParms(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        image: event.image,
        topics: event.topics,
      ),
    );

    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogUploadSuccess()),
    );
  }

  void _onFetchAllBlogs(
      BlogFetchAllBlogs event, Emitter<BlogState> emit) async {
    final res = await _getAllBlogs(NoParms());

    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogDisplaySuccess(r)),
    );
  }
}
