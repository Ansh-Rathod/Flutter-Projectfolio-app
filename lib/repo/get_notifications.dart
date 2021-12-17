import 'dart:convert';

import 'package:http/http.dart' as http;

import '../api_key.dart';

class GetNotifications {
  Future<List<dynamic>> getNotifications(String id) async {
    // print(id.toLowerCase());
    var res = await http.get(
        Uri.parse(
          BASE_URL + '/notifications/' + id,
        ),
        headers: {
          'Content-Type': 'application/json',
        });
    print(res.statusCode);
    if (res.statusCode == 200) {
      return (jsonDecode(res.body)['results'] as List);
    } else {
      throw Exception('Something wents wrong.');
    }
  }

  Future<bool> deleteNotifications(String userId) async {
    var res = await http.delete(
        Uri.parse(
          BASE_URL + '/notifications/$userId',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        });
    // print(res.statusCode);
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
