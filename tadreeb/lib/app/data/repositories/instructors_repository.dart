import 'dart:convert';
import 'dart:developer';

import '../../core/constants/constants.dart';
import '../models/instructor.dart';
import '../providers/api_provider.dart';

class PaginatedResponse<T> {
  PaginatedResponse({
    required this.count,
    required this.results,
    this.next,
    this.previous,
  });

  final int count;
  final String? next;
  final String? previous;
  final List<T> results;

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    final primaryCount = json['count'] as int?;
    var next = json['next'] as String?;
    var previous = json['previous'] as String?;
    final parsedResults = <T>[];

    final rawResults = json['results'];
    if (rawResults is List) {
      for (final item in rawResults) {
        if (item is Map<String, dynamic> && item['results'] is List) {
          final nestedResults = item['results'] as List<dynamic>;
          for (final nested in nestedResults) {
            if (nested is Map<String, dynamic>) {
              parsedResults.add(fromJson(nested));
            }
          }
          next ??= item['next'] as String?;
          previous ??= item['previous'] as String?;
        } else if (item is Map<String, dynamic>) {
          parsedResults.add(fromJson(item));
        }
      }
    }

    return PaginatedResponse(
      count: primaryCount ?? parsedResults.length,
      results: parsedResults,
      next: next,
      previous: previous,
    );
  }
}

class InstructorsRepository {
  InstructorsRepository(this._apiProvider);

  final ApiProvider _apiProvider;

  Future<PaginatedResponse<Instructor>> fetchInstructors({
    int offset = 0,
    int limit = 20,
    String? ordering,
    int? specialization,
    bool? isAvailable,
    String? language,
    String? location,
    double? maxPrice,
    double? minPrice,
    double? minRating,
  }) async {
    final response = await _apiProvider.get(
      Constants.trainers,
      queryParameters: {
        'offset': offset,
        'limit': limit,
        if (ordering != null) 'ordering': ordering,
        if (specialization != null) 'specialization': specialization,
        if (isAvailable != null) 'is_available': isAvailable,
        if (language != null) 'language': language,
        if (location != null) 'location': location,
        if (maxPrice != null) 'max_price': maxPrice,
        if (minPrice != null) 'min_price': minPrice,
        if (minRating != null) 'min_rating': minRating,
      },
    );

    return PaginatedResponse.fromJson(
      response,
      (json) => Instructor.fromApiJson(json),
    );
  }

  Future<Instructor> fetchInstructorById(int id) async {
    final response = await _apiProvider.get('${Constants.trainers}$id/');
    log('Fetched instructor details: ${json.encode(response)}');

    return Instructor.fromApiJson(response);
  }

  Future<List<InstructorPackage>> fetchInstructorPackages(int id) async {
    final response = await _apiProvider.get('${Constants.trainers}$id/packages/');
    return parseInstructorPackages(response['packages']);
  }
}
