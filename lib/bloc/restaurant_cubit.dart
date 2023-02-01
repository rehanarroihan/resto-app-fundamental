import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant/db/database_helper.dart';
import 'package:restaurant/models/network_response/restaurant_detail_response.dart';
import 'package:restaurant/models/resto.dart';
import 'package:restaurant/models/resto_detail.dart';
import 'package:restaurant/services/restaurant_service.dart';

import '../models/network_response/restaurant_response.dart';

part 'restaurant_state.dart';

class RestaurantCubit extends Cubit<RestaurantState> {
  RestaurantCubit() : super(RestaurantInitial());

  final RestaurantService _restaurantService = RestaurantService();

  List<Resto> restaurants = [];
  bool isGetRestoListLoading = false;
  bool isGetRestoListErrorNoInternet = false;

  void getRestoList({String? query}) async {
    restaurants.clear();
    isGetRestoListErrorNoInternet = false;
    isGetRestoListLoading = true;
    emit(GetRestoListInit());

    List<Resto> favoriteList = await DatabaseHelper().getFavoriteResto();
    RestaurantResponse response = query?.isNotEmpty == true
        ? await _restaurantService.searchResto(query!)
        : await _restaurantService.getRestoList();

    if (response.error != true) {
      response.restaurants?.forEach((resto) { 
        for (var fav in favoriteList) {
          if (resto.id == fav.id) {
            resto.isFavorite = true;
          }
        }

        restaurants.add(resto);
      });
    } else {
      if (response.message!.contains("No internet")) {
        isGetRestoListErrorNoInternet = true;
      }
    }

    isGetRestoListLoading = false;
    emit(GetRestoListResult());
  }

  RestoDetail? restoDetail;
  bool isGetRestoDetailLoading = false;
  bool isGetRestoDetailErrorNoInternet = false;

  void getRestoDetail(String id) async {
    restoDetail = null;
    isGetRestoDetailErrorNoInternet = false;
    isGetRestoDetailLoading = true;
    emit(GetRestoDetailInit());

    RestaurantDetailResponse response = await _restaurantService.getDetail(id);

    if (response.error != true) {
      List<Resto> favoriteList = await DatabaseHelper().getFavoriteResto();

      restoDetail = response.restaurant;
      restoDetail?.isFavorite = favoriteList.where((el) => el.id == response.restaurant?.id).isNotEmpty;
    } else {
      if (response.message!.contains("No internet")) {
        isGetRestoDetailErrorNoInternet = true;
      }
    }

    isGetRestoDetailLoading = false;
    emit(GetRestoDetailResult());
  }

  List<Resto> favoriteList = [];
  bool favoriteListLoading = false;

  void getFavoriteList() async {
    favoriteList.clear();
    favoriteListLoading = true;
    emit(GetFavoriteRestoListInit());

    try {
      favoriteList = await DatabaseHelper().getFavoriteResto();
    } catch (_) {

    }

    favoriteListLoading = false;
    emit(GetFavoriteRestoResult());
  }

  void toggleFavorite(Resto resto) async {
    emit(ToggleFavoriteInit());

    try {
      if (resto.isFavorite == false) {
        resto.isFavorite = true;
        await DatabaseHelper().insertFavoriteResto(resto);
      } else {
        resto.isFavorite = false;
        await DatabaseHelper().deleteFavoriteResto(resto.id.toString());
      }

      // Changing isFavorite status to the home item list and maybe it's detail, and maybe also the favorite list
      restaurants.firstWhere((item) => item.id == resto.id).isFavorite = resto.isFavorite;
      if (restoDetail?.id == resto.id) {
        restoDetail?.isFavorite = resto.isFavorite;
      }
      if (favoriteList.where((item) => item.id == resto.id).isNotEmpty) {
        favoriteList.firstWhere((item) => item.id == resto.id).isFavorite = resto.isFavorite;
      }

      emit(ToggleFavoriteSuccess(resto: resto));
    } catch (_) {
      emit(ToggleFavoriteFailed());
    }
  }
}
