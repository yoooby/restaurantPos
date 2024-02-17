import 'package:fpdart/fpdart.dart';
import 'package:restaurent_pos/common/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;
