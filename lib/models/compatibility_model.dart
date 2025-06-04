class CompatibilityModel {
  final String person1Name;
  final String person1Weton;
  final int person1Neptu;
  final String person2Name;
  final String person2Weton;
  final int person2Neptu;
  final double totalCompatibility;
  final double bibitScore;
  final double bebetScore;
  final double bobotScore;
  final String interpretation;
  final List<String> suggestions;
  
  CompatibilityModel({
    required this.person1Name,
    required this.person1Weton,
    required this.person1Neptu,
    required this.person2Name,
    required this.person2Weton,
    required this.person2Neptu,
    required this.totalCompatibility,
    required this.bibitScore,
    required this.bebetScore,
    required this.bobotScore,
    required this.interpretation,
    required this.suggestions,
  });
}