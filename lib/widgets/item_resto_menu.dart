import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ItemRestoMenu extends StatelessWidget {
  final String imageUrl;
  final String itemName;

  const ItemRestoMenu({
    Key? key,
    required this.imageUrl,
    required this.itemName
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0Df9701f),
            offset: Offset(0, 10),
            blurRadius: 20,
          ),
        ]
      ),
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            height: 112,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              itemName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600
              ),
            ),
          )
        ],
      ),
    );
  }
}
