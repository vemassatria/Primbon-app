import 'package:intl/intl.dart';
import 'constants.dart';
import '../models/weton_model.dart';
import '../models/compatibility_model.dart';

class WetonCalculator {
  static final DateTime _baseDate = DateTime(1900, 1, 1); // Senin Pon

  /// Hitung Weton dari tanggal lahir
  static WetonModel calculateWeton(DateTime birthDate) {
    final int daysDiff = birthDate.difference(_baseDate).inDays;

    // Pastikan index hari dan pasaran berada dalam rentang positif
    final int dayIndex = (daysDiff % 7 + 7) % 7;
    final int pasaranIndex = (daysDiff % 5 + 5) % 5;

    final String dayName = WetonConstants.dayNames[dayIndex];
    final int dayValue = WetonConstants.dayValues[dayName]!;
    final String pasaranName = WetonConstants.pasaranNames[pasaranIndex];
    final int pasaranValue = WetonConstants.pasaranValues[pasaranName]!;

    final int totalNeptu = dayValue + pasaranValue;
    final String traits = getTraits(dayName, pasaranName);
    final List<String> directions = getGoodDirections(dayName, pasaranName);
    final List<String> goodDays = getGoodDays(dayName);
    final String fortune = getFortuneType(totalNeptu);
    final List<String> luckyColors = getLuckyColors(dayName, pasaranName);

    return WetonModel(
      dayName: dayName,
      pasaranName: pasaranName,
      dayValue: dayValue,
      pasaranValue: pasaranValue,
      totalNeptu: totalNeptu,
      traits: traits,
      goodDirections: directions,
      goodDays: goodDays,
      fortuneType: fortune,
      luckyColors: luckyColors,
    );
  }

  /// Hitung kecocokan jodoh dari dua tanggal lahir
  static CompatibilityModel calculateCompatibility(
    String person1Name,
    DateTime person1BirthDate,
    String person2Name,
    DateTime person2BirthDate,
  ) {
    final weton1 = calculateWeton(person1BirthDate);
    final weton2 = calculateWeton(person2BirthDate);

    final int neptuSum = weton1.totalNeptu + weton2.totalNeptu;

    final double bibitScore = calculateBibitScore(weton1, weton2);
    final double bebetScore = calculateBebetScore(weton1, weton2);
    final double bobotScore = calculateBobotScore(weton1, weton2);

    final double total = (bibitScore + bebetScore + bobotScore) / 3;
    final String interpretation = getCompatibilityInterpretation(
      total,
      bibitScore,
      bebetScore,
      bobotScore,
    );
    final List<String> suggestions = getCompatibilitySuggestions(
      total,
      bibitScore,
      bebetScore,
      bobotScore,
    );

    return CompatibilityModel(
      person1Name: person1Name,
      person1Weton: '${weton1.dayName} ${weton1.pasaranName}',
      person1Neptu: weton1.totalNeptu,
      person2Name: person2Name,
      person2Weton: '${weton2.dayName} ${weton2.pasaranName}',
      person2Neptu: weton2.totalNeptu,
      totalCompatibility: total,
      bibitScore: bibitScore,
      bebetScore: bebetScore,
      bobotScore: bobotScore,
      interpretation: interpretation,
      suggestions: suggestions,
    );
  }

  /// Traits berdasarkan kombinasi hari dan pasaran
  static String getTraits(String day, String pasaran) {
    final traitsMap = {
      'Senin': {
        'Pon': 'Cerdas, komunikatif, adaptif.',
        'Wage': 'Teliti, setia, pekerja keras.',
        'Kliwon': 'Bijak, reflektif, penuh intuisi.',
        'Legi': 'Ramah, sosial tinggi, hangat.',
        'Pahing': 'Tegas, idealis, tangguh.',
      },
      'Selasa': {
        'Pon': 'Ambisius, cepat berpikir.',
        'Wage': 'Tradisional, rapi.',
        'Kliwon': 'Berani, pemimpin.',
        'Legi': 'Sabar, ulet.',
        'Pahing': 'Inovatif, mandiri.',
      },
      'Rabu': {
        'Pon': 'Pemikir, pendiam.',
        'Wage': 'Analitis, pendiam.',
        'Kliwon': 'Bijak, tenang.',
        'Legi': 'Sosial tinggi.',
        'Pahing': 'Penuh ide.',
      },
      'Kamis': {
        'Pon': 'Optimis, ramah.',
        'Wage': 'Serius, pemalu.',
        'Kliwon': 'Pemimpin alami.',
        'Legi': 'Suka belajar.',
        'Pahing': 'Filosofis.',
      },
      'Jumat': {
        'Pon': 'Disiplin, tangguh.',
        'Wage': 'Rendah hati.',
        'Kliwon': 'Bijaksana.',
        'Legi': 'Berjiwa seni.',
        'Pahing': 'Berwibawa.',
      },
      'Sabtu': {
        'Pon': 'Kreatif, tekun.',
        'Wage': 'Mandiri.',
        'Kliwon': 'Tegas.',
        'Legi': 'Suka petualangan.',
        'Pahing': 'Pemimpin.',
      },
      'Minggu': {
        'Pon': 'Enerjik.',
        'Wage': 'Lembut.',
        'Kliwon': 'Penuh semangat.',
        'Legi': 'Optimis.',
        'Pahing': 'Cerdas.',
      },
    };

    return traitsMap[day]?[pasaran] ??
        'Memiliki karakter unik dengan kombinasi kelebihan dan tantangan.';
  }

