import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_nti_aug/cubits/popular_cubit/popular_cubit.dart';

import 'nav_screen.dart';
import '../../cubits/home_cubit/home_cubit.dart';
import '../../cubits/now_playing_cubits/now_playing_cubit.dart';
import '../../cubits/upcoming/upcoming_cubit.dart';
import '../../cubits/top_rated/toprated_cubit.dart';
import '../../cubits/guest_cubit/guest_serch_cubit.dart';
import '../../cubits/watch_list_cubit/watch_list_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => HomeCubit(),
              ),
              BlocProvider(
                create: (context) => NowPlayingCubit(),
              ),
              BlocProvider(
                create: (context) => UpcomingCubit(),
              ),
              BlocProvider(
                create: (context) => TopRatedCubit(),
              ),
              BlocProvider(
                create: (context) =>
                GuestSessionCubit()..createGuestSession(),
              ),
              BlocProvider(
                create: (context) => WatchListCubit(),
              ),
              BlocProvider(
                create: (context) => PopularCubit()..getPopularMovies(),
              ),
            ],
            child: const NavScreen(),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF242A32),
      body: Center(
        child: Image.asset('assets/splash.png'),
      ),
    );
  }
}