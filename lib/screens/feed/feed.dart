import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../profile/profile_screen.dart';
import '../show-shared-post/show_shared_post.dart';
import '../../widgets/loading/feed_loading.dart';
import '../../widgets/loading/search_page_loading.dart';
import '../../widgets/project/project.dart';
import 'package:uni_links/uni_links.dart';

import '../../animation.dart';
import '../../models/user_model.dart';
import 'bloc/feed_bloc.dart';
import '../../widgets/user_profile.dart';

class FeedScreen extends StatefulWidget {
  final UserModel currentUser;
  const FeedScreen({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    _handleUniLinks();
    super.initState();
  }

  void _handleUniLinks() async {
    var link = await getInitialLink();
    try {
      if (link != null) {
        if (link.startsWith("https://anshrathod.vercel.app/projectfolio?id=")) {
          var code = link
              .replaceFirst(
                  "https://anshrathod.vercel.app/projectfolio?id=", "")
              .trim();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowSharedPost(
                postId: code,
                currentUser: widget.currentUser,
                userId: '',
              ),
            ),
          );
        }
      }
    } on FormatException {}
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FeedBloc()..add(LoadFeed(userId: widget.currentUser.tableId!)),
      child: SafeArea(
        child: Scaffold(
          appBar: CupertinoNavigationBar(
            border: Border(
                bottom: BorderSide(width: .4, color: Colors.grey.shade700)),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            middle: const Text(
              "ProjectFolio",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: BlocBuilder<FeedBloc, FeedState>(
            builder: (context, state) {
              if (state is FeedLoading) {
                if (widget.currentUser.followingCount == 0) {
                  return const CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: LoadingList(),
                      ),
                    ],
                  );
                }
                return const CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: FeedLoadingWidget(),
                    ),
                  ],
                );
              }
              if (state is FeedLoaded) {
                if (state.posts.isEmpty) {
                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "Suggested users to follow",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        color: Theme.of(context).primaryColor),
                              ),
                            ),
                            Divider(
                              height: .5,
                              color: Colors.grey.shade700,
                            ),
                            ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder: (context, index) => Divider(
                                height: .5,
                                color: Colors.grey.shade800,
                              ),
                              shrinkWrap: true,
                              itemCount: state.users.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      createRoute(
                                        ProfileScreen(
                                          currentUser: widget.currentUser,
                                          id: state.users[index].id!,
                                          tableId: state.users[index].tableId!,
                                        ),
                                      ),
                                    );
                                  },
                                  contentPadding: const EdgeInsets.all(8),
                                  leading: UserProfile(
                                    url: state.users[index].avatarUrl!,
                                    size: 50,
                                  ),
                                  title: Text(
                                    state.users[index].name ??
                                        state.users[index].username!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(
                                          fontSize: 20,
                                        ),
                                  ),
                                  subtitle: Text(state.users[index].username!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                            color: Colors.grey.shade400,
                                          )),
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                }
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.posts.length,
                        itemBuilder: (context, index) {
                          final post = state.posts[index];
                          return ProjectWidget(
                            project: post,
                            currentUser: widget.currentUser,
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
              if (state is FeedError) {
                return Center(
                  child: Text(
                    "Something went wrong",
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                          fontSize: 24,
                        ),
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
