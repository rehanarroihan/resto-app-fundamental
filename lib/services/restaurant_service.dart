import 'package:dio/dio.dart';
import 'package:restaurant/models/network_response/restaurant_detail_response.dart';
import 'package:restaurant/models/network_response/restaurant_response.dart';

class RestaurantService {
  String baseUrl = "https://restaurant-api.dicoding.dev/";

  Future<RestaurantResponse> getRestoList() async {
    try {
      Response response = await Dio().get("${baseUrl}list");

      if (response.statusCode == 200) {
        return RestaurantResponse.fromJson(response.data);
      }

      return RestaurantResponse(
        error: true,
        message: "Something went wrong",
        count: 0,
        restaurants: []
      );
    } on DioError catch (e, _) {
      if (e.message.contains("Failed host lookup")) {
        return RestaurantResponse(
          error: true,
          message: "No internet connection",
          count: 0,
          restaurants: []
        );
      }

      return RestaurantResponse(
        error: true,
        message: "Something went wrong",
        count: 0,
        restaurants: []
      );
    } catch (e) {
      return RestaurantResponse(
        error: true,
        message: "Something went wrong",
        count: 0,
        restaurants: []
      );
    }
  }

  Future<RestaurantResponse> searchResto(String query) async {
    try {
      Response response = await Dio().get("${baseUrl}search?q=$query");

      if (response.statusCode == 200) {
        return RestaurantResponse.fromJson(response.data);
      }

      return RestaurantResponse(
        error: true,
        message: "Something went wrong",
        count: 0,
        restaurants: []
      );
    } on DioError catch (e, _) {
      if (e.message.contains("Failed host lookup")) {
        return RestaurantResponse(
          error: true,
          message: "No internet connection",
          count: 0,
          restaurants: []
        );
      }

      return RestaurantResponse(
        error: true,
        message: "Something went wrong",
        count: 0,
        restaurants: []
      );
    } catch (e) {
      return RestaurantResponse(
        error: true,
        message: "Something went wrong",
        count: 0,
        restaurants: []
      );
    }
  }

  Future<RestaurantDetailResponse> getDetail(String id) async {
    try {
      Response response = await Dio().get("${baseUrl}detail/$id");

      if (response.statusCode == 200) {
        return RestaurantDetailResponse.fromJson(response.data);
      }

      return RestaurantDetailResponse(
        error: true,
        message: "Something went wrong",
      );
    } on DioError catch (e, _) {
      if (e.message.contains("Failed host lookup")) {
        return RestaurantDetailResponse(
          error: true,
          message: "No internet connection",
        );
      }

      return RestaurantDetailResponse(
        error: true,
        message: "Something went wrong",
      );
    } catch (e) {
      return RestaurantDetailResponse(
        error: true,
        message: "Something went wrong",
      );
    }
  }
}