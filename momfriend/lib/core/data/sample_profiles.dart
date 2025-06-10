import '../entities/mom_profile.dart';

/// Przykładowe profile mam do demonstracji aplikacji
class SampleProfiles {
  static List<MomProfile> get sampleMoms => [
    // Anna - mama 3-letniej Zosi
    MomProfile(
      id: 'anna_kowalska',
      name: 'Anna',
      age: 32,
      bio: 'Mama energicznej 3-latki 💫 Uwielbiamy spacery po parku i wspólne gotowanie. Szukam mamy do wspólnych zabaw na placu i kawek ☕',
      photoUrls: [
        'https://images.unsplash.com/photo-1494790108755-2616b612b631?w=400&h=600&fit=crop&crop=face',
        'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=400&h=600&fit=crop&crop=face',
      ],
      children: [
        Child(
          id: 'zosia',
          age: 36, // 3 lata w miesiącach
          gender: Gender.female,
          name: 'Zosia',
        ),
      ],
      location: const Location(
        latitude: 50.0647,
        longitude: 19.9450,
        city: 'Kraków',
        district: 'Stare Miasto',
      ),
      interests: [
        Interest.playground,
        Interest.coffee,
        Interest.cooking,
        Interest.reading,
        Interest.photography,
      ],
      verification: VerificationStatus.verified,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      lastActiveAt: DateTime.now().subtract(const Duration(minutes: 15)),
      isOnline: true,
      distanceKm: 0.8,
    ),

    // Magda - mama bliźniaków
    MomProfile(
      id: 'magda_nowak',
      name: 'Magda',
      age: 29,
      bio: 'Mama bliźniaków 👶👶 Życie w przyspieszonym tempie! Szukam innych mam bliźniaków lub po prostu zrozumienia 😅',
      photoUrls: [
        'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=400&h=600&fit=crop&crop=face',
        'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&h=600&fit=crop&crop=face',
      ],
      children: [
        Child(
          id: 'kacper',
          age: 18, // 1.5 roku
          gender: Gender.male,
          name: 'Kacper',
        ),
        Child(
          id: 'maja',
          age: 18, // 1.5 roku
          gender: Gender.female,
          name: 'Maja',
        ),
      ],
      location: const Location(
        latitude: 50.0755,
        longitude: 19.9358,
        city: 'Kraków',
        district: 'Kazimierz',
      ),
      interests: [
        Interest.playground,
        Interest.fitness,
        Interest.music,
        Interest.volunteering,
        Interest.coffee,
      ],
      verification: VerificationStatus.verified,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      lastActiveAt: DateTime.now().subtract(const Duration(hours: 2)),
      isOnline: false,
      distanceKm: 1.2,
    ),

    // Katarzyna - mama nastolatki
    MomProfile(
      id: 'katarzyna_wisniewska',
      name: 'Katarzyna',
      age: 42,
      bio: 'Mama 15-letniej Oli. Praca zdalna + nastoletnia córka = potrzebuję wsparcia innych mam! 💪 Uwielbiamy podróże i fotografię.',
      photoUrls: [
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=600&fit=crop&crop=face',
        'https://images.unsplash.com/photo-1489424731084-a5d8b219a5bb?w=400&h=600&fit=crop&crop=face',
      ],
      children: [
        Child(
          id: 'ola',
          age: 180, // 15 lat
          gender: Gender.female,
          name: 'Ola',
        ),
      ],
      location: const Location(
        latitude: 50.0413,
        longitude: 19.9367,
        city: 'Kraków',
        district: 'Podgórze',
      ),
      interests: [
        Interest.photography,
        Interest.travel,
        Interest.reading,
        Interest.coffee,
        Interest.volunteering,
      ],
      verification: VerificationStatus.verified,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      lastActiveAt: DateTime.now().subtract(const Duration(minutes: 30)),
      isOnline: true,
      distanceKm: 2.1,
    ),

    // Justyna - mama niemowlaka
    MomProfile(
      id: 'justyna_kowalczyk',
      name: 'Justyna',
      age: 27,
      bio: 'Świeżo upieczona mama 6-miesięcznego Kubusia 👶 Uczę się macierzyństwa. Szukam wsparcia i przyjaźni z innymi młodymi mamami.',
      photoUrls: [
        'https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?w=400&h=600&fit=crop&crop=face',
        'https://images.unsplash.com/photo-1496440737103-cd596325d314?w=400&h=600&fit=crop&crop=face',
      ],
      children: [
        Child(
          id: 'kuba',
          age: 6, // 6 miesięcy
          gender: Gender.male,
          name: 'Kuba',
        ),
      ],
      location: const Location(
        latitude: 50.0874,
        longitude: 19.9222,
        city: 'Kraków',
        district: 'Krowodrza',
      ),
      interests: [
        Interest.reading,
        Interest.music,
        Interest.crafts,
        Interest.coffee,
        Interest.fitness,
      ],
      verification: VerificationStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      lastActiveAt: DateTime.now().subtract(const Duration(hours: 1)),
      isOnline: false,
      distanceKm: 3.5,
    ),

    // Agnieszka - mama aktywistka
    MomProfile(
      id: 'agnieszka_zielinska',
      name: 'Agnieszka',
      age: 35,
      bio: 'Mama 8-letniej Julki i 5-letniego Tomka. Aktywistka lokalna 🌱 Organizuję wydarzenia dla rodzin w naszej dzielnicy.',
      photoUrls: [
        'https://images.unsplash.com/photo-1485875437342-9b39470b3d95?w=400&h=600&fit=crop&crop=face',
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&h=600&fit=crop&crop=face',
      ],
      children: [
        Child(
          id: 'julka',
          age: 96, // 8 lat
          gender: Gender.female,
          name: 'Julka',
        ),
        Child(
          id: 'tomek',
          age: 60, // 5 lat
          gender: Gender.male,
          name: 'Tomek',
        ),
      ],
      location: const Location(
        latitude: 50.0370,
        longitude: 19.9923,
        city: 'Kraków',
        district: 'Nowa Huta',
      ),
      interests: [
        Interest.volunteering,
        Interest.outdoor,
        Interest.playground,
        Interest.crafts,
        Interest.cooking,
      ],
      verification: VerificationStatus.verified,
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      lastActiveAt: DateTime.now().subtract(const Duration(hours: 6)),
      isOnline: false,
      distanceKm: 7.2,
    ),

    // Monika - mama na macierzyńskim
    MomProfile(
      id: 'monika_dabrowska',
      name: 'Monika',
      age: 30,
      bio: 'Na macierzyńskim z 2-letnią Lenką 👧 Uwielbiamy spacery, zabawy twórcze i spotkania z innymi mamami. Szukam stałej grupy!',
      photoUrls: [
        'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400&h=600&fit=crop&crop=face',
        'https://images.unsplash.com/photo-1506277886164-e25aa3f4ef7f?w=400&h=600&fit=crop&crop=face',
      ],
      children: [
        Child(
          id: 'lenka',
          age: 24, // 2 lata
          gender: Gender.female,
          name: 'Lenka',
        ),
      ],
      location: const Location(
        latitude: 50.0619,
        longitude: 19.9369,
        city: 'Kraków',
        district: 'Śródmieście',
      ),
      interests: [
        Interest.playground,
        Interest.crafts,
        Interest.music,
        Interest.reading,
        Interest.shopping,
      ],
      verification: VerificationStatus.verified,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      lastActiveAt: DateTime.now().subtract(const Duration(minutes: 45)),
      isOnline: true,
      distanceKm: 1.8,
    ),

    // Paulina - mama przedszkolaka
    MomProfile(
      id: 'paulina_lewandowska',
      name: 'Paulina',
      age: 33,
      bio: 'Mama 4-letniego Maksa 🚗 Kochamy samochody, budowanie z klocków i wyprawy na place zabaw. Szukam mam chłopców w podobnym wieku!',
      photoUrls: [
        'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=400&h=600&fit=crop&crop=face',
        'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=400&h=600&fit=crop&crop=face',
      ],
      children: [
        Child(
          id: 'maks',
          age: 48, // 4 lata
          gender: Gender.male,
          name: 'Maks',
        ),
      ],
      location: const Location(
        latitude: 50.0495,
        longitude: 19.9446,
        city: 'Kraków',
        district: 'Grzegórzki',
      ),
      interests: [
        Interest.playground,
        Interest.outdoor,
        Interest.crafts,
        Interest.fitness,
        Interest.photography,
      ],
      verification: VerificationStatus.verified,
      createdAt: DateTime.now().subtract(const Duration(days: 12)),
      lastActiveAt: DateTime.now().subtract(const Duration(minutes: 5)),
      isOnline: true,
      distanceKm: 1.1,
    ),

    // Ewa - mama pracująca
    MomProfile(
      id: 'ewa_kaminska',
      name: 'Ewa',
      age: 38,
      bio: 'Praca + 6-letni Jakub + 9-letnia Natalia = intensywne życie! 💼 Weekendy to czas na relaks i spotkania z przyjaciółkami.',
      photoUrls: [
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400&h=600&fit=crop&crop=face',
        'https://images.unsplash.com/photo-1494783367193-149034c05e8f?w=400&h=600&fit=crop&crop=face',
      ],
      children: [
        Child(
          id: 'jakub',
          age: 72, // 6 lat
          gender: Gender.male,
          name: 'Jakub',
        ),
        Child(
          id: 'natalia',
          age: 108, // 9 lat
          gender: Gender.female,
          name: 'Natalia',
        ),
      ],
      location: const Location(
        latitude: 50.0348,
        longitude: 19.9257,
        city: 'Kraków',
        district: 'Dębniki',
      ),
      interests: [
        Interest.fitness,
        Interest.reading,
        Interest.travel,
        Interest.coffee,
        Interest.music,
      ],
      verification: VerificationStatus.verified,
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
      lastActiveAt: DateTime.now().subtract(const Duration(hours: 3)),
      isOnline: false,
      distanceKm: 2.8,
    ),
  ];

  /// Pobierz losowe profile dla systemu matchingu
  static List<MomProfile> getRandomProfiles({int count = 5}) {
    final allProfiles = List<MomProfile>.from(sampleMoms);
    allProfiles.shuffle();
    return allProfiles.take(count).toList();
  }

  /// Znajdź profil po ID
  static MomProfile? findProfileById(String id) {
    try {
      return sampleMoms.firstWhere((profile) => profile.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Pobierz profile z określonej odległości
  static List<MomProfile> getProfilesInRange({double maxDistanceKm = 5.0}) {
    return sampleMoms.where((profile) => 
      profile.distanceKm != null && profile.distanceKm! <= maxDistanceKm
    ).toList();
  }
} 