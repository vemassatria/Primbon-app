class WetonConstants {
  static const Map<String, int> dayValues = {
    'Senin': 4,
    'Selasa': 3,
    'Rabu': 7,
    'Kamis': 8,
    'Jumat': 6,
    'Sabtu': 9,
    'Minggu': 5,
  };

  static const Map<String, int> pasaranValues = {
    'Pahing': 9,
    'Pon': 7,
    'Wage': 4,
    'Kliwon': 8,
    'Legi': 5,
  };

  static const List<String> dayNames = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  static const List<String> pasaranNames = [
    'Pahing', // index 4
    'Pon', // index 0 → 1 Jan 1900
    'Wage', // index 1
    'Kliwon', // index 2
    'Legi', // index 3
  ];
}
