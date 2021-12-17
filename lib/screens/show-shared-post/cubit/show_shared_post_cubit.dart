import 'dart:convert';

import 'package:bloc/bloc.dart';

import 'package:http/http.dart' as http;
import '../../../models/project_model/project_model.dart';

import '../../../api_key.dart';
part 'show_shared_post_state.dart';

class ShowSharedPostCubit extends Cubit<ShowSharedPostState> {
  ShowSharedPostCubit() : super(ShowSharedPostState.initial());
  void init(String postId) async {
    print(postId);
    try {
      emit(state.copyWith(status: LoadingStatus.loading));
      var res =
          await http.get(Uri.parse(BASE_URL + '/project/one_post/' + postId));
      print(jsonDecode(res.body));
      if (res.statusCode == 200) {
        emit(state.copyWith(
          project: ProjectModel.fromJson(
            jsonDecode(res.body)['results'][0],
          ),
          status: LoadingStatus.loaded,
        ));
      } else if (jsonDecode(res.body)['results'].isEmpty) {
        emit(state.copyWith(status: LoadingStatus.not_found));
      }
    } catch (e) {
      emit(state.copyWith(status: LoadingStatus.failed));
    }
  }
}
