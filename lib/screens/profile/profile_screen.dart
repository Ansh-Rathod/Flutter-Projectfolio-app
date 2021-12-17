import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/user_model.dart';
import '../add_projects/add_project.dart';
import '../edit-profile/update_user.dart';
import 'cubit/get_profile_cubit.dart';
import '../users-followers-page/user_followers.dart';
import '../../widgets/loading/loading_profile.dart';
import '../../widgets/project/project.dart';
import '../../widgets/user_profile.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../animation.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel currentUser;
  final String id;
  final String tableId;
  const ProfileScreen({
    Key? key,
    required this.currentUser,
    required this.id,
    required this.tableId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetProfileCubit()..getData(id, tableId, currentUser),
      child: BlocBuilder<GetProfileCubit, GetProfileState>(
        builder: (context, state) {
          if (state.status == ProfileStatus.loading) {
            return const Scaffold(body: LoadingProfile());
          }
          if (state.status == ProfileStatus.error) {
            return const Scaffold(
              body: Center(
                child: Text("Error"),
              ),
            );
          }
          if (state.status == ProfileStatus.loaded) {
            return Scaffold(
              appBar: CupertinoNavigationBar(
                border: Border(
                  bottom: BorderSide(
                    width: .2,
                    color: Colors.grey.shade500,
                  ),
                ),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                middle: Text(
                  state.user.name ?? state.user.username!,
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                trailing: currentUser.id == id
                    ? CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Icon(
                          CupertinoIcons.add_circled,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              createRoute(AddProfjects(
                                currentUser: currentUser,
                              )));
                        },
                      )
                    : Container(),
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  BlocProvider.of<GetProfileCubit>(context)
                      .getData(id, tableId, currentUser);
                },
                child: ListView(
                  children: [
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          UserProfile(
                            url: state.user.avatarUrl!,
                            size: 70,
                          ),
                          const SizedBox(width: 20),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.user.name == null
                                      ? state.user.username!
                                      : state.user.name!,
                                  style: Theme.of(context).textTheme.headline1,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '@' + state.user.username!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color: Colors.white.withOpacity(.6),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Wrap(children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              CupertinoIcons.location,
                              size: 18,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              state.user.location ?? 'Unknown',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: Colors.white.withOpacity(.8),
                                    fontSize: 14,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.work_outlined,
                              size: 18,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              state.user.company ?? 'Unknown',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: Colors.white.withOpacity(.8),
                                    fontSize: 15,
                                  ),
                            ),
                          ],
                        ),
                      ]),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                createRoute(
                                  ShowUserFollowers(
                                    currentUser: currentUser,
                                    index: 0,
                                    uid: state.user.tableId!,
                                  ),
                                ),
                              );
                            },
                            child: Tile(
                              count: state.user.followersCount.toString(),
                              name: "Followers",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              width: 1,
                              height: 15,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  createRoute(ShowUserFollowers(
                                    currentUser: currentUser,
                                    index: 1,
                                    uid: state.user.tableId!,
                                  )));
                            },
                            child: Tile(
                              count: state.user.followingCount.toString(),
                              name: "Following",
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(children: [
                        button(state.isCurrentUser, state.isFollowing, context,
                            currentUser),
                        const SizedBox(width: 5),
                        if (state.user.twitterUsername != null &&
                            state.user.twitterUsername != '')
                          OutlinedButton(
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: Icon(FontAwesomeIcons.twitter),
                              ),
                              onPressed: () {
                                launch('http://twitter.com/' +
                                    state.user.twitterUsername!);
                              }),
                        const SizedBox(width: 5),
                        OutlinedButton(
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Icon(FontAwesomeIcons.github),
                            ),
                            onPressed: () {
                              launch(state.user.htmlUrl!);
                            }),
                      ]),
                    ),
                    const SizedBox(height: 20),
                    if (state.user.bio != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          "About",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(
                                  color: Colors.white.withOpacity(.8),
                                  fontSize: 20),
                        ),
                      ),
                    const SizedBox(height: 5),
                    if (state.user.bio != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          state.user.bio!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.white.withOpacity(.6)),
                        ),
                      ),
                    const SizedBox(height: 20),
                    if (state.projects.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          "Projects",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(
                                  color: Colors.white.withOpacity(.8),
                                  fontSize: 20),
                        ),
                      ),
                    const SizedBox(height: 20),
                    if (state.projects.isEmpty)
                      SizedBox(
                        height: 200,
                        child: Center(
                          child: Text("No Projects yet",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(
                                      color: Colors.white.withOpacity(.6))),
                        ),
                      ),
                    ...state.projects
                        .map((e) => ProjectWidget(
                              project: e,
                              currentUser: currentUser,
                            ))
                        .toList(),
                  ],
                ),
              ),
            );
          }
          return Scaffold();
        },
      ),
    );
  }

  Widget button(bool isCurrentUser, bool? isFollowing, BuildContext context,
      UserModel currentUser) {
    if (isCurrentUser) {
      return Expanded(
        child: OutlinedButton(
          onPressed: () {
            Navigator.push(
                context,
                createRoute(UpdateUser(
                  currentUser: currentUser,
                )));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              "EDIT PROFILE",
              style: Theme.of(context).textTheme.button!.copyWith(
                  color: Theme.of(context).primaryColor, fontSize: 14),
            ),
          ),
        ),
      );
    } else if (isFollowing != null && isFollowing == true) {
      return Expanded(
        child: OutlinedButton(
          onPressed: () {
            BlocProvider.of<GetProfileCubit>(context).unfollow();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              "UNFOLLOW",
              style: Theme.of(context).textTheme.button!.copyWith(
                  color: Theme.of(context).primaryColor, fontSize: 14),
            ),
          ),
        ),
      );
    } else if (isFollowing != null && isFollowing == false) {
      return Expanded(
        child: ElevatedButton(
          onPressed: () {
            BlocProvider.of<GetProfileCubit>(context).follow();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              "FOLLOW",
              style: Theme.of(context)
                  .textTheme
                  .button!
                  .copyWith(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
      );
    } else {
      return Expanded(
        child: RaisedButton(
          textColor: Colors.white,
          color: Theme.of(context).primaryColor,
          disabledColor: Colors.grey.shade800,
          onPressed: null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              "Loading..".toUpperCase(),
              style: Theme.of(context).textTheme.headline1!.copyWith(
                    fontSize: 15,
                  ),
            ),
          ),
        ),
      );
    }
  }
}

class Tile extends StatelessWidget {
  final String count;
  final String name;
  const Tile({
    Key? key,
    required this.count,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          count,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Colors.white.withOpacity(.6),
          ),
        ),
      ],
    );
  }
}
