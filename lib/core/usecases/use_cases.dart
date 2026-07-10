import 'package:dartz/dartz.dart';

import '../error/failures.dart';

abstract class UseCase<T, Param> {
  Future<Either<Failure, T>> call(Param param);
}

abstract class UseCaseNoParam<T> {
  Future<Either<Failure, T>> call();
}