import 'package:equatable/equatable.dart';

/// Bazowa klasa dla wszystkich błędów w aplikacji
abstract class Failure extends Equatable {
  final String message;
  final int? errorCode;
  
  const Failure(this.message, [this.errorCode]);
  
  @override
  List<Object?> get props => [message, errorCode];
}

// === Błędy sieciowe ===

/// Błąd braku połączenia z internetem
class NetworkFailure extends Failure {
  const NetworkFailure() : super('Brak połączenia z internetem');
}

/// Błąd serwera (5xx)
class ServerFailure extends Failure {
  const ServerFailure([String? message]) 
      : super(message ?? 'Wystąpił błąd serwera. Spróbuj ponownie później');
}

/// Błąd autoryzacji (401, 403)
class AuthFailure extends Failure {
  const AuthFailure([String? message]) 
      : super(message ?? 'Błąd autoryzacji. Zaloguj się ponownie');
}

/// Błąd walidacji danych (400)
class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

/// Błąd gdy zasób nie został znaleziony (404)
class NotFoundFailure extends Failure {
  const NotFoundFailure([String? message]) 
      : super(message ?? 'Nie znaleziono zasobu');
}

/// Ogólny błąd HTTP
class HttpFailure extends Failure {
  const HttpFailure(String message, int statusCode) 
      : super(message, statusCode);
}

// === Błędy lokalne ===

/// Błąd cache'u lokalnego
class CacheFailure extends Failure {
  const CacheFailure() : super('Błąd odczytu danych lokalnych');
}

/// Błąd bazy danych lokalnej
class DatabaseFailure extends Failure {
  const DatabaseFailure([String? message]) 
      : super(message ?? 'Błąd bazy danych');
}

/// Błąd uprawnień (lokalizacja, kamera, itp.)
class PermissionFailure extends Failure {
  const PermissionFailure(String message) : super(message);
}

// === Błędy specyficzne dla aplikacji ===

/// Błąd weryfikacji tożsamości
class VerificationFailure extends Failure {
  const VerificationFailure(String message) : super(message);
}

/// Błąd podczas matchingu
class MatchingFailure extends Failure {
  const MatchingFailure([String? message]) 
      : super(message ?? 'Błąd podczas wyszukiwania profili');
}

/// Błąd czatu
class ChatFailure extends Failure {
  const ChatFailure([String? message]) 
      : super(message ?? 'Błąd podczas wysyłania wiadomości');
}

/// Błąd uploadu plików (zdjęć)
class UploadFailure extends Failure {
  const UploadFailure([String? message]) 
      : super(message ?? 'Błąd podczas przesyłania pliku');
}

/// Nieoczekiwany błąd
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([String? message]) 
      : super(message ?? 'Wystąpił nieoczekiwany błąd');
} 