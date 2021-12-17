part of 'get_search_results_cubit.dart';

enum GetProjectsByTagStatus {
  loading,
  success,
  initial,
  error,
}

class GetProjectsByTagState {
  final List<ProjectModel> projects;
  final GetProjectsByTagStatus status;
  bool get isEmpty => projects.isEmpty;
  GetProjectsByTagState({
    required this.projects,
    required this.status,
  });
  factory GetProjectsByTagState.initial() => GetProjectsByTagState(
        projects: [],
        status: GetProjectsByTagStatus.initial,
      );

  GetProjectsByTagState copyWith({
    List<ProjectModel>? projects,
    GetProjectsByTagStatus? status,
  }) {
    return GetProjectsByTagState(
      projects: projects ?? this.projects,
      status: status ?? this.status,
    );
  }
}
