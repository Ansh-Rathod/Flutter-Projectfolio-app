import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../models/project_model/project_model.dart';
import '../../../models/user_model.dart';
import '../../../repo/user.dart';

part 'get_profile_state.dart';

class GetProfileCubit extends Cubit<GetProfileState> {
  GetProfileCubit() : super(GetProfileState.initial());
  final repo = UserRepository();
  void getData(String id, String userId, UserModel currentUser) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final user = await repo.getUserById(id);
      final projects = await repo.getProjectsByUserId(id);
      if (currentUser.id != id) {
        var isFollow = await repo.isfollowing(currentUser.tableId!, id);
        print(isFollow);
        emit(state.copyWith(
          status: ProfileStatus.loaded,
          user: user,
          currentUser: currentUser,
          projects: projects,
          isFollowing: isFollow,
          isCurrentUser: false,
        ));
      } else {
        emit(state.copyWith(
          status: ProfileStatus.loaded,
          user: user,
          currentUser: currentUser,
          projects: projects,
          isCurrentUser: true,
          isFollowing: null,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
      ));
    }
  }

  void follow() async {
    state.user.follow();
    emit(
      state.copyWith(
        isFollowing: true,
        user: state.user,
      ),
    );

    var followed = await repo.follow(state.user.id!, state.user.tableId!,
        state.currentUser.id!, state.currentUser.tableId!);
    print(followed);
  }

  void unfollow() async {
    state.user.unfollow();

    emit(
      state.copyWith(
        isFollowing: false,
        user: state.user,
      ),
    );

    var unfollowed = await repo.unfollow(state.user.id!, state.user.tableId!,
        state.currentUser.id!, state.currentUser.tableId!);
  }
}
