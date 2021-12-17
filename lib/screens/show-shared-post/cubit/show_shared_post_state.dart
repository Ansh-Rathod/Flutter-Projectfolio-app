part of 'show_shared_post_cubit.dart';

// ignore: constant_identifier_names
enum LoadingStatus { loading, inital, loaded, failed, not_found }

class ShowSharedPostState {
  final ProjectModel project;
  final LoadingStatus status;
  ShowSharedPostState({
    required this.project,
    required this.status,
  });
  factory ShowSharedPostState.initial() => ShowSharedPostState(
        project: ProjectModel(),
        status: LoadingStatus.inital,
      );

  ShowSharedPostState copyWith({
    ProjectModel? project,
    LoadingStatus? status,
  }) {
    return ShowSharedPostState(
      project: project ?? this.project,
      status: status ?? this.status,
    );
  }
}
