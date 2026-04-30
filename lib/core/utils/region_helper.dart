// ISO-3166 country code -> TheMealDB Area (see /list.php?a=list)
class RegionHelper {
  RegionHelper._();

  static const Map<String, String> _countryToArea = {
    'US': 'American',
    'GB': 'British',
    'CA': 'Canadian',
    'CN': 'Chinese',
    'HR': 'Croatian',
    'NL': 'Dutch',
    'EG': 'Egyptian',
    'FR': 'French',
    'GR': 'Greek',
    'IN': 'Indian',
    'IE': 'Irish',
    'IT': 'Italian',
    'JM': 'Jamaican',
    'JP': 'Japanese',
    'KE': 'Kenyan',
    'MY': 'Malaysian',
    'MX': 'Mexican',
    'MA': 'Moroccan',
    'PL': 'Polish',
    'PT': 'Portuguese',
    'RU': 'Russian',
    'ES': 'Spanish',
    'TH': 'Thai',
    'TN': 'Tunisian',
    'TR': 'Turkish',
    'UA': 'Ukrainian',
    'VN': 'Vietnamese',
    // neighbours mapped to nearest cuisine
    'PK': 'Indian',
    'BD': 'Indian',
    'LK': 'Indian',
    'NP': 'Indian',
    'AU': 'British',
    'NZ': 'British',
    'DE': 'Dutch',
    'BE': 'Dutch',
    'TW': 'Chinese',
    'HK': 'Chinese',
    'SG': 'Malaysian',
    'ID': 'Malaysian',
    'PH': 'Malaysian',
    'KR': 'Japanese',
    'BR': 'Portuguese',
    'AR': 'Spanish',
    'CL': 'Spanish',
    'CO': 'Spanish',
    'PE': 'Spanish',
    'AT': 'Dutch',
    'CH': 'French',
    'DZ': 'Moroccan',
    'LY': 'Tunisian',
    'IR': 'Turkish',
    'IQ': 'Turkish',
    'SA': 'Egyptian',
    'AE': 'Egyptian',
  };

  static String? areaForCountry(String? isoCode) {
    if (isoCode == null) return null;
    return _countryToArea[isoCode.toUpperCase()];
  }
}
