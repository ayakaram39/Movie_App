import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_nti_aug/cubits/search_cubits/search_cubit.dart';
import 'package:movie_nti_aug/cubits/search_cubits/search_state.dart';
import 'package:movie_nti_aug/models/search_model.dart';
import 'package:movie_nti_aug/view/widgets/search_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void clearSearch() {
    searchController.clear();
    context.read<SearchCubit>().searchMovies('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff20252B),
      appBar: AppBar(
        backgroundColor: const Color(0xff20252B),
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Search',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: const [
          Icon(
            Icons.info_outline_rounded,
            color: Colors.white,
            size: 24,
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 20,
        ),
        child: Column(
          children: [
            Container(
              height: 62,
              decoration: BoxDecoration(
                color: const Color(0xff3A3F47),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: searchController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
                cursorColor: Colors.white,
                onChanged: (value) {
                  setState(() {});
                  context.read<SearchCubit>().searchMovies(value);
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search',
                  hintStyle: const TextStyle(
                    color: Color(0xff858A90),
                    fontSize: 20,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xff12A8E8),
                    size: 34,
                  ),
                  suffixIcon: searchController.text.isNotEmpty
                      ? GestureDetector(
                    onTap: clearSearch,
                    child: const Icon(
                      Icons.close,
                      color: Color(0xffA5A5A5),
                      size: 32,
                    ),
                  )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 18,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xff12A8E8),
                      ),
                    );
                  }

                  if (state is SearchFailure) {
                    return Center(
                      child: Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  if (state is SearchSuccess) {
                    final List<SearchModel> movies =
                        state.searchResponse.results;

                    if (movies.isEmpty) {
                      return const NoResultsWidget();
                    }

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        return SearchCard(
                          movie: movies[index],
                        );
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NoResultsWidget extends StatelessWidget {
  const NoResultsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xff20252B),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.search,
                  color: Color(0xffFF9800),
                  size: 50,
                ),
                Positioned(
                  right: 8,
                  bottom: 12,
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: const Color(0xff20252B),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.more_horiz,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'We Are Sorry, We Can',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),

          const Text(
            'Not Find The Movie :(',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'Find your movie by Type title,',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xff858A90),
              fontSize: 13,
            ),
          ),

          const Text(
            'categories, years, etc.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xff858A90),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}