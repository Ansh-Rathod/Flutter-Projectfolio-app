import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../models/comment_model.dart';
import '../../../models/user_model.dart';
import '../../../repo/comments.dart';

part 'add_comments_state.dart';

class AddCommentsCubit extends Cubit<AddCommentsState> {
  AddCommentsCubit() : super(AddCommentsState.initial());
  final repo = CommentRepository();
  void init({required String userid, required String postId}) async {
    emit(state.copyWith(status: LoadingComments.loading));
    final body = await repo.getComments(userid, postId);
    emit(state.copyWith(comments: body, status: LoadingComments.loaded));
  }

  void addComment({
    required UserModel currentUser,
    required String userId,
    required String postId,
    required String comment,
  }) async {
    state.comments.add(CommentModel(
      projectId: postId,
      comment: comment,
      name: currentUser.name ?? 'Name not added',
      avatarUrl: currentUser.avatarUrl!,
      commentCreatedAt: DateTime.now().toString(),
      commenterUserId: currentUser.id!,
      commentId: '',
      username: currentUser.username!,
    ));
    emit(state.copyWith(status: LoadingComments.loaded));
    await repo.addComment(
      tableId: userId,
      uid: currentUser.id!,
      postId: postId,
      comment: comment,
      commenterUserId: currentUser.id!,
    );
  }
}
