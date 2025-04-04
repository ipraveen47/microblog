import 'package:fpdart/fpdart.dart';
import 'package:microblog/core/error/failures.dart';
import 'package:microblog/core/usecase/usecase.dart';
import 'package:microblog/features/blog/domain/entity/blog.dart';

import '../repositories/blog_repository.dart';

class GetAllBlogs implements UseCase<List<Blog>, NoParms> {
  final BlogRepository blogReposotory;
  GetAllBlogs(this.blogReposotory);
  @override
  Future<Either<Failures, List<Blog>>> call(NoParms parms) async {
    return await blogReposotory.getAllBlogs();
  }
}
