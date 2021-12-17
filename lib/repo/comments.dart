import 'dart:convert';

import '../api_key.dart';
import '../models/comment_model.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class CommentRepository {
  Future<void> addComment({
    required String tableId,
    required String postId,
    required String commenterUserId,
    required String comment,
    required String uid,
  }) async {
    var info = {
      "user_id":uid,
      "table_id": tableId,
      "project_id": postId,
      "commenter_user_id": commenterUserId,
      "comment": comment,
      "comment_created_at": DateTime.now().toString(),
      "comment_id": const Uuid().v1(),
    };
    var res = await http.post(
      Uri.parse(BASE_URL + '/project/create-comment'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(info),
    );
    var body = jsonDecode(res.body);
    print(body);
  }

  Future<List<CommentModel>> getComments(
      String tableId, String projectId) async {
    var res = await http.post(Uri.parse(BASE_URL + '/project/comments/all'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "table_id": tableId,
          "project_id": projectId,
        }));
    var body = jsonDecode(res.body);
    return (body['results'] as List)
        .map((comment) => CommentModel.fromJson(comment))
        .toList();
  }
}
