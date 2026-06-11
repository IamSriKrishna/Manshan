import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:manshan/core/util/failure.dart';

abstract class Usecase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
