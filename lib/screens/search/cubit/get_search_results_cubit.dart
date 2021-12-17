import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../models/project_model/project_model.dart';
import '../../../repo/user.dart';
import '../../../models/user_model.dart';

part 'get_search_results_state.dart';

class GetSearchResultsCubit extends Cubit<GetSearchResultsState> {
  final repo = UserRepository();
  GetSearchResultsCubit() : super(GetSearchResultsState.initial());

  void getSearchResults(
      String searchText, String userId, bool isRepeated) async {
    emit(state.copyWith(status: GetSearchResultsStatus.loading));
    if (!isRepeated) {
      var box = Hive.box('recents');
      box.add({
        "type": "user",
        "searchText": searchText,
      });
    }
    try {
      final users = await repo.getSearchedUsers(searchText);
      users.removeWhere((element) => element.id == userId);

      emit(
          state.copyWith(status: GetSearchResultsStatus.success, users: users));
    } catch (e) {
      emit(state.copyWith(status: GetSearchResultsStatus.error));
    }
  }

  void getProjectSearchResults(String searchText, bool isRepeated) async {
    emit(state.copyWith(
        status: GetSearchResultsStatus.loading, isProjects: true));
    if (!isRepeated) {
      var box = Hive.box('recents');

      box.add({
        "type": "project",
        "searchText": searchText,
      });
    }
    try {
      final projects = await repo.getprojectList(searchText);

      emit(state.copyWith(
          status: GetSearchResultsStatus.success, projects: projects));
    } catch (e) {
      emit(state.copyWith(status: GetSearchResultsStatus.error));
    }
  }
}
