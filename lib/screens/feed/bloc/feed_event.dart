part of 'feed_bloc.dart';

abstract class FeedEvent {
  const FeedEvent();
}

class LoadFeed extends FeedEvent {
  final String userId;

  const LoadFeed({required this.userId});
}
