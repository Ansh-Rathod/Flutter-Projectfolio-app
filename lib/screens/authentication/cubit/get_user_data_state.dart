part of 'get_user_data_cubit.dart';

enum GetUserStatus { loading, success, error }

class GetUserDataState {
  final dynamic user;
  final GetUserStatus status;
  GetUserDataState({
    required this.user,
    required this.status,
  });
  factory GetUserDataState.initial() => GetUserDataState(
        user: {},
        status: GetUserStatus.loading,
      );

  GetUserDataState copyWith({
    dynamic? user,
    GetUserStatus? status,
  }) {
    return GetUserDataState(
      user: user ?? this.user,
      status: status ?? this.status,
    );
  }
}
