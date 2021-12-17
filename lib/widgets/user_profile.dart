import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  final String url;
  final double size;
  const UserProfile({
    Key? key,
    required this.url,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: CachedNetworkImage(
          imageUrl: url,
          height: size,
          width: size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
