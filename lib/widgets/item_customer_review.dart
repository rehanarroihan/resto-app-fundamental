import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:restaurant/widgets/skeleton.dart';

class ItemCustomerReview extends StatelessWidget {
  final String name, date, review;

  const ItemCustomerReview({
    Key? key,
    required this.name,
    required this.date,
    required this.review
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var profilePictureSize = 42.0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.grey.shade200)
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CachedNetworkImage(
                height: profilePictureSize,
                width: profilePictureSize,
                imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png',
                placeholder: (context, url) => Skeleton(
                  height: profilePictureSize,
                  width: profilePictureSize,
                  radius: profilePictureSize,
                ),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(80)),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  Text(
                    date,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500
                    ),
                  )
                ],
              )
            ],
          ),

          const SizedBox(height: 12),

          Text(
            review,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500
            ),
          ),
        ],
      ),
    );
  }
}
