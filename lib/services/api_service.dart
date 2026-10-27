import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Central Service for communicating with FreshFlow FastAPI Backend
class ApiService {
  // Base configuration
  // For Web & Desktop: http://127.0.0.1:8000
  // For Android Emulator: http://10.0.2.2:8000
  static String baseUrl = 'http://127.0.0.1:8000';
  
  // API key header (Default local admin key for demo)
  static String apiKey = 'your_local_admin_key';
  
  // Demo snapshot date & store configured in backend seed-demo
  static String defaultDate = '2026-10-12';
  static String defaultStoreId = 'STORE_01';

  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'X-API-Key': apiKey,
  };

  /// 1. Health check — Verify connection with FastAPI server
  static Future<bool> checkHealth() async {
    try {
      final uri = Uri.parse('$baseUrl/health');
      final res = await http.get(uri).timeout(const Duration(seconds: 3));
      return res.statusCode == 200;
    } catch (e) {
      debugPrint('[ApiService] Health check failed: $e');
      return false;
    }
  }

  /// 2. Get Inventory Snapshots
  static Future<List<Map<String, dynamic>>> getInventory({
    String? date,
    String? storeId,
    int? maxDays,
    bool inStockOnly = false,
    int limit = 200,
  }) async {
    final queryParams = <String, String>{
      'date': date ?? defaultDate,
      'limit': limit.toString(),
      if (inStockOnly) 'in_stock_only': 'true',
    };
    if (storeId != null) queryParams['store_id'] = storeId;
    if (maxDays != null) queryParams['max_days'] = maxDays.toString();

    final uri = Uri.parse('$baseUrl/api/v1/inventory').replace(queryParameters: queryParams);
    final res = await http.get(uri, headers: _headers).timeout(const Duration(seconds: 5));

    if (res.statusCode == 200) {
      final dynamic data = jsonDecode(utf8.decode(res.bodyBytes));
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      } else if (data is Map && data['items'] is List) {
        return List<Map<String, dynamic>>.from(data['items']);
      }
      return [];
    }
    throw Exception('Failed to load inventory (${res.statusCode}): ${res.body}');
  }

  /// 3. Get Dashboard Summary
  static Future<Map<String, dynamic>> getDashboardSummary({
    String? date,
    String? storeId,
  }) async {
    final queryParams = <String, String>{
      'date': date ?? defaultDate,
      'store_id': storeId ?? defaultStoreId,
    };

    final uri = Uri.parse('$baseUrl/api/v1/dashboard/summary').replace(queryParameters: queryParams);
    final res = await http.get(uri, headers: _headers).timeout(const Duration(seconds: 5));

    if (res.statusCode == 200) {
      return Map<String, dynamic>.from(jsonDecode(utf8.decode(res.bodyBytes)));
    }
    throw Exception('Failed to load dashboard summary (${res.statusCode}): ${res.body}');
  }

  /// 4. Get Recommendations (Pricing & Restock proposals)
  static Future<List<Map<String, dynamic>>> getRecommendations({
    String? date,
    String? storeId,
  }) async {
    final queryParams = <String, String>{
      'date': date ?? defaultDate,
      'store_id': storeId ?? defaultStoreId,
    };

    final uri = Uri.parse('$baseUrl/api/v1/recommendations').replace(queryParameters: queryParams);
    final res = await http.get(uri, headers: _headers).timeout(const Duration(seconds: 5));

    if (res.statusCode == 200) {
      final dynamic data = jsonDecode(utf8.decode(res.bodyBytes));
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      } else if (data is Map && data['items'] is List) {
        return List<Map<String, dynamic>>.from(data['items']);
      }
      return [];
    }
    throw Exception('Failed to load recommendations (${res.statusCode}): ${res.body}');
  }

  /// 5. Trigger new Recommendation Run (e.g. for rain or clear scenario)
  static Future<Map<String, dynamic>> createRecommendationRun({
    required String scenarioId,
    String? date,
    String? storeId,
  }) async {
    final uri = Uri.parse('$baseUrl/api/v1/recommendation-runs');
    final payload = {
      'request_id': 'run-${DateTime.now().millisecondsSinceEpoch}',
      'snapshot_date': date ?? defaultDate,
      'store_id': storeId ?? defaultStoreId,
      'scenario_id': scenarioId, // 'clear-demo' or 'rain-demo'
      'rule_version': 'rules_v1',
      'prediction_source': 'MOCK',
    };

    final res = await http.post(
      uri,
      headers: _headers,
      body: jsonEncode(payload),
    ).timeout(const Duration(seconds: 8));

    if (res.statusCode == 200 || res.statusCode == 201) {
      return Map<String, dynamic>.from(jsonDecode(utf8.decode(res.bodyBytes)));
    }
    throw Exception('Failed to run recommendation (${res.statusCode}): ${res.body}');
  }

  /// 6. Approve or Reject Recommendation
  static Future<bool> updateRecommendationStatus({
    required String recommendationId,
    required String status, // 'APPROVED' or 'REJECTED'
  }) async {
    final uri = Uri.parse('$baseUrl/api/v1/recommendations/$recommendationId/status');
    final res = await http.patch(
      uri,
      headers: _headers,
      body: jsonEncode({'status': status}),
    ).timeout(const Duration(seconds: 5));

    return res.statusCode == 200;
  }

  /// 7. Get Customer Deals (Public endpoint)
  static Future<List<Map<String, dynamic>>> getDeals({
    String? date,
  }) async {
    final queryParams = <String, String>{
      'date': date ?? defaultDate,
    };

    final uri = Uri.parse('$baseUrl/api/v1/deals').replace(queryParameters: queryParams);
    final res = await http.get(uri).timeout(const Duration(seconds: 5));

    if (res.statusCode == 200) {
      final dynamic data = jsonDecode(utf8.decode(res.bodyBytes));
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      } else if (data is Map && data['items'] is List) {
        return List<Map<String, dynamic>>.from(data['items']);
      }
      return [];
    }
    throw Exception('Failed to load deals (${res.statusCode}): ${res.body}');
  }

  /// 8. Get Stores
  static Future<List<Map<String, dynamic>>> getStores() async {
    final uri = Uri.parse('$baseUrl/api/v1/stores');
    final res = await http.get(uri, headers: _headers).timeout(const Duration(seconds: 5));

    if (res.statusCode == 200) {
      final dynamic data = jsonDecode(utf8.decode(res.bodyBytes));
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      }
      return [];
    }
    throw Exception('Failed to load stores (${res.statusCode})');
  }

  /// 9. Get Notifications
  static Future<List<Map<String, dynamic>>> getNotifications() async {
    final uri = Uri.parse('$baseUrl/api/v1/notifications');
    final res = await http.get(uri, headers: _headers).timeout(const Duration(seconds: 5));

    if (res.statusCode == 200) {
      final dynamic data = jsonDecode(utf8.decode(res.bodyBytes));
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      } else if (data is Map && data['items'] is List) {
        return List<Map<String, dynamic>>.from(data['items']);
      }
      return [];
    }
    throw Exception('Failed to load notifications (${res.statusCode})');
  }

  /// 10. Mark Notification as read
  static Future<bool> markNotificationRead(String id) async {
    final uri = Uri.parse('$baseUrl/api/v1/notifications/$id/read');
    final res = await http.patch(uri, headers: _headers).timeout(const Duration(seconds: 5));
    return res.statusCode == 200;
  }
}
