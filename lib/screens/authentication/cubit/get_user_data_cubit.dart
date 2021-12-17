import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repo/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'get_user_data_state.dart';

class GetUserDataCubit extends Cubit<GetUserDataState> {
  GetUserDataCubit() : super(GetUserDataState.initial());

  final repo = UserRepository();
  void init({required String code}) async {
    emit(state.copyWith(status: GetUserStatus.loading));
    try {
      var user = await repo.getUserData(code);
      var isExisit = await repo.isExisit(user['id'].toString());
      if (!isExisit) {
        var crateUser = await repo.createUser(user);
        if (crateUser == 200) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('uid', user['id'].toString());
          emit(state.copyWith(status: GetUserStatus.success, user: user));
        } else {
          emit(state.copyWith(status: GetUserStatus.error));
        }
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('uid', user['id'].toString());
      emit(state.copyWith(status: GetUserStatus.success, user: user));
    } catch (e) {
      emit(state.copyWith(status: GetUserStatus.error));
    }
  }
}
