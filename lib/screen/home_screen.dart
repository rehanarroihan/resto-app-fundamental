import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurant/bloc/restaurant_cubit.dart';
import 'package:restaurant/screen/details_screen.dart';
import 'package:restaurant/screen/favorites_screen.dart';
import 'package:restaurant/screen/setting_screen.dart';
import 'package:restaurant/widgets/item_restaurant.dart';
import 'package:restaurant/widgets/negative_view_state.dart';
import 'package:restaurant/widgets/toast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late RestaurantCubit _restaurantCubit;

  @override
  void initState() {
    super.initState();

    _restaurantCubit = BlocProvider.of<RestaurantCubit>(context);

    _restaurantCubit.getRestoList();
  }

  final TextEditingController _inputSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _restaurantCubit,
      listener: (context, state) {
        if (state is ToggleFavoriteSuccess) {
          if (state.resto?.isFavorite == true) {
            showFlutterToast("Berhasil menambahkan ke favorite");
          } else {
            showFlutterToast("Berhasil menhapus favorite");
          }
        } else if (state is ToggleFavoriteFailed) {
          showFlutterToast("Gagal");
        }
      },
      child: BlocBuilder(
        bloc: _restaurantCubit,
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFf9f9fb),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'TheResto',
                            style: GoogleFonts.pacifico(fontSize: 24, fontWeight: FontWeight.w700),
                          ),
                        ),

                        Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.push(context, MaterialPageRoute(
                                builder: (context) => const FavoritesScreen()
                              )),
                              icon: const Icon(Icons.favorite),
                            ),
                            IconButton(
                              onPressed: () => Navigator.push(context, MaterialPageRoute(
                                builder: (context) => const SettingScreen()
                              )),
                              icon: const Icon(Icons.settings),
                            ),
                          ],
                        )
                      ],
                    ),

                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _searchBox()
                    ),

                    const SizedBox(height: 24),

                    _buildList(),
                  ],
                ),
              ),
            ),
          );
        },
      )
    );
  }

  Widget _searchBox() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0Df9701f),
            offset: Offset(0, 10),
            blurRadius: 20,
          ),
        ],
      ),
      child: TextFormField(
        controller: _inputSearch,
        decoration: const InputDecoration(
          filled: true,
          hintText: "Cari restoran favorit mu",
          fillColor: Colors.white,
          errorBorder: InputBorder.none,
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Icon(Icons.search),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Colors.transparent, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Colors.transparent),
          ),
        ),
        textInputAction: TextInputAction.search,
        onEditingComplete: () {
          _restaurantCubit.getRestoList(query: _inputSearch.text);
        },
      ),
    );
  }

  Widget _buildList() {
    if (_restaurantCubit.isGetRestoListLoading) {
      return Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          width: 104,
          child: Lottie.asset('assets/loading.json')
        ),
      );
    } else {
      if (_restaurantCubit.isGetRestoListErrorNoInternet) {
        return const Center(
          child: NegativeViewState(
            assets: 'assets/image_no_internet.png',
            title: 'No Internet',
            description: 'Tidak ada koneksi internet,\nPastikan anda terhubung ke internet',
          ),
        );
      } else {
        if (_restaurantCubit.restaurants.isEmpty) {
          return Center(
            child: NegativeViewState(
              assets: 'assets/image_no_internet.png',
              title: 'Hasil tidak ditemukan',
              description: 'Tidak ditemukan hasil pencarian\ndari kata kunci ${_inputSearch.text}'
            ),
          );
        } else {
          return ListView.builder(
            itemCount: _restaurantCubit.restaurants.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemBuilder: (BuildContext context, int index) {
              String imageId = _restaurantCubit.restaurants[index].pictureId!;
              String imageUrl = "https://restaurant-api.dicoding.dev/images/medium/$imageId";

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: ItemRestaurant(
                  id: _restaurantCubit.restaurants[index].id!,
                  imageUrl: imageUrl,
                  name: _restaurantCubit.restaurants[index].name!,
                  type: _restaurantCubit.restaurants[index].city!,
                  rating: _restaurantCubit.restaurants[index].rating!,
                  isFavorite: _restaurantCubit.restaurants[index].isFavorite!,
                  onFavoriteToggleClick: () {
                    _restaurantCubit.toggleFavorite(_restaurantCubit.restaurants[index]);
                  },
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => DetailsScreen(
                        id: _restaurantCubit.restaurants[index].id!,
                        imageId: imageId,
                        restoName: _restaurantCubit.restaurants[index].name!,
                        city: _restaurantCubit.restaurants[index].city!,
                        rating: _restaurantCubit.restaurants[index].rating!,
                      )
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
}
