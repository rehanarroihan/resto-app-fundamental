import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restaurant/models/restaurant.dart';

class DetailsScreen extends StatefulWidget {
  final String id;

  const DetailsScreen({
    Key? key,
    required this.id
  }) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool _isLoading = false;
  Restaurant? _data;

  void initState() {
    _getDetail();

    super.initState();
  }

  void _getDetail() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String? data = await DefaultAssetBundle.of(context).loadString("assets/restaurants.json");
      var restoRawList = jsonDecode(data)['restaurants'];
      var list = [];
      restoRawList.forEach((v) {
        list.add(Restaurant.fromJson(v));
      });
      _data = list.where((element) => element.id == widget.id).first;
      _isLoading = false;

      setState(() {});
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading ? const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
          ),
        ) : SingleChildScrollView(
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: _data?.pictureId ?? '',
                height: 320,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
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
                      _data?.name! ?? "",
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                    Text(
                      _data?.city! ?? "",
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
                          initialRating: _data?.rating ?? 0.0,
                          direction: Axis.horizontal,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (double value) {  },
                        ),
                        const SizedBox(width: 4),
                        Text('(${_data?.rating!})'),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Text(
                      _data?.description! ?? "",
                      style: const TextStyle(
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ),
              ),

              const Center(
                child: Text(
                  'Menu',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Makanan',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                    ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: _data?.menus!.foods!.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.only(right: 16),
                          child: Text(_data?.menus!.foods![index].name ?? ""),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Minuman',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                    ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: _data?.menus!.drinks!.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.only(right: 16),
                          child: Text(_data?.menus!.drinks![index].name ?? ""),
                        );
                      },
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
