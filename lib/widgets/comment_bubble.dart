import 'package:flutter/material.dart';
import '../models/comment_model.dart';
import 'readmore.dart';
import 'user_profile.dart';

import '../api_key.dart';

class CommentBubbble extends StatelessWidget {
  final CommentModel comment;
  const CommentBubbble({
    Key? key,
    required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: UserProfile(
        size: 50,
        url: comment.avatarUrl,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text(
        comment.name,
        style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 20),
      ),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReadMoreText(
            comment.comment,
            trimLines: 2,
            style: Theme.of(context).textTheme.bodyText1,
            colorClickableText: Theme.of(context).primaryColor,
            trimMode: TrimMode.line,
            trimCollapsedText: 'Show more',
            trimExpandedText: 'Show less',
            moreStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            StringExtension.displayTimeAgoFromTimestamp(
              comment.commentCreatedAt,
            ),
            style:
                Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
