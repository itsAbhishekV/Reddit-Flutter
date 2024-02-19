import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/failures.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;