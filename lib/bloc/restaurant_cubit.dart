import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    RestaurantResponse response = query?.isNotEmpty == true
        ? await _restaurantService.searchResto(query!)
        : await _restaurantService.getRestoList();

    if (response.error != true) {
      restaurants.addAll(response.restaurants ?? []);
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
      restoDetail = response.restaurant;
    } else {
      if (response.message!.contains("No internet")) {
        isGetRestoDetailErrorNoInternet = true;
      }
    }

    isGetRestoDetailLoading = false;
    emit(GetRestoDetailResult());
  }
}
