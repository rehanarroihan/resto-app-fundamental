import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant/models/restaurant.dart';
import 'package:restaurant/screen/details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Restaurant> _restoList = [];

  @override
  void initState() {
    _getList();
    super.initState();
  }

  void _getList() async {
    try {
      String? data = await DefaultAssetBundle.of(context).loadString("assets/restaurants.json");
      var restoRawList = jsonDecode(data)['restaurants'];
      restoRawList.forEach((v) {
        _restoList.add(Restaurant.fromJson(v));
      });

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf9f9fb),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'TheResto',
                  style: GoogleFonts.pacifico(fontSize: 24, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _searchBox()
              ),

              const SizedBox(height: 32),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Text(
                  'Top Rated Restaurant',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700
                  ),
                ),
              ),
              SizedBox(
                height: 330,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: _restoList.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(left: 16, top: 16, bottom: 44),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.62,
                      margin: const EdgeInsets.only(right: 16),
                      child: _restaurantItem(
                        id: _restoList[index].id!,
                        imageUrl: _restoList[index].pictureId!,
                        name: _restoList[index].name!,
                        type: _restoList[index].city!,
                        rating: _restoList[index].rating!
                      ),
                    );
                  },
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Text(
                  'Temukan yang lain!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: _restoList.reversed.map<Widget>((Restaurant resto) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: _restaurantItem(
                        id: resto.id!,
                        imageUrl: resto.pictureId!,
                        name: resto.name!,
                        type: resto.city!,
                        rating: resto.rating!
                      ),
                    );
                  }).toList()
                ),
              ),
            ],
          ),
        ),
      ),
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
      ),
    );
  }

  Widget _restaurantItem({
    required String id,
    required String imageUrl,
    required String name,
    required String type,
    required double rating,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => DetailsScreen(id: id)
        ));
      },
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
                    topLeft: Radius.circular(12), topRight: Radius.circular(12)
                  ),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

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
            )
          ],
        ),
      ),
    );
  }
}
