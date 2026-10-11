import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:strath_clean/models/issue.dart';

class ApiService {
  ApiService._();

  static const _host = '100.100.167.38:8080';
  static const _timeout = Duration(seconds: 10);

  static Future<int?> login(String email, String password) async {
    final uri = Uri.http(_host, '/login', {
      'email': email,
      'password': password,
    });

    final response = await http.get(uri).timeout(_timeout);
    debugPrint('login: ${response.statusCode} ${response.body}');

    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) {
      throw Exception('Login failed (${response.statusCode})');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return (data['id'] as num).toInt();
  }

  /// Sends a new issue to the server. Throws with the server's message if
  /// it fails.
  static Future<void> createIssue({
    required int userId,
    required String roomCode,
    required String image,
    required int floor,
    required String building,
    required String description,
  }) async {
    final uri = Uri.http(_host, '/createIssue', {
      'roomCode': roomCode,
      'image': image,
      'floor': '$floor',
      'building': building,
      'description': description,
    });

    final response = await http
        .post(uri, headers: {'userId': '$userId'})
        .timeout(_timeout);
    debugPrint('createIssue: ${response.statusCode} ${response.body}');

    if (response.statusCode != 200) {
      throw Exception(
        response.body.isNotEmpty
            ? response.body
            : 'Failed to create issue (${response.statusCode})',
      );
    }
  }

  static Future<List<Issue>> getAllIssues() async {
    final uri = Uri.http(_host, '/getAllIssues');

    final response = await http.get(uri).timeout(_timeout);
    debugPrint('getAllIssues: ${response.statusCode} ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to load issues (${response.statusCode})');
    }

    final list = jsonDecode(response.body) as List;
    final issues = [
      for (final item in list) Issue.fromJson(item as Map<String, dynamic>),
    ];
    issues.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
    return issues;
  }
}
