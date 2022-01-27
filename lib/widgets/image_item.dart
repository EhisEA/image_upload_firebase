import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_image_upload/models/image_item.dart';
import 'package:flutter/material.dart';

class ImageItemWidget extends StatelessWidget {
  const ImageItemWidget({Key? key, this.onDelete, required this.item})
      : super(key: key);
  final Function()? onDelete;
  final ImageItem item;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CachedNetworkImage(
            placeholder: (context, _) => Container(
              color: Colors.black26,
            ),
            imageUrl: item.url,
            fit: BoxFit.cover,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            // height: 65,
            width: double.infinity,
            constraints: const BoxConstraints(
              maxHeight: 75,
              minHeight: 65,
            ),
            padding: const EdgeInsets.all(10),
            color: Colors.black.withOpacity(0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.author,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 3),
                Text(
                  item.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        Positioned(
            top: 10,
            right: 10,
            child: InkWell(
              onTap: onDelete,
              child: ClipOval(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  color: Colors.black.withOpacity(0.4),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
