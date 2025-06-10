import 'package:equatable/equatable.dart';

/// Status weryfikacji profilu
enum VerificationStatus {
  /// Profil nie został jeszcze zweryfikowany
  unverified,
  /// W trakcie weryfikacji
  pending,
  /// Zweryfikowany
  verified,
  /// Weryfikacja odrzucona
  rejected,
}

/// Płeć dziecka
enum Gender {
  male,
  female,
  other,
}

/// Zainteresowania mamy
enum Interest {
  playground,
  coffee,
  shopping,
  fitness,
  cooking,
  reading,
  crafts,
  music,
  outdoor,
  photography,
  travel,
  volunteering,
}

/// Informacje o dziecku
class Child extends Equatable {
  final String id;
  final int age; // w miesiącach dla większej precyzji
  final Gender gender;
  final String? name; // opcjonalne dla prywatności
  
  const Child({
    required this.id,
    required this.age,
    required this.gender,
    this.name,
  });
  
  /// Wiek w latach (z dokładnością do miesięcy)
  String get ageFormatted {
    if (age < 12) {
      return '$age mies.';
    } else if (age < 24) {
      final months = age % 12;
      return months == 0 ? '1 rok' : '1 rok $months mies.';
    } else {
      final years = age ~/ 12;
      final months = age % 12;
      if (months == 0) {
        return '$years lat${years == 1 ? '' : years < 5 ? 'a' : ''}';
      } else {
        return '$years lat${years == 1 ? '' : years < 5 ? 'a' : ''} $months mies.';
      }
    }
  }
  
  /// Emoji dla płci
  String get genderEmoji {
    switch (gender) {
      case Gender.male:
        return '👦';
      case Gender.female:
        return '👧';
      case Gender.other:
        return '👶';
    }
  }
  
  @override
  List<Object?> get props => [id, age, gender, name];
}

/// Lokalizacja użytkownika
class Location extends Equatable {
  final double latitude;
  final double longitude;
  final String? city;
  final String? district;
  
  const Location({
    required this.latitude,
    required this.longitude,
    this.city,
    this.district,
  });
  
  @override
  List<Object?> get props => [latitude, longitude, city, district];
}

/// Główna encja profilu mamy
class MomProfile extends Equatable {
  final String id;
  final String name;
  final int age;
  final String? bio;
  final List<String> photoUrls;
  final List<Child> children;
  final Location location;
  final List<Interest> interests;
  final VerificationStatus verification;
  final DateTime createdAt;
  final DateTime? lastActiveAt;
  final bool isOnline;
  final double? distanceKm; // odległość od aktualnego użytkownika
  
  const MomProfile({
    required this.id,
    required this.name,
    required this.age,
    this.bio,
    required this.photoUrls,
    required this.children,
    required this.location,
    required this.interests,
    required this.verification,
    required this.createdAt,
    this.lastActiveAt,
    required this.isOnline,
    this.distanceKm,
  });
  
  /// Główne zdjęcie profilu
  String get primaryPhotoUrl {
    return photoUrls.isNotEmpty 
        ? photoUrls.first 
        : 'https://via.placeholder.com/400x600?text=Mama';
  }
  
  /// Czy profil jest zweryfikowany
  bool get isVerified => verification == VerificationStatus.verified;
  
  /// Formatowanie informacji o dzieciach
  String get childrenInfo {
    if (children.isEmpty) return 'Brak informacji o dzieciach';
    
    if (children.length == 1) {
      final child = children.first;
      return 'Mama ${child.genderEmoji} ${child.ageFormatted}';
    } else {
      return 'Mama ${children.length} ${children.length == 2 ? 'dzieci' : children.length < 5 ? 'dzieci' : 'dzieci'}';
    }
  }
  
  /// Formatowanie odległości
  String get distanceFormatted {
    if (distanceKm == null) return '';
    if (distanceKm! < 1) {
      return '${(distanceKm! * 1000).round()}m';
    } else {
      return '${distanceKm!.toStringAsFixed(1)}km';
    }
  }
  
  /// Formatowanie czasu ostatniej aktywności
  String get lastActiveFormatted {
    if (isOnline) return 'Online teraz';
    if (lastActiveAt == null) return 'Nieznana aktywność';
    
    final now = DateTime.now();
    final difference = now.difference(lastActiveAt!);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min temu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} godz. temu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} dni temu';
    } else {
      return 'Ponad tydzień temu';
    }
  }
  
  /// Lista interest'ów jako tekst
  List<String> get interestLabels {
    return interests.map((interest) {
      switch (interest) {
        case Interest.playground:
          return 'Plac zabaw';
        case Interest.coffee:
          return 'Kawa';
        case Interest.shopping:
          return 'Zakupy';
        case Interest.fitness:
          return 'Fitness';
        case Interest.cooking:
          return 'Gotowanie';
        case Interest.reading:
          return 'Czytanie';
        case Interest.crafts:
          return 'Rękodzieło';
        case Interest.music:
          return 'Muzyka';
        case Interest.outdoor:
          return 'Na świeżym powietrzu';
        case Interest.photography:
          return 'Fotografia';
        case Interest.travel:
          return 'Podróże';
        case Interest.volunteering:
          return 'Wolontariat';
      }
    }).toList();
  }
  
  /// Kopiowanie z modyfikacjami
  MomProfile copyWith({
    String? id,
    String? name,
    int? age,
    String? bio,
    List<String>? photoUrls,
    List<Child>? children,
    Location? location,
    List<Interest>? interests,
    VerificationStatus? verification,
    DateTime? createdAt,
    DateTime? lastActiveAt,
    bool? isOnline,
    double? distanceKm,
  }) {
    return MomProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      bio: bio ?? this.bio,
      photoUrls: photoUrls ?? this.photoUrls,
      children: children ?? this.children,
      location: location ?? this.location,
      interests: interests ?? this.interests,
      verification: verification ?? this.verification,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      isOnline: isOnline ?? this.isOnline,
      distanceKm: distanceKm ?? this.distanceKm,
    );
  }
  
  @override
  List<Object?> get props => [
    id, name, age, bio, photoUrls, children, location, 
    interests, verification, createdAt, lastActiveAt, 
    isOnline, distanceKm
  ];
} 