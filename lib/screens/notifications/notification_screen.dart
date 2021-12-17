import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import '../../models/notifications.dart';
import '../profile/profile_screen.dart';
import '../show-shared-post/show_shared_post.dart';
import '../../widgets/loading/search_page_loading.dart';
import '../../widgets/readmore.dart';
import '../../animation.dart';
import '../../api_key.dart';
import '../../models/user_model.dart';
import 'bloc/notifications_bloc.dart';
import '../../widgets/user_profile.dart';

class NotificationPage extends StatelessWidget {
  final UserModel currentUser;
  const NotificationPage({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (context) => NotificationsBloc()
          ..add(LoadNotifications(userId: currentUser.tableId!)),
        child:
            Scaffold(body: BlocBuilder<NotificationsBloc, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoading) {
              return CustomScrollView(
                shrinkWrap: true,
                slivers: [
                  CupertinoSliverNavigationBar(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade700,
                        width: .5,
                      ),
                    ),
                    stretch: true,
                    backgroundColor: Colors.transparent,
                    largeTitle: const Text(
                      "Activity",
                      style: TextStyle(
                        fontFamily: 'EuclidTriangle',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: LoadingList()),
                ],
              );
            }
            if (state is NotificationsError) {
              return const Center(
                child: Text(
                  'Failed to fetch notifications',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              );
            }
            if (state is NotificationsLoaded) {
              BlocProvider.of<NotificationsBloc>(context).add(
                DeleteAllNotifications(userId: currentUser.tableId!),
              );
              var box = Hive.box('notifications');
              List values = box.values.toList();
              values.sort((a, b) => a['time_at'].compareTo(b['time_at']));

              return CustomScrollView(
                slivers: [
                  CupertinoSliverNavigationBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    border: Border(
                      bottom:
                          BorderSide(color: Colors.grey.shade700, width: 0.5),
                    ),
                    largeTitle: const Text(
                      'Activity',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'EuclidTriangle',
                      ),
                    ),
                  ),
                  if (state.old.isEmpty)
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * .7,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                CupertinoIcons.bell,
                                size: 100,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'No notifications',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .copyWith(
                                      color: Colors.grey.shade300,
                                      fontSize: 24,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    SliverToBoxAdapter(
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          reverse: true,
                          itemCount: values.length,
                          itemBuilder: (context, i) {
                            var json = values[i];
                            final notification =
                                NotificationModel.fromJson(json);
                            return Dismissible(
                              direction: DismissDirection.endToStart,
                              key: Key(
                                  notification.notificationId + i.toString()),
                              background: Container(
                                alignment: Alignment.centerRight,
                                color: Colors.redAccent,
                                child: const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Icon(
                                    CupertinoIcons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              onDismissed: (j) async {
                                BlocProvider.of<NotificationsBloc>(context).add(
                                  DeleteNotifications(
                                    userId: currentUser.id!,
                                    notificationId: notification.notificationId,
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      if (notification.type == 'COMMENT' ||
                                          notification.type == 'LIKE') {
                                        Navigator.push(
                                          context,
                                          createRoute(
                                            ShowSharedPost(
                                              userId: notification.followerId,
                                              postId: notification.postId,
                                              currentUser: currentUser,
                                            ),
                                          ),
                                        );
                                      } else {
                                        Navigator.push(
                                            context,
                                            createRoute(
                                              ProfileScreen(
                                                currentUser: currentUser,
                                                id: notification.followerId,
                                                tableId: '',
                                              ),
                                            ));
                                      }
                                    },
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 10,
                                    ),
                                    leading: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            createRoute(
                                              ProfileScreen(
                                                currentUser: currentUser,
                                                id: notification.followerId,
                                                tableId: '',
                                              ),
                                            ));
                                      },
                                      child: UserProfile(
                                        size: 50,
                                        url: notification.avatarUrl,
                                      ),
                                    ),
                                    title: Text(
                                      notification.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1!
                                          .copyWith(
                                            fontSize: 20,
                                          ),
                                    ),
                                    subtitle: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ReadMoreText(
                                          buildText(notification),
                                          trimLines: 2,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                          colorClickableText:
                                              Theme.of(context).primaryColor,
                                          trimMode: TrimMode.line,
                                          trimCollapsedText: 'Show more',
                                          trimExpandedText: 'Show less',
                                          moreStyle: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          StringExtension
                                              .displayTimeAgoFromTimestamp(
                                            notification.timeAt,
                                          ),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    trailing: notification.type == 'COMMENT' ||
                                            notification.type == 'LIKE'
                                        ? GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              child: notification.type ==
                                                      'COMMENT'
                                                  ? const Icon(
                                                      CupertinoIcons
                                                          .bubble_left_fill,
                                                      color: Colors.white,
                                                    )
                                                  : const Icon(
                                                      CupertinoIcons.heart_fill,
                                                      color: Colors.white,
                                                    ),
                                            ),
                                          )
                                        : null,
                                  ),
                                  Divider(
                                    color: Colors.grey.shade800,
                                    thickness: 0.5,
                                    height: 0,
                                  ),
                                ],
                              ),
                            );
                          }),
                    )
                ],
              );
            }
            return Container();
          },
        )),
      ),
    );
  }

  String buildText(NotificationModel notification) {
    if (notification.type == 'FOLLOW') {
      return 'Started following you';
    } else if (notification.type == 'COMMENT') {
      return 'commented on your post "' + notification.comment + '"';
    } else if (notification.type == 'LIKE') {
      return 'liked your post';
    } else {
      return 'shared your post';
    }
  }
}
