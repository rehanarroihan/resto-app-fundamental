import 'package:restaurant/models/resto.dart';

class RestaurantResponse {
  bool? error;
  String? message;
  int? count;
  List<Resto>? restaurants;

  RestaurantResponse({this.error, this.message, this.count, this.restaurants});

  RestaurantResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    count = json['count'];
    if (json['restaurants'] != null) {
      restaurants = <Resto>[];
      json['restaurants'].forEach((v) {
        restaurants!.add(Resto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['message'] = message;
    data['count'] = count;
    if (restaurants != null) {
      data['restaurants'] = restaurants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}