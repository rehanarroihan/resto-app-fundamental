import 'package:restaurant/models/resto_detail.dart';

class RestaurantDetailResponse {
  bool? error;
  String? message;
  RestoDetail? restaurant;

  RestaurantDetailResponse({this.error, this.message, this.restaurant});

  RestaurantDetailResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    restaurant = json['restaurant'] != null
        ? RestoDetail.fromJson(json['restaurant'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['message'] = message;
    if (restaurant != null) {
      data['restaurant'] = restaurant!.toJson();
    }
    return data;
  }
}