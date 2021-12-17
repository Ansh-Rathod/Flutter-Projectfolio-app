import 'package:bloc/bloc.dart';
import '../../../models/project_model/project_model.dart';
import '../../../models/user_model.dart';
import '../../../repo/get_feed_posts.dart';
import '../../../repo/user.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final repo = GetFeedPosts();
  final suggested = UserRepository();
  FeedBloc() : super(FeedInitial()) {
    on<FeedEvent>((event, emit) async {
      if (event is LoadFeed) {
        try {
          emit(FeedLoading());
          final posts = await repo.getUserPosts(event.userId);
          posts.sort((a, b) {
            return b.postedAt!.compareTo(a.postedAt!);
          });

          final suggestedUsers = await suggested.getSearchedUsers('a');

          suggestedUsers.removeWhere((element) => element.id == event.userId);
          emit(FeedLoaded(posts: posts, users: suggestedUsers));
        } catch (e) {
          emit(FeedError());
        }
      }
    });
  }
}
