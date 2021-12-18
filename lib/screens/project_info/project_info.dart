// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projectfolio/screens/profile/profile_screen.dart';
import 'package:projectfolio/widgets/show_snackbar.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:projectfolio/api_key.dart';
import 'package:projectfolio/models/project_model/project_model.dart';
import 'package:projectfolio/models/user_model.dart';
import 'package:projectfolio/screens/add_comments/add_comment.dart';
import 'package:projectfolio/screens/get_projects/search_results.dart';
import 'package:projectfolio/screens/project_info/cubit/project_info_cubit.dart';
import 'package:projectfolio/widgets/image_preview.dart';
import 'package:projectfolio/widgets/user_profile.dart';

import '../../animation.dart';

class ProjectInfo extends StatelessWidget {
  final ProjectModel data;
  final UserModel currentUser;
  const ProjectInfo({
    Key? key,
    required this.data,
    required this.currentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProjectInfoCubit()..init(data.likes!, currentUser.id!),
      child: BlocBuilder<ProjectInfoCubit, ProjectInfoState>(
        builder: (context, state) {
          return Scaffold(
            floatingActionButton: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (data.projectUrl! != '')
                  FloatingActionButton(
                    heroTag: '',
                    mini: true,
                    onPressed: () {
                      launch(data.projectUrl!);
                    },
                    child: const Icon(Icons.link),
                  ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: () {
                    launch(data.githubUrl!);
                  },
                  backgroundColor: Colors.green,
                  child: const Icon(
                    FontAwesomeIcons.github,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        createRoute(
                          ViewPhotos(
                            data: data.images!.data,
                            imageIndex: 0,
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Hero(
                          tag: data.images!.data![0].url!,
                          child: CachedNetworkImage(
                            imageUrl: data.images!.data![0].url!,
                            height:
                                MediaQuery.of(context).size.height * (1 - 0.60),
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: buildIcon(
                              const Icon(
                                CupertinoIcons.back,
                                color: Colors.white,
                                size: 24,
                              ),
                              () => Navigator.pop(context)),
                        ),
                        if (currentUser.id == data.userId)
                          Positioned(
                            top: 10,
                            right: 10,
                            child: buildIcon(
                                const Icon(
                                  CupertinoIcons.ellipsis,
                                  color: Colors.white,
                                  size: 24,
                                ), () {
                              showModalBottomSheet<void>(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor:
                                    const Color.fromARGB(255, 30, 34, 45),
                                context: context,
                                builder: (BuildContext ctx) {
                                  return Container(
                                    color: Colors.black26,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Column(
                                          children: [
                                            ListTile(
                                              onTap: () async {
                                                BlocProvider.of<
                                                            ProjectInfoCubit>(
                                                        context)
                                                    .deleteProject(
                                                        data.projectId!,
                                                        data.tableId!);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                showSnackBarToPage(
                                                    context,
                                                    'Project Deleted, refresh your profile to see changes.',
                                                    Colors.green);
                                              },
                                              minLeadingWidth: 20,
                                              leading: Icon(
                                                CupertinoIcons.delete,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              title: Text(
                                                "Delete Project",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                              ),
                                            ),
                                            Divider(
                                              height: .5,
                                              thickness: .5,
                                              color: Colors.grey.shade800,
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            ListTile(
                                              onTap: () {},
                                              minLeadingWidth: 20,
                                              leading: Icon(
                                                CupertinoIcons.pen,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              title: Text(
                                                "Edit Project",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                              ),
                                            ),
                                            Divider(
                                              height: .5,
                                              thickness: .5,
                                              color: Colors.grey.shade800,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }),
                          ),
                      ],
                    ),
                  ),
                  SizedBox.expand(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: DraggableScrollableSheet(
                        initialChildSize: 0.65,
                        minChildSize: 0.65,
                        maxChildSize: 0.90,
                        builder: (context, con) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: SingleChildScrollView(
                              controller: con,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        DelayedDisplay(
                                          delay:
                                              const Duration(milliseconds: 600),
                                          child: Row(
                                            children: [
                                              buildIcon(
                                                const Icon(
                                                  FontAwesomeIcons.twitter,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                                () {
                                                  launch(
                                                      "https://twitter.com/intent/tweet?url=https://anshrathod.vercel.app/projectfolio?id=${data.projectId}&text=${data.title} by @${data.twitterUsername ?? data.username}");
                                                },
                                              ),
                                              buildIcon(
                                                const Icon(
                                                  FontAwesomeIcons.linkedin,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                                () {
                                                  launch(
                                                      'https://www.linkedin.com/shareArticle?mini=true&url=https://anshrathod.vercel.app/projectfolio?id=${data.projectId}');
                                                },
                                              ),
                                              buildIcon(
                                                const Icon(
                                                  FontAwesomeIcons.share,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                                () {
                                                  Share.share(
                                                      "https://anshrathod.vercel.app/projectfolio?id=${data.projectId}");
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        DelayedDisplay(
                                          delay:
                                              const Duration(milliseconds: 600),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              buildLikeIcon(
                                                const Icon(
                                                  CupertinoIcons.bubble_left,
                                                  color: Colors.white,
                                                ),
                                                () {
                                                  Navigator.push(
                                                    context,
                                                    createRoute(
                                                      CommentScreen(
                                                        userId: data.userId!,
                                                        projectId:
                                                            data.projectId!,
                                                        currentUser:
                                                            currentUser,
                                                        tableId: data.tableId!,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              buildLikeIcon(
                                                Row(
                                                  children: [
                                                    Text(
                                                      "${state.likeCount}",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1!
                                                          .copyWith(
                                                            fontSize: 12,
                                                          ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    !state.isLiked
                                                        ? const Icon(
                                                            CupertinoIcons
                                                                .heart,
                                                            color: Colors.white,
                                                          )
                                                        : const Icon(
                                                            CupertinoIcons
                                                                .heart_solid,
                                                            color: Colors.red,
                                                          ),
                                                  ],
                                                ),
                                                () {
                                                  BlocProvider.of<
                                                              ProjectInfoCubit>(
                                                          context)
                                                      .like(data,
                                                          currentUser.id!);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: DelayedDisplay(
                                      delay: const Duration(milliseconds: 600),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(createRoute(ProfileScreen(
                                              currentUser: currentUser,
                                              id: data.id!,
                                              tableId: data.tableId!,
                                            )));
                                          },
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 5, sigmaY: 10),
                                            child: Container(
                                              color:
                                                  Colors.black.withOpacity(.3),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20.0,
                                                        vertical: 8),
                                                child: Row(
                                                  children: [
                                                    UserProfile(
                                                        url: data.avatarUrl!,
                                                        size: 50),
                                                    const SizedBox(width: 10),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          data.name ??
                                                              data.username!,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText1,
                                                        ),
                                                        Text(
                                                          StringExtension
                                                              .displayTimeAgoFromTimestamp(
                                                            data.postedAt!,
                                                          ),
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyText1!
                                                              .copyWith(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  color: Colors
                                                                      .white60),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        DelayedDisplay(
                                          delay:
                                              const Duration(milliseconds: 700),
                                          child: Text(
                                            data.title!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        DelayedDisplay(
                                          delay:
                                              const Duration(milliseconds: 600),
                                          child: Text(
                                            data.description!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                    color: Colors.white
                                                        .withOpacity(.6)),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        DelayedDisplay(
                                          delay:
                                              const Duration(milliseconds: 600),
                                          child: Text(
                                            "Type ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1!
                                                .copyWith(
                                                  fontSize: 18,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        DelayedDisplay(
                                          delay:
                                              const Duration(milliseconds: 600),
                                          child: Text(
                                            data.type!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                    color: Colors.white
                                                        .withOpacity(.6)),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        if (data.tags!.isNotEmpty)
                                          DelayedDisplay(
                                            delay: const Duration(
                                                milliseconds: 600),
                                            child: Text(
                                              "Category ",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline1!
                                                  .copyWith(
                                                    fontSize: 18,
                                                  ),
                                            ),
                                          ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (data.tags!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: DelayedDisplay(
                                          delay:
                                              const Duration(milliseconds: 600),
                                          child: Tags(
                                            tags: data.tags!,
                                            currentUser: currentUser,
                                          )),
                                    ),
                                  const SizedBox(
                                    height: 40,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildIcon(Widget icon, Function() ontap) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: ontap,
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: icon,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLikeIcon(Widget icon, Function() ontap) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: ontap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 10),
            child: Container(
              color: Colors.black38,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: icon,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Tags extends StatelessWidget {
  final List<dynamic> tags;
  final UserModel currentUser;
  const Tags({
    Key? key,
    required this.tags,
    required this.currentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ...tags
            .map(
              (e) => Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        createRoute(ProjectByTag(
                          currentUser: currentUser,
                          tag: e,
                        )));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black54,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "#" + e,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ],
    );
  }
}
