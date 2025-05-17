import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:admin_app_flutter/auth/auth_service.dart';

class ApiService {
  static const String _baseUrl = 'https://amsstores1.leapmile.com/robotmanager';
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>> loginUser(String phone, String password) async {
    final url = Uri.parse(
      '$_baseUrl/validate?user_phone=$phone&password=$password',
    );
    final response = await http.get(
      url,
      headers: {'accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {
        'status': 'failure',
        'message': 'Invalid user or network error',
        'status_code': response.statusCode,
      };
    }
  }

  Future<Map<String, dynamic>> fetchSlots({
    int offset = 0,
    int numRecords = 10,
    String orderByField = 'updated_at',
    String orderByType = 'ASC',
  }) async {
    final token = await _authService.getToken();
    if (token == null) {
      return {'status': 'failure', 'message': 'Token not found or expired'};
    }

    final url = Uri.parse(
      '$_baseUrl/slots?order_by_field=$orderByField&order_by_type=$orderByType&num_records=$numRecords&offset=$offset',
    );

    final response = await http.get(
      url,
      headers: {'accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {
        'status': 'failure',
        'message': 'Failed to fetch slots',
        'status_code': response.statusCode,
      };
    }
  }

  Future<Map<String, dynamic>> fetchTrays({
    required int offset,
    required int numRecords,
  }) async {
    final token = await _authService.getToken();
    if (token == null) {
      return {'status': 'failure', 'message': 'Token not found or expired'};
    }
    final uri = Uri.parse(
      '$_baseUrl/trays?order_by_field=updated_at&order_by_type=ASC&num_records=$numRecords&offset=$offset',
    );
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    return jsonDecode(response.body);
  }
}
