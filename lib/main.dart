import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant/bloc/restaurant_cubit.dart';
import 'package:restaurant/screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    RestaurantCubit restaurantCubit = RestaurantCubit();

    return MultiBlocProvider(
      providers: [
        BlocProvider<RestaurantCubit>(create: (context) => restaurantCubit),
      ],
      child: MaterialApp(
        title: 'Restaurant',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          textTheme: GoogleFonts.poppinsTextTheme()
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
