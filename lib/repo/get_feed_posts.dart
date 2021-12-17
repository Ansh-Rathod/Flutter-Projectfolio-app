import 'dart:convert';

import 'package:http/http.dart' as http;
import '../api_key.dart';
import '../models/project_model/project_model.dart';

class GetFeedPosts {
  Future<List<ProjectModel>> getUserPosts(String id) async {
    // print(id.toLowerCase());
    var res = await http.get(
        Uri.parse(
          BASE_URL + '/feed/' + id,
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        });
    // print(res.statusCode);
    if (res.statusCode == 200) {
      print(jsonDecode(res.body));
      return (jsonDecode(res.body)['results'] as List)
          .map<ProjectModel>((post) => ProjectModel.fromJson(post))
          .toList();
    } else {
      throw Exception('Something wents wrong.');
    }
  }
}
