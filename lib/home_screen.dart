import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubits/home_cubit/home_cubit.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var isshow = true;

  @override
  void initState(){
    return context.read<HomeCubit>().getCarouselMovies();
    return initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF242A32),
      appBar: AppBar(
        backgroundColor: const Color(0xFF242A32),
        elevation: 0,
        title: const Text(
          'What do you want to watch?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
                suffixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                filled: true,
                fillColor: const Color(0xFF343A40),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Colors.orange,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Colors.orange,
                    width: 2,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40,),

            // ElevatedButton(
            //   onPressed: () {
            //     isshow = !isshow;
            //     context.read<HomeCubit>().greet();
            //   },
            //   child: const Text('Get Started'),
            // ),
            //
            // const SizedBox(height: 40),
            //
            // if (isshow)
            //   const Text('🥳🥳'),

            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if(state is HomeCarouselMovieLoading){
                  return CircularProgressIndicator();

                }
                return SizedBox(
                  width: double.infinity,
                  height: 210,
                  child: CarouselSlider(
                    items: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          'https://www.impawards.com/2022/posters/batman.jpg',
                          width: 140,
                          height: 210,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                    options: CarouselOptions(
                      height: 210,
                      viewportFraction: 0.4,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 2),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}