  /// Arah yang baik berdasarkan hari
  static List<String> getGoodDirections(String day, String pasaran) {
    final map = {
      'Senin': ['Utara', 'Timur'],
      'Selasa': ['Timur', 'Selatan'],
      'Rabu': ['Selatan', 'Barat'],
      'Kamis': ['Barat', 'Utara'],
      'Jumat': ['Timur Laut', 'Tenggara'],
      'Sabtu': ['Barat Daya', 'Barat Laut'],
      'Minggu': ['Utara', 'Selatan'],
    };
    return map[day] ?? ['Timur'];
  }

  /// Hari yang cocok berdasarkan hari lahir
  static List<String> getGoodDays(String day) {
    final map = {
      'Senin': ['Rabu', 'Jumat'],
      'Selasa': ['Kamis', 'Sabtu'],
      'Rabu': ['Senin', 'Jumat'],
      'Kamis': ['Selasa', 'Sabtu'],
      'Jumat': ['Senin', 'Rabu'],
      'Sabtu': ['Selasa', 'Kamis'],
      'Minggu': ['Rabu', 'Sabtu'],
    };
    return map[day] ?? ['Rabu'];
  }

  /// Tipe rejeki berdasarkan nilai neptu
  static String getFortuneType(int neptu) {
    if (neptu <= 9) return 'Stabil, datang secara konsisten';
    if (neptu <= 13) return 'Berkala, terkadang besar terkadang kecil';
    if (neptu <= 16) return 'Melimpah, datang dari berbagai sumber';
    return 'Variatif, perlu kerja keras dan kejelian';
  }

  /// Warna keberuntungan berdasarkan hari
  static List<String> getLuckyColors(String day, String pasaran) {
    final colorMap = {
      'Senin': ['Putih', 'Biru'],
      'Selasa': ['Merah', 'Putih'],
      'Rabu': ['Hijau', 'Kuning'],
      'Kamis': ['Kuning', 'Emas'],
      'Jumat': ['Putih', 'Hijau'],
      'Sabtu': ['Hitam', 'Ungu'],
      'Minggu': ['Merah', 'Oranye'],
    };
    return colorMap[day] ?? ['Putih'];
  }

  /// Aspek Bibit: Kecocokan karakter dasar
  static double calculateBibitScore(WetonModel w1, WetonModel w2) {
    int diff = (w1.totalNeptu - w2.totalNeptu).abs();
    if (diff <= 2) return 95.0;
    if (diff <= 4) return 85.0;
    if (diff <= 6) return 75.0;
    if (diff <= 8) return 65.0;
    return 60.0;
  }

  /// Aspek Bebet: Pengaruh lingkungan, keluarga, sosial
  static double calculateBebetScore(WetonModel w1, WetonModel w2) {
    int sum = w1.totalNeptu + w2.totalNeptu;
    if (sum % 4 == 0) return 90.0;
    if (sum % 4 == 1) return 80.0;
    if (sum % 4 == 2) return 70.0;
    return 60.0;
  }

  /// Aspek Bobot: Keseimbangan emosional, ekonomi, spiritual
  static double calculateBobotScore(WetonModel w1, WetonModel w2) {
    int sum = w1.totalNeptu + w2.totalNeptu;
    if (sum % 5 == 0) return 90.0;
    if (sum % 5 == 1) return 85.0;
    if (sum % 5 == 2) return 80.0;
    if (sum % 5 == 3) return 75.0;
    return 70.0;
  }

  /// Interpretasi akhir
  static String getCompatibilityInterpretation(
    double total,
    double bibit,
    double bebet,
    double bobot,
  ) {
    if (total >= 85)
      return 'Kecocokan sangat tinggi. Harmonis dan saling melengkapi.';
    if (total >= 70)
      return 'Cukup serasi. Perlu saling pengertian dan kompromi.';
    return 'Perbedaan cukup besar. Butuh usaha dan komunikasi lebih untuk menjalin hubungan.';
  }

  /// Saran hubungan berdasarkan nilai
  static List<String> getCompatibilitySuggestions(
    double total,
    double bibit,
    double bebet,
    double bobot,
  ) {
    final List<String> suggestions = [];

    if (bibit < 80)
      suggestions.add('Kenali sifat dasar masing-masing dan cari titik temu.');
    if (bebet < 80)
      suggestions.add(
        'Perhatikan dukungan lingkungan dan komunikasi dengan keluarga.',
      );
    if (bobot < 80)
      suggestions.add('Perkuat komitmen finansial dan emosional.');

    if (suggestions.isEmpty) {
      suggestions.add(
        'Pasangan sangat cocok. Pertahankan komunikasi dan saling menghargai.',
      );
    }

    return suggestions;
  }
}
