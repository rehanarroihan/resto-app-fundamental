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


