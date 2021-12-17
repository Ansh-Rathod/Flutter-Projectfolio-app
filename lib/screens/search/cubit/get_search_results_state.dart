part of 'get_search_results_cubit.dart';

enum GetSearchResultsStatus {
  loading,
  success,
  initial,
  error,
}

class GetSearchResultsState {
  final List<UserModel> users;
  final List<ProjectModel> projects;
  final GetSearchResultsStatus status;
  final bool isProjects;
  bool get isEmpty => users.isEmpty;
  GetSearchResultsState({
    required this.users,
    required this.projects,
    required this.status,
    required this.isProjects,
  });
  factory GetSearchResultsState.initial() => GetSearchResultsState(
        users: [],
        projects: [],
        isProjects: false,
        status: GetSearchResultsStatus.initial,
      );

  GetSearchResultsState copyWith({
    List<UserModel>? users,
    List<ProjectModel>? projects,
    GetSearchResultsStatus? status,
    bool? isProjects,
  }) {
    return GetSearchResultsState(
      users: users ?? this.users,
      projects: projects ?? this.projects,
      status: status ?? this.status,
      isProjects: isProjects ?? this.isProjects,
    );
  }
}
