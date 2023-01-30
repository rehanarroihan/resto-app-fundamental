import 'package:restaurant/models/food.dart';
import 'package:restaurant/models/drink.dart';

class Menu {
  List<Food>? foods;
  List<Drink>? drinks;

  Menu({this.foods, this.drinks});

  Menu.fromJson(Map<String, dynamic> json) {
    if (json['foods'] != null) {
      foods = <Food>[];
      json['foods'].forEach((v) {
        foods!.add(Food.fromJson(v));
      });
    }
    if (json['drinks'] != null) {
      drinks = <Drink>[];
      json['drinks'].forEach((v) {
        drinks!.add(Drink.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (foods != null) {
      data['foods'] = foods!.map((v) => v.toJson()).toList();
    }
    if (drinks != null) {
      data['drinks'] = drinks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}