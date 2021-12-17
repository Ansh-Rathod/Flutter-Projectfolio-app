part of 'feed_bloc.dart';

abstract class FeedState {
  const FeedState();
}

class FeedInitial extends FeedState {}

class FeedLoading extends FeedState {}

class FeedLoaded extends FeedState {
  final List<ProjectModel> posts;
  final List<UserModel> users;
  const FeedLoaded({
    required this.users,
    required this.posts,
  });
}

class FeedError extends FeedState {}
