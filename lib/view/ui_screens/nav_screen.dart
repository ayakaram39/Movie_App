import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/guest_cubit/guest_serch_cubit.dart';
import '../../cubits/search_cubits/search_cubit.dart';
import '../../cubits/watch_list_cubit/watch_list_cubit.dart';

import 'home_screen.dart';
import 'search_screen.dart';
import 'watch_list_screen.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int index = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GuestSessionCubit>().createGuestSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchCubit>(
          create: (context) => SearchCubit(),
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xff242A32),
        body: IndexedStack(
          index: index,
          children: const [
            HomeScreen(),
            SearchScreen(fromNavigation: true),
            WatchListScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          onTap: (value) {
            setState(() {
              index = value;
            });

            if (value == 2) {
              context.read<WatchListCubit>().getWatchList();
            }
          },
          backgroundColor: const Color(0xff242A32),
          selectedItemColor: const Color(0xff0296E5),
          unselectedItemColor: const Color(0xff67686D),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_outline),
              activeIcon: Icon(Icons.bookmark),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}