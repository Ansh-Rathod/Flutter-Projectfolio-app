part of 'notifications_bloc.dart';

abstract class NotificationsEvent {
  const NotificationsEvent();
}

class LoadNotifications extends NotificationsEvent {
  final String userId;

  const LoadNotifications({required this.userId});
}

class DeleteNotifications extends NotificationsEvent {
  final String userId;
  final String notificationId;
  const DeleteNotifications({
    required this.userId,
    required this.notificationId,
  });
}

class DeleteAllNotifications extends NotificationsEvent {
  final String userId;
  const DeleteAllNotifications({required this.userId});
}
