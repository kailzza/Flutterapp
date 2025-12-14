import 'dart:async';
import 'dart:convert';

import 'package:scholar_track/models/scholarship_app.dart';
import 'package:http/http.dart' as http;

class HttpApiService {
  HttpApiService._privateConstructor();
  static final HttpApiService instance = HttpApiService._privateConstructor();

  /// Base URL for the REST API. Examples:
  /// - Android emulator: http://10.0.2.2:8080/api
  /// - Local host machine (use machine IP for device): http://192.168.1.10/api
  String baseUrl = 'http://10.0.2.2:8080/api';

  Uri _endpoint(String path) => Uri.parse('$baseUrl$path');

  Future<List<ScholarshipApp>> fetchScholarships() async {
    try {
      final res = await http.get(_endpoint('/scholarships.php'));
      if (res.statusCode == 200) {
        final List<dynamic> raw = jsonDecode(res.body) as List<dynamic>;
        return raw.map((e) {
          final id = (e is Map && e.containsKey('id')) ? (e['id']?.toString() ?? '') : '';
          final map = Map<String, dynamic>.from(e as Map);
          return ScholarshipApp.fromMap(id, map);
        }).toList();
      }
    } catch (_) {
      // ignore errors and return empty list on failure
    }
    return <ScholarshipApp>[];
  }

  Stream<List<ScholarshipApp>> scholarshipsStream({Duration interval = const Duration(seconds: 5)}) async* {
    while (true) {
      final apps = await fetchScholarships();
      yield apps;
      await Future.delayed(interval);
    }
  }

  Future<String> createScholarship(ScholarshipApp app) async {
    try {
      final body = jsonEncode(app.toMap());
      final res = await http.post(_endpoint('/scholarships.php'), headers: {'Content-Type': 'application/json'}, body: body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        final resp = jsonDecode(res.body);
        if (resp is Map && resp.containsKey('id')) return resp['id'].toString();
        return '';
      }
    } catch (_) {
      // ignore
    }
    return '';
  }

  Future<void> addOrUpdateScholarship(ScholarshipApp app) async {
    if (app.id.isEmpty) { await createScholarship(app); return; }
    try {
      await http.put(_endpoint('/scholarships.php/${app.id}'), headers: {'Content-Type': 'application/json'}, body: jsonEncode(app.toMap()));
    } catch (_) {}
  }

  Future<bool> deleteScholarship(String id) async {
    try {
      final res = await http.delete(_endpoint('/scholarships.php/$id'));
      return res.statusCode == 200 || res.statusCode == 204;
    } catch (_) {
      return false;
    }
  }
}
