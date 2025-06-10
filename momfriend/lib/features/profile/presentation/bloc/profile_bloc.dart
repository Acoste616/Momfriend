import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/mock/mock_data.dart';

// Models
class Child extends Equatable {
  final String id;
  final String name;
  final int age;
  final String gender;
  final DateTime birthYear;

  const Child({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.birthYear,
  });

  @override
  List<Object> get props => [id, name, age, gender, birthYear];
}

class UserProfile extends Equatable {
  final String id;
  final String name;
  final int age;
  final String bio;
  final List<String> interests;
  final List<Child> children;
  final String? profileImageUrl;
  final bool isVerified;
  final double? latitude;
  final double? longitude;

  const UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.bio,
    required this.interests,
    required this.children,
    this.profileImageUrl,
    required this.isVerified,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        age,
        bio,
        interests,
        children,
        profileImageUrl,
        isVerified,
        latitude,
        longitude,
      ];
}

// Events
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfile extends ProfileEvent {
  final String userId;

  const LoadProfile({required this.userId});

  @override
  List<Object> get props => [userId];
}

class UpdateBasicInfo extends ProfileEvent {
  final String name;
  final int age;
  final String bio;

  const UpdateBasicInfo({
    required this.name,
    required this.age,
    required this.bio,
  });

  @override
  List<Object> get props => [name, age, bio];
}

class AddChild extends ProfileEvent {
  final Child child;

  const AddChild({required this.child});

  @override
  List<Object> get props => [child];
}

class RemoveChild extends ProfileEvent {
  final String childId;

  const RemoveChild({required this.childId});

  @override
  List<Object> get props => [childId];
}

class UpdateInterests extends ProfileEvent {
  final List<String> interests;

  const UpdateInterests({required this.interests});

  @override
  List<Object> get props => [interests];
}

class UpdateLocation extends ProfileEvent {
  final double latitude;
  final double longitude;

  const UpdateLocation({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [latitude, longitude];
}

class UploadProfileImage extends ProfileEvent {
  final String imagePath;

  const UploadProfileImage({required this.imagePath});

  @override
  List<Object> get props => [imagePath];
}

// States
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfile profile;

  const ProfileLoaded({required this.profile});

  @override
  List<Object> get props => [profile];
}

class ProfileUpdating extends ProfileState {
  final UserProfile profile;

  const ProfileUpdating({required this.profile});

  @override
  List<Object> get props => [profile];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object> get props => [message];
}

// Bloc
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateBasicInfo>(_onUpdateBasicInfo);
    on<AddChild>(_onAddChild);
    on<RemoveChild>(_onRemoveChild);
    on<UpdateInterests>(_onUpdateInterests);
    on<UpdateLocation>(_onUpdateLocation);
    on<UploadProfileImage>(_onUploadProfileImage);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      // TODO: Implementuj ładowanie profilu z API
      await Future.delayed(const Duration(seconds: 1));

      // Używamy danych z MockData
      final profile = MockData.mockUserProfile;

