import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../screens/add_comments/add_comment.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../animation.dart';
import '../../api_key.dart';
import '../../models/project_model/project_model.dart';
import '../../models/user_model.dart';
import '../../screens/project_info/project_info.dart';
import '../user_profile.dart';
import 'cubit/project_info_cubit.dart';

class ProjectWidget extends StatelessWidget {
  final ProjectModel project;
  final UserModel currentUser;
  const ProjectWidget({
    Key? key,
    required this.project,
    required this.currentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProjectInfoCubit()..init(project.likes!, currentUser.id!),
      child: BlocBuilder<ProjectInfoCubit, ProjectInfoState>(
        builder: (context, state) {
          return Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      createRoute(ProjectInfo(
                        data: project,
                        currentUser: currentUser,
                      )));
                },
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  boxShadow: kElevationToShadow[8],
                                ),
                                child: AspectRatio(
                                  aspectRatio: 12 / 9,
                                  child: Hero(
                                    tag: project.images!.data![0].url ?? '',
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          project.images!.data![0].url ?? '',
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          AspectRatio(
                                        aspectRatio: 12 / 9,
                                        child: Shimmer.fromColors(
                                          baseColor: Colors.white10,
                                          highlightColor: Colors.white12,
                                          child: Container(
                                            color: Colors.grey.shade900,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                left: 10,
                                child: Column(
                                  children: [
                                    buildIcon(
                                        buildTypeIcon(project.type!), () {})
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: Column(
                                  children: [
                                    buildIcon(
                                      const Icon(
                                        CupertinoIcons.bubble_left,
                                        color: Colors.white,
                                      ),
                                      () {
                                        Navigator.push(
                                          context,
                                          createRoute(
                                            CommentScreen(
                                              userId: project.userId!,
                                              projectId: project.projectId!,
                                              currentUser: currentUser,
                                              tableId: project.tableId!,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    buildLikeIcon(
                                      !state.isLiked
                                          ? const Icon(
                                              CupertinoIcons.heart,
                                              color: Colors.white,
                                            )
                                          : const Icon(
                                              CupertinoIcons.heart_solid,
                                              color: Colors.red,
                                            ),
                                      () {
                                        BlocProvider.of<ProjectInfoCubit>(
                                                context)
                                            .like(project, currentUser.id!);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 10,
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
                                            "https://twitter.com/intent/tweet?url=https://anshrathod.vercel.app/projectfolio?id=${project.projectId!}&text=${project.title!} by @${project.twitterUsername ?? project.username!}");
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
                                            'https://www.linkedin.com/shareArticle?mini=true&url=https://anshrathod.vercel.app/projectfolio?id=${project.projectId!}');
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
                                            "https://anshrathod.vercel.app/projectfolio?id=${project.projectId!}");
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              project.title!,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              project.description!,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: Colors.white70,
                                  ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Tags(
                              tags: project.tags!,
                              currentUser: currentUser,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    UserProfile(
                                        url: project.avatarUrl!, size: 30),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      project.name ?? project.username!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300),
                                    )
                                  ],
                                ),
                                Text(
                                  StringExtension.displayTimeAgoFromTimestamp(
                                    project.postedAt!,
                                  ),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(color: Colors.grey.shade700)
            ],
          );
        },
      ),
    );
  }

  Widget buildIcon(Icon icon, Function() ontap) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: ontap,
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(.5),
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
              color: Colors.black.withOpacity(.5),
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

  Icon buildTypeIcon(String type) {
    if (type == 'Project') {
      return const Icon(
        Icons.padding,
        color: Colors.white,
        size: 18,
      );
    } else if (type == 'Blog') {
      return const Icon(
        FontAwesomeIcons.blog,
        color: Colors.white,
        size: 18,
      );
    } else if (type == 'Android App') {
      return const Icon(
        FontAwesomeIcons.android,
        color: Colors.white,
        size: 18,
      );
    } else if (type == 'iOS App') {
      return const Icon(
        FontAwesomeIcons.appStoreIos,
        color: Colors.white,
        size: 18,
      );
    } else if (type == 'Native App') {
      return const Icon(
        Icons.flutter_dash,
        color: Colors.white,
        size: 18,
      );
    } else if (type == 'Hybrid App') {
      return const Icon(
        FontAwesomeIcons.draft2digital,
        color: Colors.white,
        size: 18,
      );
    } else {
      return const Icon(
        FontAwesomeIcons.store,
        color: Colors.white,
        size: 18,
      );
    }
  }
}
