import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/matching/data/models/match_profile.dart';

class MockData {
  // Przykładowe profile użytkowniczek dla swipowania
  static List<MatchProfile> get mockMatchProfiles => [
    MatchProfile(
      id: 'match_1',
      name: 'Anna',
      age: 32,
      bio: 'Mama Zuzi (2l). Uwielbiam kawę i spacery po parku 🌳\nSzukam innych mam do wspólnych spacerów!',
      profileImageUrl: 'https://i.pravatar.cc/400?img=1',
      children: [
        Child(
          id: 'child_1',
          name: 'Zuzia',
          age: 2,
          gender: 'F',
          birthYear: DateTime(2022),
        ),
      ],
      interests: ['spacery', 'kawa', 'książki', 'yoga'],
      distance: 2.5,
      isVerified: true,
      matchScore: 95,
    ),
    
    MatchProfile(
      id: 'match_2',
      name: 'Katarzyna',
      age: 29,
      bio: 'Singielka z 3-latkiem. Szukam wsparcia i nowych przyjaźni 💚\nUwielbiam gotowanie i eksperymenty kulinarne.',
      profileImageUrl: 'https://i.pravatar.cc/400?img=2',
      children: [
        Child(
          id: 'child_2',
          name: 'Maks',
          age: 3,
          gender: 'M',
          birthYear: DateTime(2021),
        ),
      ],
      interests: ['yoga', 'gotowanie', 'parki', 'mindfulness'],
      distance: 1.8,
      isVerified: true,
      matchScore: 88,
    ),
    
    MatchProfile(
      id: 'match_3',
      name: 'Magdalena',
      age: 35,
      bio: 'Mama bliźniaków (5l). Doświadczona mama, która kocha dzielić się radami 👶👶\nPasjonuje się fotografią dziecięcą.',
      profileImageUrl: 'https://i.pravatar.cc/400?img=3',
      children: [
        Child(
          id: 'child_3a',
          name: 'Julia',
          age: 5,
          gender: 'F',
          birthYear: DateTime(2019),
        ),
        Child(
          id: 'child_3b',
          name: 'Jakub',
          age: 5,
          gender: 'M',
          birthYear: DateTime(2019),
        ),
      ],
      interests: ['fotografia', 'spacery', 'przyroda', 'sztuka'],
      distance: 4.2,
      isVerified: true,
      matchScore: 82,
    ),
    
    MatchProfile(
      id: 'match_4',
      name: 'Paulina',
      age: 27,
      bio: 'Młoda mama roczniaka 👶 Uczę się macierzyństwa i szukam wsparcia\nKocham muzykę i tańczenie!',
      profileImageUrl: 'https://i.pravatar.cc/400?img=4',
      children: [
        Child(
          id: 'child_4',
          name: 'Oliwier',
          age: 1,
          gender: 'M',
          birthYear: DateTime(2023),
        ),
      ],
      interests: ['muzyka', 'taniec', 'fitness', 'książki'],
      distance: 0.9,
      isVerified: false,
      matchScore: 91,
    ),
    
    MatchProfile(
      id: 'match_5',
      name: 'Monika',
      age: 31,
      bio: 'Mama dwójki dzieci. Organizuję spotkania dla rodzin 👨‍👩‍👧‍👦\nZapraszam na wspólne pikniki!',
      profileImageUrl: 'https://i.pravatar.cc/400?img=5',
      children: [
        Child(
          id: 'child_5a',
          name: 'Lena',
          age: 4,
          gender: 'F',
          birthYear: DateTime(2020),
        ),
        Child(
          id: 'child_5b',
          name: 'Filip',
          age: 2,
          gender: 'M',
          birthYear: DateTime(2022),
        ),
      ],
      interests: ['organizowanie eventów', 'pikniki', 'gotowanie', 'gry planszowe'],
      distance: 3.7,
      isVerified: true,
      matchScore: 76,
    ),
    
    MatchProfile(
      id: 'match_6',
      name: 'Aleksandra',
      age: 33,
      bio: 'Mama nastolatki i przedszkolaka. Doświadczona w wychowaniu 💪\nPomogę w każdej sytuacji!',
      profileImageUrl: 'https://i.pravatar.cc/400?img=6',
      children: [
        Child(
          id: 'child_6a',
          name: 'Natalia',
          age: 13,
          gender: 'F',
          birthYear: DateTime(2011),
        ),
        Child(
          id: 'child_6b',
          name: 'Adam',
          age: 6,
          gender: 'M',
          birthYear: DateTime(2018),
        ),
      ],
      interests: ['psychologia dziecięca', 'sport', 'czytanie', 'podróże'],
      distance: 5.1,
      isVerified: true,
      matchScore: 79,
    ),
    
    MatchProfile(
      id: 'match_7',
      name: 'Justyna',
      age: 28,
      bio: 'Mama 3-latki, pracuję zdalnie 💻 Szukam innych work-from-home mam\nCo powiecie na wspólną kawę w trakcie pracy?',
      profileImageUrl: 'https://i.pravatar.cc/400?img=7',
      children: [
        Child(
          id: 'child_7',
          name: 'Amelia',
          age: 3,
          gender: 'F',
          birthYear: DateTime(2021),
        ),
      ],
      interests: ['praca zdalna', 'technologie', 'kawa', 'rozwój osobisty'],
      distance: 2.3,
      isVerified: true,
      matchScore: 86,
    ),
    
    MatchProfile(
      id: 'match_8',
      name: 'Weronika',
      age: 30,
      bio: 'Mama bliźniaków 2-latków 👶👶 Chaos to moje drugie imię!\nSzukam kogoś, kto zrozumie moje szaleństwo 😄',
      profileImageUrl: 'https://i.pravatar.cc/400?img=8',
      children: [
        Child(
          id: 'child_8a',
          name: 'Zoe',
          age: 2,
          gender: 'F',
          birthYear: DateTime(2022),
        ),
        Child(
          id: 'child_8b',
          name: 'Leon',
          age: 2,
          gender: 'M',
          birthYear: DateTime(2022),
        ),
      ],
      interests: ['survival parenting', 'humor', 'pizza', 'Netflix'],
      distance: 1.5,
      isVerified: true,
      matchScore: 93,
    ),
  ];

