part of 'add_projects_cubit.dart';

enum UploadStatus {
  intial,
  uploading,
  success,
  failed,
}

class AddProjectsState {
  final List<File> files;
  final UploadStatus status;
  final List tags;
  final String type;
  final List<dynamic> data;
  final String query;
  AddProjectsState({
    required this.files,
    required this.status,
    required this.tags,
    required this.type,
    required this.data,
    required this.query,
  });
  factory AddProjectsState.initial() => AddProjectsState(
        files: [],
        query: '',
        type: 'Project',
        status: UploadStatus.intial,
        tags: [],
        data: [],
      );

  AddProjectsState copyWith({
    List<File>? files,
    UploadStatus? status,
    List? tags,
    String? type,
    List<dynamic>? data,
    String? query,
  }) {
    return AddProjectsState(
      files: files ?? this.files,
      status: status ?? this.status,
      tags: tags ?? this.tags,
      type: type ?? this.type,
      data: data ?? this.data,
      query: query ?? this.query,
    );
  }
}
