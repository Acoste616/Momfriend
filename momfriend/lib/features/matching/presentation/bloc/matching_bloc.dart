import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/entities/mom_profile.dart';
import '../../../../core/data/sample_profiles.dart';

// Events
abstract class MatchingEvent extends Equatable {
  const MatchingEvent();

  @override
  List<Object> get props => [];
}

class LoadPotentialMatches extends MatchingEvent {
  final String userId;

  const LoadPotentialMatches({required this.userId});

  @override
  List<Object> get props => [userId];
}

class SwipeProfile extends MatchingEvent {
  final String profileId;
  final SwipeAction action;

  const SwipeProfile({required this.profileId, required this.action});

  @override
  List<Object> get props => [profileId, action];
}

class SuperLikeProfile extends MatchingEvent {
  final String profileId;

  const SuperLikeProfile({required this.profileId});

  @override
  List<Object> get props => [profileId];
}

enum SwipeAction { like, pass }

// States
abstract class MatchingState extends Equatable {
  const MatchingState();

  @override
  List<Object?> get props => [];
}

class MatchingInitial extends MatchingState {}

class MatchingLoading extends MatchingState {}

class MatchingLoaded extends MatchingState {
  final List<MomProfile> profiles;
  final int currentIndex;

  const MatchingLoaded({
    required this.profiles,
    required this.currentIndex,
  });

  MomProfile? get currentProfile => 
      currentIndex < profiles.length ? profiles[currentIndex] : null;

  @override
  List<Object> get props => [profiles, currentIndex];
}

class MatchingEmpty extends MatchingState {
  final String message;

  const MatchingEmpty({required this.message});

  @override
  List<Object> get props => [message];
}

class MatchingError extends MatchingState {
  final String message;

  const MatchingError({required this.message});

  @override
  List<Object> get props => [message];
}

class MatchingMatched extends MatchingState {
  final MomProfile matchedProfile;
  final List<MomProfile> remainingProfiles;
  final int currentIndex;

  const MatchingMatched({
    required this.matchedProfile,
    required this.remainingProfiles,
    required this.currentIndex,
  });

  @override
  List<Object> get props => [matchedProfile, remainingProfiles, currentIndex];
}

// Bloc
class MatchingBloc extends Bloc<MatchingEvent, MatchingState> {
  MatchingBloc() : super(MatchingInitial()) {
    on<LoadPotentialMatches>(_onLoadPotentialMatches);
    on<SwipeProfile>(_onSwipeProfile);
    on<SuperLikeProfile>(_onSuperLikeProfile);
  }

  void _onLoadPotentialMatches(
    LoadPotentialMatches event,
    Emitter<MatchingState> emit,
  ) async {
    emit(MatchingLoading());

    try {
      // Symulacja ładowania
      await Future.delayed(const Duration(seconds: 1));

      final profiles = SampleProfiles.getRandomProfiles(count: 8);
      
      if (profiles.isEmpty) {
        emit(const MatchingEmpty(
          message: 'Nie ma więcej profili do pokazania. Sprawdź ponownie później! 🌟'
        ));
      } else {
        emit(MatchingLoaded(profiles: profiles, currentIndex: 0));
      }
    } catch (e) {
      emit(MatchingError(message: 'Błąd podczas ładowania profili: ${e.toString()}'));
    }
  }

  void _onSwipeProfile(
    SwipeProfile event,
    Emitter<MatchingState> emit,
  ) async {
    if (state is MatchingLoaded) {
      final currentState = state as MatchingLoaded;
      final newIndex = currentState.currentIndex + 1;

      // Symulacja sprawdzenia matcha (30% szans na match dla like)
      final isMatch = event.action == SwipeAction.like && 
                     DateTime.now().millisecond % 100 < 30;

      if (isMatch) {
        final matchedProfile = currentState.profiles[currentState.currentIndex];
        emit(MatchingMatched(
          matchedProfile: matchedProfile,
          remainingProfiles: currentState.profiles,
          currentIndex: newIndex,
        ));
      } else {
        if (newIndex >= currentState.profiles.length) {
          emit(const MatchingEmpty(
            message: 'Świetna robota! Przejrzałaś wszystkie profile. 🎉'
          ));
        } else {
          emit(MatchingLoaded(
            profiles: currentState.profiles,
            currentIndex: newIndex,
          ));
        }
      }
    }
  }

  void _onSuperLikeProfile(
    SuperLikeProfile event,
    Emitter<MatchingState> emit,
  ) async {
    if (state is MatchingLoaded) {
      final currentState = state as MatchingLoaded;
      final newIndex = currentState.currentIndex + 1;

      // Super like ma większą szansę na match (60%)
      final isMatch = DateTime.now().millisecond % 100 < 60;

      if (isMatch) {
        final matchedProfile = currentState.profiles[currentState.currentIndex];
        emit(MatchingMatched(
          matchedProfile: matchedProfile,
          remainingProfiles: currentState.profiles,
          currentIndex: newIndex,
        ));
      } else {
        if (newIndex >= currentState.profiles.length) {
          emit(const MatchingEmpty(
            message: 'Świetna robota! Przejrzałaś wszystkie profile. 🎉'
          ));
        } else {
          emit(MatchingLoaded(
            profiles: currentState.profiles,
            currentIndex: newIndex,
          ));
        }
      }
    }
  }
} 