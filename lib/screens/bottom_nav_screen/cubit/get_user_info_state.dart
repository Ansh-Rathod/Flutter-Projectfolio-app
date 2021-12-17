part of 'get_user_info_cubit.dart';

enum Status { loading, loaded, error, initial }

class GetUserInfoState {
  final UserModel user;
  final Status status;
  final bool isNote;
  GetUserInfoState({
    required this.user,
    required this.status,
    required this.isNote,
  });
  factory GetUserInfoState.initial() {
    return GetUserInfoState(
      user: UserModel(),
      isNote: false,
      status: Status.initial,
    );
  }

  GetUserInfoState copyWith({
    UserModel? user,
    Status? status,
    bool? isNote,
  }) {
    return GetUserInfoState(
      user: user ?? this.user,
      status: status ?? this.status,
      isNote: isNote ?? this.isNote,
    );
  }
}
