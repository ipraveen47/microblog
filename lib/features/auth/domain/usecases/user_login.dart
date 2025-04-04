import 'package:fpdart/fpdart.dart';
import 'package:microblog/core/error/failures.dart';
import 'package:microblog/core/usecase/usecase.dart';
import 'package:microblog/core/common/entities/user.dart';
import 'package:microblog/features/auth/domain/repository/auth_repository.dart';

class UserLogin implements UseCase<User, UserLoginParms> {
  final AuthRepository authRepository;
  const UserLogin(this.authRepository);
  @override
  Future<Either<Failures, User>> call(parms) async {
    return authRepository.loginWithEmailPassword(
        email: parms.email, password: parms.password);
  }
}

class UserLoginParms {
  final String email;
  final String password;

  UserLoginParms({
    required this.email,
    required this.password,
  });
}
