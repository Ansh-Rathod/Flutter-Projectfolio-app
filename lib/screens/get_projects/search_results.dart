import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user_model.dart';
import '../../widgets/project/project.dart';

import 'cubit/get_search_results_cubit.dart';

class ProjectByTag extends StatelessWidget {
  final UserModel currentUser;
  final String tag;
  const ProjectByTag({
    Key? key,
    required this.currentUser,
    required this.tag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetProjectsByTagCubit()..getProjectsByTag(tag),
      child: Scaffold(
        appBar: CupertinoNavigationBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          border: Border(
            bottom: BorderSide(
              width: .4,
              color: Colors.grey.shade800,
            ),
          ),
          middle: Text(
            tag,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
          ),
        ),
        body: BlocBuilder<GetProjectsByTagCubit, GetProjectsByTagState>(
          builder: (context, state) {
            if (state.status == GetProjectsByTagStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state.status == GetProjectsByTagStatus.error) {
              return Center(
                child: Text(
                  "Something went wrong",
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                        fontSize: 24,
                      ),
                ),
              );
            }

            if (state.status == GetProjectsByTagStatus.success) {
              if (state.isEmpty) {
                return const Center(
                    child: Text(
                  "No results found",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ));
              }
              return ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                        height: .5,
                        color: Colors.grey.shade800,
                      ),
                  itemCount: state.projects.length,
                  itemBuilder: (context, index) {
                    final project = state.projects[index];
                    return ProjectWidget(
                        project: project, currentUser: currentUser);
                  });
            }
            return Container();
          },
        ),
      ),
    );
  }
}
