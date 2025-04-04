import 'package:fpdart/fpdart.dart';
import 'package:microblog/core/error/failures.dart';

abstract interface class UseCase<SuccessType, Parms> {
  Future<Either<Failures, SuccessType>> call(Parms parms);
}

class NoParms {}
