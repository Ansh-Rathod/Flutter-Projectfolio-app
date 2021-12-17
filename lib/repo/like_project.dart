import 'dart:convert';

import 'package:http/http.dart' as http;
import '../api_key.dart';

class LikeProjectReposirity {
  Future<void> like(dynamic info) async {
    var res = await http.put(
      Uri.parse(BASE_URL + '/project/like'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(info),
    );
    print(jsonDecode(res.body));
  }

  Future<void> unlike(dynamic info) async {
    var res = await http.put(
      Uri.parse(BASE_URL + '/project/unlike'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(info),
    );
    print(jsonDecode(res.body));
  }

  Future<void> delete(String id, String tableId) async {
    var res = await http
        .delete(Uri.parse(BASE_URL + '/project/$id?table_id=$tableId'));
    print(jsonDecode(res.body));
  }
}