      emit(ProfileLoaded(profile: profile));
    } catch (e) {
      emit(ProfileError(message: 'Błąd podczas ładowania profilu: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateBasicInfo(
    UpdateBasicInfo event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileLoaded) {
      final currentProfile = (state as ProfileLoaded).profile;
      emit(ProfileUpdating(profile: currentProfile));

      try {
        // TODO: Implementuj aktualizację w API
        await Future.delayed(const Duration(seconds: 1));

        final updatedProfile = UserProfile(
          id: currentProfile.id,
          name: event.name,
          age: event.age,
          bio: event.bio,
          interests: currentProfile.interests,
          children: currentProfile.children,
          profileImageUrl: currentProfile.profileImageUrl,
          isVerified: currentProfile.isVerified,
          latitude: currentProfile.latitude,
          longitude: currentProfile.longitude,
        );

        emit(ProfileLoaded(profile: updatedProfile));
      } catch (e) {
        emit(ProfileError(message: 'Błąd podczas aktualizacji profilu: ${e.toString()}'));
      }
    }
  }

  Future<void> _onAddChild(
    AddChild event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileLoaded) {
      final currentProfile = (state as ProfileLoaded).profile;
      emit(ProfileUpdating(profile: currentProfile));

      try {
        // TODO: Implementuj dodawanie dziecka w API
        await Future.delayed(const Duration(seconds: 1));

        final updatedChildren = [...currentProfile.children, event.child];
        final updatedProfile = UserProfile(
          id: currentProfile.id,
          name: currentProfile.name,
          age: currentProfile.age,
          bio: currentProfile.bio,
          interests: currentProfile.interests,
          children: updatedChildren,
          profileImageUrl: currentProfile.profileImageUrl,
          isVerified: currentProfile.isVerified,
          latitude: currentProfile.latitude,
          longitude: currentProfile.longitude,
        );

        emit(ProfileLoaded(profile: updatedProfile));
      } catch (e) {
        emit(ProfileError(message: 'Błąd podczas dodawania dziecka: ${e.toString()}'));
      }
    }
  }

  Future<void> _onRemoveChild(
    RemoveChild event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileLoaded) {
      final currentProfile = (state as ProfileLoaded).profile;
      emit(ProfileUpdating(profile: currentProfile));

      try {
        // TODO: Implementuj usuwanie dziecka w API
        await Future.delayed(const Duration(seconds: 1));

        final updatedChildren = currentProfile.children
            .where((child) => child.id != event.childId)
            .toList();

        final updatedProfile = UserProfile(
          id: currentProfile.id,
          name: currentProfile.name,
          age: currentProfile.age,
          bio: currentProfile.bio,
          interests: currentProfile.interests,
          children: updatedChildren,
          profileImageUrl: currentProfile.profileImageUrl,
          isVerified: currentProfile.isVerified,
          latitude: currentProfile.latitude,
          longitude: currentProfile.longitude,
        );

        emit(ProfileLoaded(profile: updatedProfile));
      } catch (e) {
        emit(ProfileError(message: 'Błąd podczas usuwania dziecka: ${e.toString()}'));
      }
    }
  }

  Future<void> _onUpdateInterests(
    UpdateInterests event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileLoaded) {
      final currentProfile = (state as ProfileLoaded).profile;
      emit(ProfileUpdating(profile: currentProfile));

      try {
        // TODO: Implementuj aktualizację zainteresowań w API
        await Future.delayed(const Duration(seconds: 1));

        final updatedProfile = UserProfile(
          id: currentProfile.id,
          name: currentProfile.name,
          age: currentProfile.age,
          bio: currentProfile.bio,
          interests: event.interests,
          children: currentProfile.children,
          profileImageUrl: currentProfile.profileImageUrl,
          isVerified: currentProfile.isVerified,
          latitude: currentProfile.latitude,
          longitude: currentProfile.longitude,
        );

        emit(ProfileLoaded(profile: updatedProfile));
      } catch (e) {
        emit(ProfileError(message: 'Błąd podczas aktualizacji zainteresowań: ${e.toString()}'));
      }
    }
  }

  Future<void> _onUpdateLocation(
    UpdateLocation event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileLoaded) {
      final currentProfile = (state as ProfileLoaded).profile;
      emit(ProfileUpdating(profile: currentProfile));

      try {
        // TODO: Implementuj aktualizację lokalizacji w API
        await Future.delayed(const Duration(seconds: 1));

        final updatedProfile = UserProfile(
          id: currentProfile.id,
          name: currentProfile.name,
          age: currentProfile.age,
          bio: currentProfile.bio,
          interests: currentProfile.interests,
          children: currentProfile.children,
          profileImageUrl: currentProfile.profileImageUrl,
          isVerified: currentProfile.isVerified,
          latitude: event.latitude,
          longitude: event.longitude,
        );

        emit(ProfileLoaded(profile: updatedProfile));
      } catch (e) {
        emit(ProfileError(message: 'Błąd podczas aktualizacji lokalizacji: ${e.toString()}'));
      }
    }
  }

  Future<void> _onUploadProfileImage(
    UploadProfileImage event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileLoaded) {
      final currentProfile = (state as ProfileLoaded).profile;
      emit(ProfileUpdating(profile: currentProfile));

      try {
        // TODO: Implementuj upload zdjęcia do storage
        await Future.delayed(const Duration(seconds: 2));

        const imageUrl = 'https://example.com/uploaded-image.jpg';

        final updatedProfile = UserProfile(
          id: currentProfile.id,
          name: currentProfile.name,
          age: currentProfile.age,
          bio: currentProfile.bio,
          interests: currentProfile.interests,
          children: currentProfile.children,
          profileImageUrl: imageUrl,
          isVerified: currentProfile.isVerified,
          latitude: currentProfile.latitude,
          longitude: currentProfile.longitude,
        );

        emit(ProfileLoaded(profile: updatedProfile));
      } catch (e) {
        emit(ProfileError(message: 'Błąd podczas wysyłania zdjęcia: ${e.toString()}'));
      }
    }
  }
} 