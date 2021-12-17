part of 'notifications_bloc.dart';

abstract class NotificationsState {
  const NotificationsState();
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final old;
  const NotificationsLoaded({
    required this.old,
  });
}

class NotificationsError extends NotificationsState {}
