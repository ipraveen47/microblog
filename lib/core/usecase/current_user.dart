import 'package:fpdart/fpdart.dart';
import 'package:microblog/core/error/failures.dart';
import 'package:microblog/core/usecase/usecase.dart';
import 'package:microblog/core/common/entities/user.dart';
import 'package:microblog/features/auth/domain/repository/auth_repository.dart';

class CurrentUser implements UseCase<User, NoParms> {
  final AuthRepository authRepository;
  CurrentUser(this.authRepository);
  @override
  Future<Either<Failures, User>> call(parms) async {
    return await authRepository.currentUser();
  }
}
