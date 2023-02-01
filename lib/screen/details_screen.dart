import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restaurant/bloc/restaurant_cubit.dart';
import 'package:restaurant/models/resto.dart';
import 'package:restaurant/widgets/item_customer_review.dart';
import 'package:restaurant/widgets/item_resto_menu.dart';
import 'package:restaurant/widgets/negative_view_state.dart';
import 'package:restaurant/widgets/skeleton.dart';

class DetailsScreen extends StatefulWidget {
  final String id;
  final String imageId;
  final String restoName;
  final String city;
  final double rating;

  const DetailsScreen({
    Key? key,
    required this.id,
    required this.imageId,
    required this.restoName,
    required this.city,
    required this.rating,
  }) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late RestaurantCubit _restaurantCubit;

  @override
  void initState() {
    super.initState();

    _restaurantCubit = BlocProvider.of<RestaurantCubit>(context);

    _restaurantCubit.getRestoDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _restaurantCubit,
      builder: (context, state) {
        return Scaffold(
          body: _restaurantCubit.isGetRestoDetailErrorNoInternet ? Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: NegativeViewState(
                  assets: 'assets/image_no_internet.png',
                  title: 'No Internet',
                  description: 'Tidak ada koneksi internet,\nPastikan anda terhubung ke internet',
                  actionButtonText: 'Coba Lagi',
                  onActionButtonTap: () => _restaurantCubit.getRestoDetail(widget.id),
                ),
              ),
            ],
          ) : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _headerSection(),

                _restaurantCubit.isGetRestoDetailLoading
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _loadingViewState()
                      )
                    : _bodySection()
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _headerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CachedNetworkImage(
          imageUrl: "https://restaurant-api.dicoding.dev/images/large/${widget.imageId}",
          height: 320,
          placeholder: (context, url) => const Skeleton(
            height: 320,
            width: double.infinity,
          ),
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
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
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.restoName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700
                    ),
                  ),
                  Text(
                    widget.city,
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
                        initialRating: widget.rating,
                        direction: Axis.horizontal,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (double value) {  },
                      ),
                      const SizedBox(width: 4),
                      Text('(${widget.rating})'),
                    ],
                  ),
                ],
              ),
            ),

            _restaurantCubit.isGetRestoDetailLoading ? const SizedBox() : Container(
              margin: const EdgeInsets.only(right: 8),
              child: Material(
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
                      _restaurantCubit.restoDetail?.isFavorite == true
                          ? Icons.favorite
                          : Icons.favorite_border_outlined
                    ),
                  ),
                  onTap: () {
                    if (!_restaurantCubit.isGetRestoDetailLoading) {
                      _restaurantCubit.toggleFavorite(Resto(
                        id: _restaurantCubit.restoDetail?.id,
                        name: _restaurantCubit.restoDetail?.name,
                        description: _restaurantCubit.restoDetail?.description,
                        city: _restaurantCubit.restoDetail?.city,
                        pictureId: _restaurantCubit.restoDetail?.pictureId,
                        rating: _restaurantCubit.restoDetail?.rating,
                        isFavorite: _restaurantCubit.restoDetail?.isFavorite,
                      ));
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _bodySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            _restaurantCubit.restoDetail?.description ?? "",
            style: const TextStyle(
              fontWeight: FontWeight.w500
            ),
          ),
        ),

        const SizedBox(height: 16),

        const Center(
          child: Text(
            'Menu',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700
            ),
          ),
        ),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: const Text(
            'Makanan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700
            ),
          ),
        ),

        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
            itemCount: _restaurantCubit.restoDetail?.menus?.foods?.length ?? 0,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return AspectRatio(
                aspectRatio: 9/11,
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: ItemRestoMenu(
                    imageUrl: 'https://luigispizzakenosha.com/wp-content/uploads/placeholder.png',
                    itemName: _restaurantCubit.restoDetail?.menus?.foods![index].name ?? "",
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 4),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: const Text(
            'Minuman',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700
            ),
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
            itemCount: _restaurantCubit.restoDetail?.menus?.drinks?.length ?? 0,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return AspectRatio(
                aspectRatio: 9/11,
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: ItemRestoMenu(
                    imageUrl: 'https://www.mixlabcocktails.com/images/cocktail-image/image-placeholder@3x.png',
                    itemName: _restaurantCubit.restoDetail?.menus?.drinks![index].name ?? "",
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 24),

        Center(
          child: Text(
            'Review (${_restaurantCubit.restoDetail?.customerReviews?.length})',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700
            ),
          ),
        ),
        ListView.builder(
          itemCount: _restaurantCubit.restoDetail?.customerReviews?.length ?? 0,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: ItemCustomerReview(
                name: _restaurantCubit.restoDetail?.customerReviews?[index].name ?? "",
                date: _restaurantCubit.restoDetail?.customerReviews?[index].date ?? "",
                review: _restaurantCubit.restoDetail?.customerReviews?[index].review ?? ""
              ),
            );
          },
        ),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _loadingViewState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Skeleton(
          height: 16,
          width: double.infinity,
          radius: 4,
        ),
        const SizedBox(height: 8),
        const Skeleton(
          height: 16,
          width: double.infinity,
          radius: 4,
        ),
        const SizedBox(height: 8),
        const Skeleton(
          height: 16,
          width: double.infinity,
          radius: 4,
        ),
        const SizedBox(height: 8),
        const Skeleton(
          height: 16,
          width: double.infinity,
          radius: 4,
        ),
        const SizedBox(height: 8),
        Skeleton(
          height: 16,
          width: MediaQuery.of(context).size.width * 0.7,
          radius: 4,
        ),
      ],
    );
  }
}
