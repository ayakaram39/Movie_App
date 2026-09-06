import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_nti_aug/models/carousal_movies_model.dart';
import 'package:movie_nti_aug/models/popular_model.dart';
import 'package:movie_nti_aug/cubits/review_cubits/reviews_cubit.dart';
import 'package:movie_nti_aug/cubits/cast_cubits/cast_cubit.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Object movie;

  const MovieDetailsScreen({
    super.key,
    required this.movie,
  });

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  MovieModel get movie {
    if (widget.movie is MovieModel) {
      return widget.movie as MovieModel;
    }

    if (widget.movie is PopularMovieModel) {
      final popularMovie = widget.movie as PopularMovieModel;

      return MovieModel(
        adult: popularMovie.adult,
        backdropPath: popularMovie.backdropPath,
        genreIds: popularMovie.genreIds,
        id: popularMovie.id,
        title: popularMovie.title,
        originalLanguage: popularMovie.originalLanguage,
        originalTitle: popularMovie.originalTitle,
        overview: popularMovie.overview,
        popularity: popularMovie.popularity,
        posterPath: popularMovie.posterPath,
        releaseDate: popularMovie.releaseDate,
        softcore: false,
        video: popularMovie.video,
        voteAverage: popularMovie.voteAverage,
        voteCount: popularMovie.voteCount,
      );
    }

    throw Exception('Unsupported movie type');
  }

  String get title => movie.title;

  String get backdropPath => movie.backdropPath ?? '';

  String get posterPath => movie.posterPath ?? '';

  String get overview =>
      movie.overview.isNotEmpty
          ? movie.overview
          : 'No description available.';

  String get releaseDate =>
      movie.releaseDate.isNotEmpty ? movie.releaseDate : 'Unknown';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xff20252B),
        body: SafeArea(
          child: Column(
            children: [
              _buildMovieHeader(),
              _buildTabs(),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildAboutMovie(),
                    _buildReviews(),
                    _buildCast(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMovieHeader() {
    final width = MediaQuery.of(context).size.width;

    final posterWidth = width < 360 ? 75.0 : 85.0;
    final posterHeight = width < 360 ? 105.0 : 120.0;

    return SizedBox(
      height: 310,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            width: double.infinity,
            height: 250,
            child: Stack(
              children: [
                if (backdropPath.isNotEmpty)
                  Image.network(
                    'https://image.tmdb.org/t/p/w780$backdropPath',
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xff30363D),
                      );
                    },
                  )
                else
                  Container(
                    color: const Color(0xff30363D),
                  ),
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.15),
                        const Color(0xff20252B).withOpacity(0.35),
                        const Color(0xff20252B),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 15,
                  left: 15,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.55),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 15,
                  right: 15,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.bookmark_border,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            bottom: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: posterPath.isNotEmpty
                  ? Image.network(
                'https://image.tmdb.org/t/p/w342$posterPath',
                width: posterWidth,
                height: posterHeight,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _moviePlaceholder(
                    posterWidth,
                    posterHeight,
                  );
                },
              )
                  : _moviePlaceholder(
                posterWidth,
                posterHeight,
              ),
            ),
          ),
          Positioned(
            left: width < 360 ? 100 : 115,
            right: 16,
            bottom: 25,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: width < 360 ? 18 : 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 5,
                  children: [
                    _buildInfoItem(
                      Icons.star,
                      const Color(0xffffb800),
                      movie.voteAverage.toStringAsFixed(1),
                    ),
                    _buildInfoItem(
                      Icons.calendar_today_outlined,
                      Colors.grey,
                      releaseDate,
                    ),
                    _buildInfoItem(
                      Icons.movie_outlined,
                      Colors.grey,
                      'Movie',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
      IconData icon,
      Color iconColor,
      String text,
      ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 17,
        ),
        const SizedBox(width: 3),
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: iconColor == const Color(0xffffb800)
                ? Colors.white
                : Colors.grey,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _moviePlaceholder(double width, double height) {
    return Container(
      width: width,
      height: height,
      color: const Color(0xff30363D),
      child: const Icon(
        Icons.movie,
        color: Colors.grey,
        size: 35,
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      height: 55,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: const TabBar(
        dividerColor: Colors.transparent,
        indicatorColor: Color(0xff00A8E8),
        indicatorWeight: 2,
        labelColor: Colors.white,
        unselectedLabelColor: Color(0xff858A90),
        labelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
        tabs: [
          Tab(text: 'About Movie'),
          Tab(text: 'Reviews'),
          Tab(text: 'Cast'),
        ],
      ),
    );
  }

  Widget _buildAboutMovie() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About Movie',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            overview,
            style: const TextStyle(
              color: Color(0xff9A9EA3),
              fontSize: 18,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviews() {
    return BlocBuilder<ReviewsCubit, ReviewsState>(
      builder: (context, state) {
        if (state is ReviewsLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xff00A8E8),
            ),
          );
        }

        if (state is ReviewsFailure) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                state.message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                ),
              ),
            ),
          );
        }

        if (state is ReviewsSuccess) {
          if (state.reviews.isEmpty) {
            return const Center(
              child: Text(
                'No reviews available.',
                style: TextStyle(
                  color: Color(0xff858A90),
                  fontSize: 18,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
            itemCount: state.reviews.length,
            itemBuilder: (context, index) {
              final review = state.reviews[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _buildReview(
                  name: review.author,
                  content: review.content,
                  rating: review.authorDetails.rating,
                  avatarPath: review.authorDetails.avatarPath,
                ),
              );
            },
          );
        }

        return const Center(
          child: Text(
            'No reviews available.',
            style: TextStyle(
              color: Color(0xff858A90),
              fontSize: 18,
            ),
          ),
        );
      },
    );
  }

  Widget _buildReview({
    required String name,
    required String content,
    required double? rating,
    required String? avatarPath,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: const BoxDecoration(
            color: Color(0xff754D78),
            shape: BoxShape.circle,
          ),
          child: avatarPath != null && avatarPath.isNotEmpty
              ? ClipOval(
            child: Image.network(
              'https://image.tmdb.org/t/p/w200$avatarPath',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 24,
                );
              },
            ),
          )
              : const Icon(
            Icons.person,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                content,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xff9A9EA3),
                  fontSize: 18,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 5),
              if (rating != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star,
                      color: Color(0xffffb800),
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      rating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Color(0xff00A8E8),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCast() {
    return BlocBuilder<CastCubit, CastState>(
      builder: (context, state) {
        if (state is CastLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xff00A8E8),
            ),
          );
        }

        if (state is CastFailure) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                state.message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 15,
                ),
              ),
            ),
          );
        }

        if (state is CastSuccess) {
          if (state.cast.isEmpty) {
            return const Center(
              child: Text(
                'No cast available.',
                style: TextStyle(
                  color: Color(0xff858A90),
                  fontSize: 15,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
            itemCount: state.cast.length,
            itemBuilder: (context, index) {
              final cast = state.cast[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildCastMember(
                  cast.name,
                  cast.character,
                  cast.profilePath,
                ),
              );
            },
          );
        }

        return const Center(
          child: Text(
            'No cast available.',
            style: TextStyle(
              color: Color(0xff858A90),
              fontSize: 18,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCastMember(
      String name,
      String character,
      String? profilePath,
      ) {
    return SizedBox(
      height: 70,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xff3A4047),
            ),
            child: profilePath != null && profilePath.isNotEmpty
                ? ClipOval(
              child: Image.network(
                'https://image.tmdb.org/t/p/w200$profilePath',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.person,
                    color: Colors.grey,
                    size: 28,
                  );
                },
              ),
            )
                : const Icon(
              Icons.person,
              color: Colors.grey,
              size: 28,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  character,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xff858A90),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}