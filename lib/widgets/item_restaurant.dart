import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ItemRestaurant extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String name;
  final String type;
  final double rating;
  final bool isFavorite;
  final Function onTap;
  final Function onFavoriteToggleClick;

  const ItemRestaurant({
    Key? key,
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.type,
    required this.rating,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggleClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Color(0x0Df9701f),
              offset: Offset(0, 10),
              blurRadius: 20,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              height: 160,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)
                  ),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700
                        ),
                      ),
                      Text(
                        type,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500
                        ),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          RatingBar.builder(
                            itemSize: 20,
                            ignoreGestures: true,
                            initialRating: rating,
                            direction: Axis.horizontal,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (double value) {  },
                          ),
                          const SizedBox(width: 4),
                          Text('($rating)'),
                        ],
                      )
                    ],
                  ),
                ),

                Material(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(8),
                    topLeft: Radius.circular(8),
                  ),
                  child: InkWell(
                    splashColor: Theme.of(context).primaryColorLight,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(8),
                      topLeft: Radius.circular(8),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(8)
                        )
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border_outlined
                      ),
                    ),
                    onTap: () => onFavoriteToggleClick(),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
