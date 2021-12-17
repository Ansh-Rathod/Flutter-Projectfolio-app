import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../animation.dart';
import '../../models/user_model.dart';
import 'cubit/get_search_results_cubit.dart';
import 'search_results.dart';

class SearchPage extends StatefulWidget {
  final UserModel currentUser;
  const SearchPage({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isUser = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Search",
                    style: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(fontSize: 34),
                  ),
                ),
              ),
              SliverAppBar(
                floating: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: const EdgeInsets.only(top: 5.0, bottom: 10),
                  title: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(12),
                        suffixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context).primaryColor,
                        ),
                        prefixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              isUser = !isUser;
                            });
                          },
                          child: Icon(
                            isUser
                                ? CupertinoIcons.person_2
                                : CupertinoIcons.list_dash,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        border: InputBorder.none,
                        hintText:
                            isUser ? 'Search users..' : 'Search projects..',
                      ),
                      onSubmitted: (String value) {
                        if (isUser) {
                          Navigator.push(
                            context,
                            createRoute(
                              BlocProvider(
                                create: (context) => GetSearchResultsCubit()
                                  ..getSearchResults(value.toLowerCase(),
                                      widget.currentUser.id!, false),
                                child: SearchResults(
                                  currentUser: widget.currentUser,
                                ),
                              ),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            createRoute(
                              BlocProvider(
                                create: (context) => GetSearchResultsCubit()
                                  ..getProjectSearchResults(
                                      value.toLowerCase(), false),
                                child: SearchResults(
                                  currentUser: widget.currentUser,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 10,
                ),
              ),
            ];
          },
          body: Container(
            child: ValueListenableBuilder<Box>(
                valueListenable: Hive.box('recents').listenable(),
                builder: (context, box, child) {
                  if (box.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * .77,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Search for \nusers or projects.",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(
                                          fontSize: 24,
                                          color: Colors.grey.shade400,
                                        ),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  "No Recent Searches, Try searching for users, projects and hastags.",
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                            color: Colors.grey.shade800,
                            height: 1,
                          ),
                      itemBuilder: (context, i) {
                        final info = box.getAt(i);

                        return ListTile(
                          onTap: () {
                            if (info['type'] == 'user') {
                              Navigator.push(
                                context,
                                createRoute(
                                  BlocProvider(
                                    create: (context) => GetSearchResultsCubit()
                                      ..getSearchResults(info['searchText'],
                                          widget.currentUser.id!, true),
                                    child: SearchResults(
                                      currentUser: widget.currentUser,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                createRoute(
                                  BlocProvider(
                                    create: (context) => GetSearchResultsCubit()
                                      ..getProjectSearchResults(
                                          info['searchText'], true),
                                    child: SearchResults(
                                      currentUser: widget.currentUser,
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                          leading: Icon(
                            Icons.access_time,
                            size: 30,
                            color: Theme.of(context).primaryColor,
                          ),
                          title: Text(
                            info['searchText'],
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          subtitle: Text(
                            "Searched in " + info['type'],
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.grey),
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                box.deleteAt(i);
                              },
                              icon: Icon(
                                Icons.clear,
                                color: Colors.grey.shade500,
                              )),
                        );
                      },
                      itemCount: box.length);
                }),
          ),
        ),
      ),
    );
  }
}
