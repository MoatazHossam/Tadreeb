class Profile {
  Profile({
    required this.id,
    required this.email,
    required this.username,
    required this.englishName,
    required this.arabicName,
    required this.fullName,
    required this.userType,
    required this.phone,
    required this.isVerified,
    required this.profilePicture,
    required this.dateOfBirth,
    required this.address,
    required this.nationality,
    required this.dateJoined,
  });

  final int id;
  final String email;
  final String username;
  final String englishName;
  final String arabicName;
  final String fullName;
  final String userType;
  final String phone;
  final bool isVerified;
  final String profilePicture;
  final DateTime? dateOfBirth;
  final String address;
  final String nationality;
  final DateTime? dateJoined;

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as int? ?? 0,
      email: (json['email'] as String?)?.trim() ?? '',
      username: (json['username'] as String?)?.trim() ?? '',
      englishName: (json['english_name'] as String?)?.trim() ?? '',
      arabicName: (json['arabic_name'] as String?)?.trim() ?? '',
      fullName: (json['full_name'] as String?)?.trim() ?? '',
      userType: (json['user_type'] as String?)?.trim() ?? '',
      phone: (json['phone'] as String?)?.trim() ?? '',
      isVerified: json['is_verified'] as bool? ?? false,
      profilePicture: (json['profile_picture'] as String?)?.trim() ?? '',
      dateOfBirth: _parseDate(json['date_of_birth']),
      address: (json['address'] as String?)?.trim() ?? '',
      nationality: (json['nationality'] as String?)?.trim() ?? '',
      dateJoined: _parseDate(json['date_joined']),
    );
  }

  String get displayName {
    if (fullName.isNotEmpty) return fullName;
    if (englishName.isNotEmpty) return englishName;
    if (arabicName.isNotEmpty) return arabicName;
    if (username.isNotEmpty) return username;
    return email;
  }
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is String && value.trim().isNotEmpty) {
    return DateTime.tryParse(value.trim());
  }
  return null;
}
