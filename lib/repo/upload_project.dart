import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../api_key.dart';

class UploadProjectRepository {
  Future<dynamic> uploadImage(File file) async {
    var data = await http.MultipartFile.fromPath('picture', file.path);

    var res = http.MultipartRequest(
        'POST', Uri.parse(BASE_URL + '/project/upload-images'))
      ..files.add(data);
    var response = await res.send();
    final respStr = await response.stream.bytesToString();
    print(jsonDecode(respStr));
    return jsonDecode(respStr)['data'];
  }

  Future<dynamic> uploadProject(dynamic info) async {
    var res = await http.post(Uri.parse(BASE_URL + '/project/new'),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(info));
    print(jsonDecode(res.body));
    return res.statusCode;
  }
}
