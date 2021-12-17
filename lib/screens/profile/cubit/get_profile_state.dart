part of 'get_profile_cubit.dart';

enum ProfileStatus { loading, loaded, error, initial }

class GetProfileState {
  final UserModel user;
  final ProfileStatus status;
  final List<ProjectModel> projects;
  final UserModel currentUser;
  final bool? isFollowing;
  final bool isCurrentUser;
  GetProfileState({
    required this.user,
    required this.status,
    required this.projects,
    required this.currentUser,
    this.isFollowing,
    required this.isCurrentUser,
  });
  factory GetProfileState.initial() {
    return GetProfileState(
      currentUser: UserModel(),
      isCurrentUser: false,
      user: UserModel(),
      isFollowing: false,
      status: ProfileStatus.initial,
      projects: [],
    );
  }

  GetProfileState copyWith({
    UserModel? user,
    ProfileStatus? status,
    List<ProjectModel>? projects,
    UserModel? currentUser,
    bool? isFollowing,
    bool? isCurrentUser,
  }) {
    return GetProfileState(
      user: user ?? this.user,
      status: status ?? this.status,
      projects: projects ?? this.projects,
      currentUser: currentUser ?? this.currentUser,
      isFollowing: isFollowing ?? this.isFollowing,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
    );
  }
}
