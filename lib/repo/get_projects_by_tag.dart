import 'dart:convert';

import '../api_key.dart';
import '../models/project_model/project_model.dart';
import 'package:http/http.dart' as http;

class GetProjectsByTagRepo {
  Future<List<ProjectModel>> getProjectByTag(String tag) async {
    var res = await http.get(Uri.parse(BASE_URL + '/feed/tags/$tag'));

    if (res.statusCode == 200) {
      return (jsonDecode(res.body)['results'] as List)
          .map((i) => ProjectModel.fromJson(i))
          .toList();
    } else {
      throw Exception('Failed to load post');
    }
  }
}
