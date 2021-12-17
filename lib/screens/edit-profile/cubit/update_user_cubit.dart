import 'dart:io';

import 'package:bloc/bloc.dart';
import '../../../repo/user.dart';

part 'update_user_state.dart';

class UpdateUserCubit extends Cubit<UpdateUserState> {
  UpdateUserCubit() : super(UpdateUserState.inital());
  final repo = UserRepository();

  void submit(
      {required String name,
      required String bio,
      required String id,
      required String location,
      required String tnme,
      required String company,
      required String blog}) async {
    try {
      emit(state.copyWith(status: UserStatus.loading));
      int code = await repo.updateUser(
        name: name,
        id: id,
        bio: bio,
        twitterUname: tnme,
        location: location,
        company: company,
        blog: blog,
      );
      if (code == 500) {
        emit(
          state.copyWith(
              status: UserStatus.error, error: 'INTERNAL SERVER ERROR'),
        );
      } else if (code == 202) {
        emit(state.copyWith(status: UserStatus.success));
      }
    } catch (e) {
      emit(
        state.copyWith(
            status: UserStatus.error, error: 'INTERNAL SERVER ERROR'),
      );
    }
  }
}
