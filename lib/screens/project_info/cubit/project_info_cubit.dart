import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../models/project_model/project_model.dart';
import '../../../repo/like_project.dart';

part 'project_info_state.dart';

class ProjectInfoCubit extends Cubit<ProjectInfoState> {
  ProjectInfoCubit() : super(ProjectInfoState.initial());
  final repo = LikeProjectReposirity();
  void init(List<dynamic> likes, String currentUserId) {
    emit(
      state.copyWith(
        likeCount: likes.length,
        likes: likes,
        isLiked: likes.contains(currentUserId),
      ),
    );
  }

  void like(ProjectModel data, String likerId) async {
    if (state.isLiked) {
      emit(state.copyWith(
          likeCount: state.likeCount - 1,
          likes: state.likes.where((element) => element != likerId).toList(),
          isLiked: false));
      data.remove(likerId);
      await repo.unlike({
        'project_id': data.projectId,
        'table_id': data.tableId,
        'liker_id': likerId,
        'user_id': data.userId,
      });
    } else {
      emit(
        state.copyWith(
          likeCount: state.likeCount + 1,
          likes: state.likes.toList()..add(likerId),
          isLiked: true,
        ),
      );
      data.like(likerId);
      await repo.like({
        'project_id': data.projectId,
        'table_id': data.tableId,
        'liker_id': likerId,
        'time_at': DateTime.now().toString(),
        'user_id': data.userId,
      });
    }
  }

  void deleteProject(String id, String tableId) async {
    emit(state.copyWith(isDeleted: true));
    await repo.delete(id, tableId);
  }
}
