import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant/bloc/restaurant_cubit.dart';
import 'package:restaurant/common/navigation.dart';
import 'package:restaurant/screen/detail_screen.dart';
import 'package:restaurant/screen/home_screen.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    RestaurantCubit restaurantCubit = RestaurantCubit();

    return MultiBlocProvider(
      providers: [
        BlocProvider<RestaurantCubit>(create: (context) => restaurantCubit),
      ],
      child: MaterialApp(
        title: 'Restaurant',
        navigatorKey: navigatorKey,
        theme: ThemeData(
          primarySwatch: Colors.orange,
          textTheme: GoogleFonts.poppinsTextTheme()
        ),
        initialRoute: HomeScreen.routeName,
        routes: {
          HomeScreen.routeName: (context) => const HomeScreen(),
          DetailScreen.routeName: (context) => DetailScreen(
            args: ModalRoute.of(context)?.settings.arguments as DetailScreenArgs,
          ),
        },
      ),
    );
  }
}