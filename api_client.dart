import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  ApiClient({this.baseUrl='http://10.0.2.2:3000/api'});

  Future<Map<String,dynamic>> get(String path) async {
    final r=await http.get(Uri.parse('$baseUrl$path'));
    return _decode(r);
  }

  Future<Map<String,dynamic>> post(String path, Map<String,dynamic> body) async {
    final r=await http.post(Uri.parse('$baseUrl$path'),
      headers:{'Content-Type':'application/json'}, body:jsonEncode(body));
    return _decode(r);
  }

  Map<String,dynamic> _decode(http.Response r) {
    final data=jsonDecode(r.body);
    if(r.statusCode<200 || r.statusCode>=300) {
      throw Exception(data is Map ? (data['message'] ?? 'Request failed') : 'Request failed');
    }
    return Map<String,dynamic>.from(data);
  }
}
