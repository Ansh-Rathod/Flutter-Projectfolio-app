import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import '../models/project_model/project_model.dart';
import '../models/user_model.dart';

import '../api_key.dart';

class UserRepository {
  Future<dynamic> getUserData(String code) async {
    var res = await http.post(
        Uri.parse('https://github.com/login/oauth/access_token'),
        headers: {
          'Accept': 'application/json',
        },
        body: {
          "client_id": "6cf411c3a4b0219a7fa5",
          "client_secret": "99d1081b1467daaf17e072b843d921c77f3c409e",
          "code": code
        });
    // print(code);
    var json = jsonDecode(res.body);
    var accessToken = json['access_token'];
    var res2 = await http.get(Uri.parse('https://api.github.com/user'),
        headers: {'Authorization': 'bearer $accessToken'});
    var json2 = jsonDecode(res2.body);
    // print(json2);
    return json2;
  }

  Future<bool> isfollowing(String userid, String followingid) async {
    var url = Uri.parse(BASE_URL +
        "/user/events/isfollow?userId=$userid&following=$followingid");
    var response = await http.get(url);
    print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['isFollow'];
    } else {
      return false;
    }
  }

  Future<bool> isExisit(String userId) {
    var url = Uri.parse(BASE_URL + "/user/isExist/$userId");
    return http.get(url).then((response) {
      print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['isExist'];
      } else {
        return false;
      }
    });
  }

  Future<List<UserModel>> getSearchedUsers(String query) async {
    var res = await http.get(
      Uri.parse(
        BASE_URL + '/search?q=' + query,
      ),
    );
    if (res.statusCode == 200) {
      return (jsonDecode(res.body)['results'] as List)
          .map<UserModel>((user) => UserModel.fromJson(user))
          .toList();
    } else {
      throw Exception('Something wents wrong.');
    }
  }

  Future<List<ProjectModel>> getprojectList(String query) async {
    var res = await http.get(
      Uri.parse(
        BASE_URL + '/search/projects?q=' + query,
      ),
    );
    print(jsonDecode(res.body));
    if (res.statusCode == 200) {
      return (jsonDecode(res.body)['results'] as List)
          .map<ProjectModel>((user) => ProjectModel.fromJson(user))
          .toList();
    } else {
      throw Exception('Something wents wrong.');
    }
  }

  Future<int> createUser(dynamic user) async {
    // print(user);
    var res = await http.post(Uri.parse(BASE_URL + '/user/new'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "id": user['id'].toString(),
          "table_id": getRandomString(16).toLowerCase(),
          "username": user['login'],
          "avatar_url": user['avatar_url'],
          "html_url": user['html_url'],
          "name": user['name'],
          "company": user['company'],
          "bio": user['bio'],
          "blog": user['blog'],
          "location": user['location'],
          "email": user['email'],
          "twitter_username": user['twitter_username'],
        }));
    print(jsonDecode(res.body));
    return res.statusCode;
  }

  Future<UserModel> getUserById(String id) async {
    var res = await http.get(Uri.parse(BASE_URL + '/user/$id'));
    var body = jsonDecode(res.body);
    print(res.statusCode);
    if (res.statusCode == 200) {
      return UserModel.fromJson(body['results'][0]);
    } else {
      throw Exception('Failed to load User');
    }
  }

  Future<bool> follow(
      String userId, String tableId, String followerId, String ftid) async {
    var info = jsonEncode({
      "follower_id": followerId,
      "table_id": tableId,
      "follower_table_id": ftid,
      "time_at": DateTime.now().toString(),
      "user_id": userId,
    });
    var url = Uri.parse(
      BASE_URL + "/user/follow",
    );
    var res = await http.put(url,
        headers: {"Content-Type": "application/json"}, body: info);
    print(jsonDecode(res.body));

    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> unfollow(
      String userId, String tableId, String followerId, String ftid) async {
    var info = jsonEncode({
      "table_id": tableId,
      "follower_id": followerId,
      "follower_table_id": ftid,
      "user_id": userId,
    });
    var url = Uri.parse(
      BASE_URL + "/user/unfollow",
    );
    var res = await http.put(url,
        headers: {"Content-Type": "application/json"}, body: info);
    print(jsonDecode(res.body));

    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<ProjectModel>> getProjectsByUserId(String id) async {
    var res = await http.get(Uri.parse(BASE_URL + '/project/$id'));
    var body = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return (body['results'] as List)
          .map((e) => ProjectModel.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load User');
    }
  }

  Future<int> updateUser({
    required String name,
    required String id,
    required String bio,
    required String blog,
    required String company,
    required String location,
    required String twitterUname,
  }) async {
    var info = {
      "id": id,
      "name": name,
      "bio": bio,
      "blog": blog,
      "twitter_username": twitterUname,
      "company": company,
      "location": location,
    };

    // logger.d(info);

    var res = await http.post(
      Uri.parse(BASE_URL + "/user/update"),
      headers: {
        'content-type': 'application/json',
      },
      body: jsonEncode(info),
    );
    print(jsonDecode(res.body));
    return res.statusCode;
  }

  Future<List<UserModel>> getFollowers(String uid) async {
    var res = await http.get(
      Uri.parse(
        BASE_URL + '/user/followers/' + uid,
      ),
    );
    // print(res.statusCode);

    if (res.statusCode == 200) {
      return (jsonDecode(res.body)['results'] as List)
          .map<UserModel>((user) => UserModel.fromJson(user))
          .toList();
    } else {
      throw Exception('Something wents wrong.');
    }
  }

  Future<List<UserModel>> getFollowing(String uid) async {
    var res = await http.get(
      Uri.parse(
        BASE_URL + '/user/following/' + uid,
      ),
    );
    // print(res.statusCode);
    if (res.statusCode == 200) {
      return (jsonDecode(res.body)['results'] as List)
          .map<UserModel>((user) => UserModel.fromJson(user))
          .toList();
    } else {
      throw Exception('Something wents wrong.');
    }
  }
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
