import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthStarted extends AuthEvent {}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;

  const SignUpRequested({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object> get props => [email, password, name];
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class GoogleSignInRequested extends AuthEvent {}

class AppleSignInRequested extends AuthEvent {}

class SignOutRequested extends AuthEvent {}

class VerificationRequested extends AuthEvent {
  final String verificationCode;

  const VerificationRequested({required this.verificationCode});

  @override
  List<Object> get props => [verificationCode];
}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String userId;
  final String email;
  final String name;
  final bool isVerified;

  const AuthAuthenticated({
    required this.userId,
    required this.email,
    required this.name,
    required this.isVerified,
  });

  @override
  List<Object> get props => [userId, email, name, isVerified];
}

class AuthVerificationPending extends AuthState {
  final String email;

  const AuthVerificationPending({required this.email});

  @override
  List<Object> get props => [email];
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignInRequested>(_onSignInRequested);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<AppleSignInRequested>(_onAppleSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<VerificationRequested>(_onVerificationRequested);
  }

  Future<void> _onAuthStarted(
    AuthStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    // Sprawdź czy użytkownik jest już zalogowany
    try {
      // TODO: Implementuj sprawdzanie aktualnego stanu autentykacji
      await Future.delayed(const Duration(seconds: 1));
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: 'Błąd podczas sprawdzania autentykacji'));
    }
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      // TODO: Implementuj rejestrację
      await Future.delayed(const Duration(seconds: 2));
      
      // Symulacja sukcesu - wysłanie kodu weryfikacyjnego
      emit(AuthVerificationPending(email: event.email));
    } catch (e) {
      emit(AuthError(message: 'Błąd podczas rejestracji: ${e.toString()}'));
    }
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      // TODO: Implementuj logowanie
      await Future.delayed(const Duration(seconds: 2));
      
      emit(const AuthAuthenticated(
        userId: 'user123',
        email: 'test@example.com',
        name: 'Anna',
        isVerified: true,
      ));
    } catch (e) {
      emit(AuthError(message: 'Błąd podczas logowania: ${e.toString()}'));
    }
  }

  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      // TODO: Implementuj logowanie przez Google
      await Future.delayed(const Duration(seconds: 2));
      
      emit(const AuthAuthenticated(
        userId: 'google_user123',
        email: 'test@gmail.com',
        name: 'Anna Google',
        isVerified: true,
      ));
    } catch (e) {
      emit(AuthError(message: 'Błąd podczas logowania przez Google: ${e.toString()}'));
    }
  }

  Future<void> _onAppleSignInRequested(
    AppleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      // TODO: Implementuj logowanie przez Apple
      await Future.delayed(const Duration(seconds: 2));
      
      emit(const AuthAuthenticated(
        userId: 'apple_user123',
        email: 'test@icloud.com',
        name: 'Anna Apple',
        isVerified: true,
      ));
    } catch (e) {
      emit(AuthError(message: 'Błąd podczas logowania przez Apple: ${e.toString()}'));
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      // TODO: Implementuj wylogowanie
      await Future.delayed(const Duration(seconds: 1));
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: 'Błąd podczas wylogowania: ${e.toString()}'));
    }
  }

  Future<void> _onVerificationRequested(
    VerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      // TODO: Implementuj weryfikację kodu
      await Future.delayed(const Duration(seconds: 2));
      
      if (event.verificationCode == '123456') {
        emit(const AuthAuthenticated(
          userId: 'verified_user123',
          email: 'test@example.com',
          name: 'Anna',
          isVerified: true,
        ));
      } else {
        emit(const AuthError(message: 'Nieprawidłowy kod weryfikacyjny'));
      }
    } catch (e) {
      emit(AuthError(message: 'Błąd podczas weryfikacji: ${e.toString()}'));
    }
  }
} 