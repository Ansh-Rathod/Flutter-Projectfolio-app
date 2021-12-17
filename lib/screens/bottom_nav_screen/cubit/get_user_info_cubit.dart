import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:projectfolio/repo/get_notifications.dart';
import '../../../models/user_model.dart';
import '../../../repo/user.dart';

part 'get_user_info_state.dart';

class GetUserInfoCubit extends Cubit<GetUserInfoState> {
  GetUserInfoCubit() : super(GetUserInfoState.initial());
  final repo = UserRepository();
  final noti = GetNotifications();
  void getData(
    String id,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final user = await repo.getUserById(id);
      final notifications = await noti.getNotifications(user.tableId!);
      emit(state.copyWith(
          status: Status.loaded,
          user: user,
          isNote: notifications.isNotEmpty ? true : false));
    } catch (e) {
      emit(state.copyWith(
        status: Status.error,
      ));
    }
  }

  void changeIcon() => emit(state.copyWith(isNote: false));
}
