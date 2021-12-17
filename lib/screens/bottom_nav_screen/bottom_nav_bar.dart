import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uni_links/uni_links.dart';

import 'package:projectfolio/screens/add_projects/add_project.dart';

import '../../models/user_model.dart';
import '../feed/feed.dart';
import '../notifications/notification_screen.dart';
import '../profile/profile_screen.dart';
import '../search/search_page.dart';
import '../show-shared-post/show_shared_post.dart';
import 'cubit/get_user_info_cubit.dart';

class BottomNavBar extends StatefulWidget {
  final String uid;
  const BottomNavBar({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    buildCurrentPage(
      int i,
      UserModel user,
    ) {
      switch (i) {
        case 0:
          return FeedScreen(
            currentUser: user,
          );
        case 1:
          return SearchPage(
            currentUser: user,
          );

        case 2:
          return NotificationPage(
            currentUser: user,
          );

        case 3:
          return ProfileScreen(
            currentUser: user,
            tableId: user.tableId!,
            id: user.id!,
          );
        default:
          return Container();
      }
    }

    return BlocProvider(
      create: (context) => GetUserInfoCubit()..getData(widget.uid),
      child: BlocBuilder<GetUserInfoCubit, GetUserInfoState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        height: 150,
                        width: 150,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "ProjectFolio.".toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          shadows: kElevationToShadow[8],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          if (state.status == Status.error) {
            return Scaffold(
              body: Center(
                child: Text(
                  "ERRORRRRR",
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
            );
          }
          if (state.status == Status.loaded) {
            return Scaffold(
              body: buildCurrentPage(currentIndex, state.user),
              bottomNavigationBar: CupertinoTabBar(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade800,
                    width: .4,
                  ),
                ),
                backgroundColor: Colors.transparent,
                onTap: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                  if (currentIndex == 2) {
                    BlocProvider.of<GetUserInfoCubit>(context).changeIcon();
                  }
                },
                inactiveColor: Colors.grey,
                activeColor: Theme.of(context).primaryColor,
                currentIndex: currentIndex,
                iconSize: 26.0,
                items: [
                  const BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.home),
                    label: 'Home',
                    activeIcon: Icon(CupertinoIcons.house_fill),
                  ),
                  const BottomNavigationBarItem(
                    label: 'Search',
                    icon: Icon(CupertinoIcons.search),
                  ),
                  BottomNavigationBarItem(
                    label: 'Notifications',
                    icon: !state.isNote
                        ? const Icon(CupertinoIcons.bell)
                        : const Icon(
                            Icons.notifications_active_outlined,
                            color: Colors.orange,
                          ),
                    activeIcon: const Icon(CupertinoIcons.bell_solid),
                  ),
                  const BottomNavigationBarItem(
                    label: 'Profile',
                    icon: Icon(CupertinoIcons.person),
                    activeIcon: Icon(CupertinoIcons.person_fill),
                  ),
                ],
              ),
            );
          }
          return Scaffold();
        },
      ),
    );
  }
}
