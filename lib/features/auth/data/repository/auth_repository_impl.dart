import 'package:fpdart/fpdart.dart';
import 'package:microblog/core/constants/constants.dart';
import 'package:microblog/core/error/exceptions.dart';
import 'package:microblog/core/error/failures.dart';
import 'package:microblog/core/common/entities/user.dart';
import 'package:microblog/core/network/connection_checker.dart';
import 'package:microblog/features/auth/data/model/user_model.dart';
import 'package:microblog/features/auth/domain/repository/auth_repository.dart';

import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  const AuthRepositoryImpl(
    this.remoteDataSource,
    this.connectionChecker,
  );

  @override
  Future<Either<Failures, User>> currentUser() async {
    try {
      final isConnected = await connectionChecker.isConnected;

      if (!isConnected) {
        final session = remoteDataSource.currentUserSession;
        if (session == null) {
          return left(Failures('User Not Logged In !!!'));
        }
        return right(UserModel(
          id: session.user.id,
          email: session.user.email ?? '',
          name: '',
        ));
      }

      final user = await remoteDataSource.getCurrentUser();
      if (user == null) {
        return left(Failures('User not logged in'));
      }
      return right(user);
    } on ServerExceptions catch (e) {
      return left(Failures(e.message));
    }
  }

  @override
  Future<Either<Failures, User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failures('No internet connection'));
      }
      final user = await remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      );
      return right(user);
    } on ServerExceptions catch (e) {
      return left(Failures(e.message));
    }
  }

  @override
  Future<Either<Failures, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failures(Constants.noConnection));
      }
      final user = await remoteDataSource.signUpWithEmailPassword(
        email: email,
        password: password,
        name: name,
      );
      return right(user);
    } on ServerExceptions catch (e) {
      return left(Failures(e.message));
    }
  }
}
