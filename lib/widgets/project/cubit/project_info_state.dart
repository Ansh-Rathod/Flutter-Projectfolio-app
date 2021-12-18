part of 'project_info_cubit.dart';

class ProjectInfoState {
  final List<dynamic> likes;
  final int likeCount;
  final bool isLiked;
  final bool isDeleted;
  ProjectInfoState({
    required this.likes,
    required this.likeCount,
    required this.isLiked,
    required this.isDeleted,
  });

  factory ProjectInfoState.initial() => ProjectInfoState(
        likes: [],
        isDeleted: false,
        isLiked: false,
        likeCount: 0,
      );
  ProjectInfoState copyWith({
    List<dynamic>? likes,
    int? likeCount,
    bool? isLiked,
    bool? isDeleted,
  }) {
    return ProjectInfoState(
      likes: likes ?? this.likes,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
