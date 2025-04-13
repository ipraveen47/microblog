import 'package:fpdart/fpdart.dart';
import 'package:microblog/core/error/failures.dart';
import 'package:microblog/core/usecase/usecase.dart';
import 'package:microblog/features/blog/domain/repositories/blog_repository.dart';

class DeleteBlog implements UseCase<void, DeleteBlogParms> {
  final BlogRepository blogRepository;

  DeleteBlog(this.blogRepository);
  @override
  Future<Either<Failures, void>> call(DeleteBlogParms parms) async {
    return await blogRepository.deleteBlog(parms.blogId);
  }
}

class DeleteBlogParms {
  final String blogId;
  DeleteBlogParms(this.blogId);
}
