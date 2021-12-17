part of 'add_comments_cubit.dart';

enum LoadingComments {
  initial,

  loading,
  loaded,
  error,
}

class AddCommentsState {
  final List<CommentModel> comments;
  final LoadingComments status;
  AddCommentsState({
    required this.comments,
    required this.status,
  });
  factory AddCommentsState.initial() => AddCommentsState(
        comments: [],
        status: LoadingComments.initial,
      );
  AddCommentsState copyWith({
    List<CommentModel>? comments,
    LoadingComments? status,
  }) {
    return AddCommentsState(
      comments: comments ?? this.comments,
      status: status ?? this.status,
    );
  }
}
