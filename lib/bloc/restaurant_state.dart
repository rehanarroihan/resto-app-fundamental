part of 'restaurant_cubit.dart';

abstract class RestaurantState extends Equatable {
  const RestaurantState();

  @override
  List<Object> get props => [];
}

class RestaurantInitial extends RestaurantState {}

class GetRestoListInit extends RestaurantState {}

class GetRestoListResult extends RestaurantState {}

class GetRestoDetailInit extends RestaurantState {}

class GetRestoDetailResult extends RestaurantState {}

class GetFavoriteRestoListInit extends RestaurantState {}

class GetFavoriteRestoResult extends RestaurantState {}

class ToggleFavoriteInit extends RestaurantState {}

class ToggleFavoriteFailed extends RestaurantState {}

class ToggleFavoriteSuccess extends RestaurantState {
  final Resto? resto;

  const ToggleFavoriteSuccess({this.resto});
}


