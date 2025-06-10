import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// Bazowa klasa dla wszystkich use case'ów w aplikacji
/// Implementuje pattern Use Case z Clean Architecture
abstract class UseCase<Type, Params> {
  /// Wywołanie use case'a
  /// Zwraca Either<Failure, Type> dla obsługi błędów
  Future<Either<Failure, Type>> call(Params params);
}

/// Use case bez parametrów
abstract class UseCaseNoParams<Type> {
  Future<Either<Failure, Type>> call();
}

/// Klasa reprezentująca brak parametrów
class NoParams {
  const NoParams();
  
  @override
  bool operator ==(Object other) => other is NoParams;
  
  @override
  int get hashCode => 0;
} 