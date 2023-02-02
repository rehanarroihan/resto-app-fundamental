import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurant/bloc/restaurant_cubit.dart';
import 'package:restaurant/screen/detail_screen.dart';
import 'package:restaurant/widgets/item_restaurant.dart';
import 'package:restaurant/widgets/negative_view_state.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late RestaurantCubit _restaurantCubit;

  @override
  void initState() {
    super.initState();

    _restaurantCubit = BlocProvider.of<RestaurantCubit>(context);

    _restaurantCubit.getFavoriteList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _restaurantCubit,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: const Color(0xFFf9f9fb),
            title: const Text(
              'Favorites',
              style: TextStyle(
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          body: _buildList(),
        );
      }
    );
  }

  Widget _buildList() {
    if (_restaurantCubit.favoriteListLoading) {
      return Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          width: 104,
          child: Lottie.asset('assets/loading.json')
        ),
      );
    } else {
      if (_restaurantCubit.favoriteList.isEmpty) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Center(
              child: NegativeViewState(
                assets: 'assets/image_no_internet.png',
                title: 'Restoran Favorit Kosong',
                description: 'mulai tambahkan resto favorit mu\ndi halaman utama!'
              ),
            ),
          ],
        );
      } else {
        return ListView.builder(
          itemCount: _restaurantCubit.favoriteList.length,
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemBuilder: (BuildContext context, int index) {
            String imageId = _restaurantCubit.favoriteList[index].pictureId!;
            String imageUrl = "https://restaurant-api.dicoding.dev/images/medium/$imageId";

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: ItemRestaurant(
                id: _restaurantCubit.favoriteList[index].id!,
                imageUrl: imageUrl,
                name: _restaurantCubit.favoriteList[index].name!,
                type: _restaurantCubit.favoriteList[index].city!,
                rating: _restaurantCubit.favoriteList[index].rating!,
                isFavorite: _restaurantCubit.favoriteList[index].isFavorite!,
                onFavoriteToggleClick: () {
                  _restaurantCubit.toggleFavorite(_restaurantCubit.favoriteList[index]);
                },
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => DetailScreen(args: DetailScreenArgs(
                      id: _restaurantCubit.favoriteList[index].id!,
                      imageId: imageId,
                      restoName: _restaurantCubit.favoriteList[index].name!,
                      city: _restaurantCubit.favoriteList[index].city!,
                      rating: _restaurantCubit.favoriteList[index].rating!
                    ))
                  ));
                },
              ),
            );
          },
        );
      }
    }
  }
}
