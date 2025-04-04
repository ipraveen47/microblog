import 'package:fpdart/fpdart.dart';
import 'package:microblog/core/error/failures.dart';
import 'package:microblog/core/usecase/usecase.dart';
import 'package:microblog/core/common/entities/user.dart';
import 'package:microblog/features/auth/domain/repository/auth_repository.dart';

class UserSignUp implements UseCase<User, UserSignUpParms> {
  final AuthRepository authRepository;

  UserSignUp(this.authRepository);
  @override
  Future<Either<Failures, User>> call(UserSignUpParms parms) async {
    return await authRepository.signUpWithEmailPassword(
      name: parms.name,
      email: parms.email,
      password: parms.password,
    );
  }
}

class UserSignUpParms {
  final String email;
  final String password;
  final String name;

  UserSignUpParms({
    required this.email,
    required this.password,
    required this.name,
  });
}
