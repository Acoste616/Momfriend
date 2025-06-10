import 'package:equatable/equatable.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';

class MatchProfile extends Equatable {
  final String id;
  final String name;
  final int age;
  final String bio;
  final List<String> interests;
  final List<Child> children;
  final double distance; // w kilometrach
  final String? profileImageUrl;
  final bool isVerified;
  final int matchScore; // 0-100 score zgodności

  const MatchProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.bio,
    required this.interests,
    required this.children,
    required this.distance,
    this.profileImageUrl,
    required this.isVerified,
    required this.matchScore,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        age,
        bio,
        interests,
        children,
        distance,
        profileImageUrl,
        isVerified,
        matchScore,
      ];

  // Gettery dla UI
  String get distanceText {
    if (distance < 1) {
      return '${(distance * 1000).round()}m od Ciebie';
    } else {
      return '${distance.toStringAsFixed(1)}km od Ciebie';
    }
  }

  String get childrenText {
    if (children.isEmpty) return '';
    
    if (children.length == 1) {
      final child = children.first;
      final emoji = child.gender == 'F' ? '👧' : '👶';
      return 'Mama $emoji ${child.age}${child.age == 1 ? 'r' : 'l'}';
    } else {
      final ageRange = '${children.map((c) => c.age).reduce((a, b) => a < b ? a : b)}' +
          '-${children.map((c) => c.age).reduce((a, b) => a > b ? a : b)}l';
      return 'Mama ${children.length} dzieci ($ageRange)';
    }
  }

  List<String> get topInterests {
    return interests.take(3).toList();
  }

  factory MatchProfile.fromJson(Map<String, dynamic> json) {
    return MatchProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      age: json['age'] as int,
      bio: json['bio'] as String,
      interests: List<String>.from(json['interests'] as List),
      children: (json['children'] as List)
          .map((childJson) => Child(
                id: childJson['id'] as String,
                name: childJson['name'] as String,
                age: childJson['age'] as int,
                gender: childJson['gender'] as String,
                birthYear: DateTime.parse(childJson['birthYear'] as String),
              ))
          .toList(),
      distance: (json['distance'] as num).toDouble(),
      profileImageUrl: json['profileImageUrl'] as String?,
      isVerified: json['isVerified'] as bool,
      matchScore: json['matchScore'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'bio': bio,
      'interests': interests,
      'children': children
          .map((child) => {
                'id': child.id,
                'name': child.name,
                'age': child.age,
                'gender': child.gender,
                'birthYear': child.birthYear.toIso8601String(),
              })
          .toList(),
      'distance': distance,
      'profileImageUrl': profileImageUrl,
      'isVerified': isVerified,
      'matchScore': matchScore,
    };
  }
} 