import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../models/project_model/datum.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewPhotos extends StatefulWidget {
  final int imageIndex;
  final List<Datum>? data;
  const ViewPhotos({
    Key? key,
    required this.imageIndex,
    this.data,
  }) : super(key: key);

  @override
  _ViewPhotosState createState() => _ViewPhotosState();
}

class _ViewPhotosState extends State<ViewPhotos> {
  late PageController pageController;
  late int currentIndex;
  @override
  void initState() {
    super.initState();
    currentIndex = widget.imageIndex;
    pageController = PageController(initialPage: widget.imageIndex);
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: CupertinoNavigationBar(
          backgroundColor: Colors.black,
          middle: Text(
            '${widget.data?.length ?? 0} Photos',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          border: const Border(
            bottom: BorderSide(color: Colors.grey, width: .4),
          ),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(
              CupertinoIcons.share,
              color: CupertinoColors.white,
            ),
            onPressed: () {
              launch(widget.data![currentIndex].url!);
            },
          ),
        ),
        body: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          pageController: pageController,
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(widget.data![index].url!),
              minScale: PhotoViewComputedScale.contained,
              heroAttributes:
                  PhotoViewHeroAttributes(tag: widget.data![index].url!),
            );
          },
          onPageChanged: onPageChanged,
          itemCount: widget.data!.length,
          loadingBuilder: (context, progress) => Center(
            child: SizedBox(
              width: 60.0,
              height: 60.0,
              child: CircularProgressIndicator(
                value: progress == null
                    ? null
                    : progress.cumulativeBytesLoaded /
                        progress.expectedTotalBytes!,
              ),
            ),
          ),
        ));
  }
}
