import 'package:bloc/bloc.dart';
import '../../../models/project_model/project_model.dart';
import '../../../repo/get_projects_by_tag.dart';
import '../../../models/user_model.dart';
part 'get_search_results_state.dart';

class GetProjectsByTagCubit extends Cubit<GetProjectsByTagState> {
  final repo = GetProjectsByTagRepo();
  GetProjectsByTagCubit() : super(GetProjectsByTagState.initial());

  void getProjectsByTag(String searchText) async {
    emit(state.copyWith(status: GetProjectsByTagStatus.loading));
    try {
      final users = await repo.getProjectByTag(searchText);

      emit(state.copyWith(
          status: GetProjectsByTagStatus.success, projects: users));
    } catch (e) {
      emit(state.copyWith(status: GetProjectsByTagStatus.error));
    }
  }
}