  // Przykładowy profil użytkownika (główny)
  static UserProfile get mockUserProfile => UserProfile(
    id: 'user_main',
    name: 'Ty',
    age: 30,
    bio: 'Mama szukająca nowych przyjaźni i wsparcia 💚',
    interests: ['spacery', 'kawa', 'książki', 'yoga', 'gotowanie'],
    children: [
      Child(
        id: 'user_child_1',
        name: 'Twoje dziecko',
        age: 3,
        gender: 'F',
        birthYear: DateTime(2021),
      ),
    ],
    profileImageUrl: 'https://i.pravatar.cc/400?img=9',
    isVerified: true,
    latitude: 52.2297,
    longitude: 21.0122,
  );

  // Dodatkowe przykładowe profile dla różnych scenariuszy
  static List<UserProfile> get mockUserProfiles => [
    mockUserProfile,
    UserProfile(
      id: 'user_2',
      name: 'Ewa',
      age: 34,
      bio: 'Mama dwójki dzieci, miłośniczka natury',
      interests: ['hiking', 'fotografia', 'gotowanie', 'czytanie'],
      children: [
        Child(
          id: 'user2_child_1',
          name: 'Michał',
          age: 5,
          gender: 'M',
          birthYear: DateTime(2019),
        ),
        Child(
          id: 'user2_child_2',
          name: 'Kasia',
          age: 2,
          gender: 'F',
          birthYear: DateTime(2022),
        ),
      ],
      profileImageUrl: 'https://i.pravatar.cc/400?img=10',
      isVerified: true,
      latitude: 52.2397,
      longitude: 21.0222,
    ),
  ];

  // Popularne zainteresowania do wyboru
  static List<String> get popularInterests => [
    'spacery',
    'kawa',
    'książki',
    'yoga',
    'gotowanie',
    'fitness',
    'muzyka',
    'taniec',
    'fotografia',
    'sztuka',
    'przyroda',
    'podróże',
    'gry planszowe',
    'film',
    'teatro',
    'sport',
    'bieganie',
    'rower',
    'pływanie',
    'mindfulness',
    'psychologia',
    'rozwój osobisty',
    'technologie',
    'praca zdalna',
    'organizowanie eventów',
    'pikniki',
    'plaże',
    'góry',
    'lasy',
    'parki',
    'kawiarnie',
    'restauracje',
    'zakupy',
    'DIY',
    'handmade',
    'szycie',
    'malowanie',
    'ceramika',
  ];

  // Przykładowe lokalizacje w Warszawie
  static List<Map<String, dynamic>> get warsawLocations => [
    {'name': 'Śródmieście', 'lat': 52.2297, 'lng': 21.0122},
    {'name': 'Mokotów', 'lat': 52.1907, 'lng': 21.0348},
    {'name': 'Żoliborz', 'lat': 52.2584, 'lng': 21.0106},
    {'name': 'Praga-Południe', 'lat': 52.2442, 'lng': 21.0654},
    {'name': 'Ursynów', 'lat': 52.1394, 'lng': 21.0493},
    {'name': 'Wilanów', 'lat': 52.1653, 'lng': 21.0900},
    {'name': 'Bielany', 'lat': 52.2891, 'lng': 20.9334},
    {'name': 'Wola', 'lat': 52.2411, 'lng': 20.9803},
  ];
} 