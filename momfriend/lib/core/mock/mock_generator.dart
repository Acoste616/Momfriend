import 'dart:math';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/matching/data/models/match_profile.dart';
import 'mock_data.dart';

class MockGenerator {
  static final Random _random = Random();

  /// Generuje losowy profil do matchowania
  static MatchProfile generateRandomMatchProfile() {
    final names = [
      'Anna', 'Katarzyna', 'Magdalena', 'Paulina', 'Monika', 
      'Aleksandra', 'Justyna', 'Weronika', 'Ewa', 'Agnieszka',
      'Marta', 'Joanna', 'Barbara', 'Beata', 'Dorota'
    ];
    
    final childNames = [
      'Zuzia', 'Maks', 'Julia', 'Jakub', 'Oliwier', 'Lena', 
      'Filip', 'Natalia', 'Adam', 'Amelia', 'Zoe', 'Leon',
      'Michał', 'Kasia', 'Ania', 'Tomek', 'Ola', 'Bartek'
    ];

    final bios = [
      'Mama szukająca nowych przyjaźni 💚',
      'Kocham spacery z dzieckiem po parku 🌳',
      'Singielka szukająca wsparcia innych mam',
      'Organizuję spotkania dla rodzin 👨‍👩‍👧‍👦',
      'Pracuję zdalnie, szukam innych work-from-home mam 💻',
      'Doświadczona mama, chętnie podzielę się radami 💪',
      'Młoda mama uczę się macierzyństwa',
      'Chaos to moje drugie imię! 😄',
      'Miłośniczka kawy i dobrych rozmów ☕',
      'Pasjonuje się fotografią dziecięcą 📸'
    ];

    final name = names[_random.nextInt(names.length)];
    final age = 25 + _random.nextInt(15); // 25-39 lat
    final bio = bios[_random.nextInt(bios.length)];
    
    // Generuj losowe dzieci (1-3)
    final childrenCount = 1 + _random.nextInt(3);
    final children = <Child>[];
    
    for (int i = 0; i < childrenCount; i++) {
      final childAge = 1 + _random.nextInt(15); // 1-15 lat
      final gender = _random.nextBool() ? 'F' : 'M';
      final childName = childNames[_random.nextInt(childNames.length)];
      
      children.add(Child(
        id: 'child_${DateTime.now().millisecondsSinceEpoch}_$i',
        name: childName,
        age: childAge,
        gender: gender,
        birthYear: DateTime(DateTime.now().year - childAge),
      ));
    }

    // Losowe zainteresowania (3-6)
    final selectedInterests = <String>[];
    final availableInterests = List.from(MockData.popularInterests);
    final interestsCount = 3 + _random.nextInt(4);
    
    for (int i = 0; i < interestsCount; i++) {
      if (availableInterests.isNotEmpty) {
        final interest = availableInterests.removeAt(
          _random.nextInt(availableInterests.length)
        );
        selectedInterests.add(interest);
      }
    }

    return MatchProfile(
      id: 'generated_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      age: age,
      bio: bio,
      children: children,
      interests: selectedInterests,
      distance: 0.5 + _random.nextDouble() * 9.5, // 0.5-10 km
      profileImageUrl: 'https://i.pravatar.cc/400?img=${_random.nextInt(70) + 1}',
      isVerified: _random.nextBool(),
      matchScore: 60 + _random.nextInt(41), // 60-100%
    );
  }

  /// Generuje listę losowych profili
  static List<MatchProfile> generateRandomProfiles(int count) {
    return List.generate(count, (_) => generateRandomMatchProfile());
  }

  /// Generuje profil użytkownika
  static UserProfile generateRandomUserProfile() {
    final names = ['Anna', 'Katarzyna', 'Ewa', 'Magdalena', 'Paulina'];
    final name = names[_random.nextInt(names.length)];
    final age = 25 + _random.nextInt(15);
    
    final childrenCount = 1 + _random.nextInt(3);
    final children = <Child>[];
    
    for (int i = 0; i < childrenCount; i++) {
      final childAge = 1 + _random.nextInt(10);
      final gender = _random.nextBool() ? 'F' : 'M';
      
      children.add(Child(
        id: 'user_child_$i',
        name: 'Dziecko ${i + 1}',
        age: childAge,
        gender: gender,
        birthYear: DateTime(DateTime.now().year - childAge),
      ));
    }

    // Losowa lokalizacja w Warszawie
    final location = MockData.warsawLocations[
      _random.nextInt(MockData.warsawLocations.length)
    ];

    return UserProfile(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      age: age,
      bio: 'Mama szukająca nowych przyjaźni i wsparcia 💚',
      interests: MockData.popularInterests.take(5).toList(),
      children: children,
      profileImageUrl: 'https://i.pravatar.cc/400?img=${_random.nextInt(70) + 1}',
      isVerified: _random.nextBool(),
      latitude: location['lat'],
      longitude: location['lng'],
    );
  }

  /// Miesza istniejące profile z MockData
  static List<MatchProfile> getShuffledProfiles() {
    final profiles = List<MatchProfile>.from(MockData.mockMatchProfiles);
    profiles.shuffle(_random);
    return profiles;
  }

  /// Losuje podzbiór profili
  static List<MatchProfile> getRandomSubset(int count) {
    final allProfiles = MockData.mockMatchProfiles;
    final shuffled = List<MatchProfile>.from(allProfiles);
    shuffled.shuffle(_random);
    return shuffled.take(count).toList();
  }

  /// Generuje mieszankę prawdziwych i losowych profili
  static List<MatchProfile> getMixedProfiles(int totalCount) {
    final realProfiles = MockData.mockMatchProfiles;
    final profiles = <MatchProfile>[];
    
    // Dodaj wszystkie prawdziwe profile
    profiles.addAll(realProfiles);
    
    // Dodaj losowe profile do uzupełnienia
    final remaining = totalCount - realProfiles.length;
    if (remaining > 0) {
      profiles.addAll(generateRandomProfiles(remaining));
    }
    
    // Pomieszaj wszystkie
    profiles.shuffle(_random);
    return profiles.take(totalCount).toList();
  }
} 