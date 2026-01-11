class Booking {
  Booking({
    required this.id,
    required this.bookingReference,
    required this.traineeName,
    required this.trainerName,
    required this.trainerProfilePicture,
    required this.packageName,
    required this.finalPrice,
    required this.startDate,
    required this.status,
    required this.statusDisplay,
    required this.createdAt,
  });

  final int id;
  final String bookingReference;
  final String traineeName;
  final String trainerName;
  final String? trainerProfilePicture;
  final String packageName;
  final String finalPrice;
  final DateTime? startDate;
  final String status;
  final String statusDisplay;
  final DateTime? createdAt;

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as int? ?? 0,
      bookingReference: (json['booking_reference'] as String?)?.trim() ?? '',
      traineeName: (json['trainee_name'] as String?)?.trim() ?? '',
      trainerName: (json['trainer_name'] as String?)?.trim() ?? '',
      trainerProfilePicture: (json['trainer_profile_picture'] as String?)?.trim(),
      packageName: (json['package_name'] as String?)?.trim() ?? '',
      finalPrice: (json['final_price'] as String?)?.trim() ?? '',
      startDate: _parseDate(json['start_date']),
      status: (json['status'] as String?)?.trim() ?? '',
      statusDisplay: (json['status_display'] as String?)?.trim() ?? '',
      createdAt: _parseDate(json['created_at']),
    );
  }

  bool get isCompleted {
    final normalized = status.toLowerCase();
    return normalized == 'completed' ||
        normalized == 'done' ||
        normalized == 'finished';
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
