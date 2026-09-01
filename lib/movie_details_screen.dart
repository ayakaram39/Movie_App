import 'package:flutter/material.dart';

class MovieDetailsScreen extends StatefulWidget {
  final dynamic movie;

  const MovieDetailsScreen({
    super.key,
    required this.movie,
  });

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  late dynamic movie;

  @override
  void initState() {
    super.initState();
    movie = widget.movie;
  }

  String get title {
    return movie.title ?? 'Unknown Movie';
  }

  String get backdropPath {
    return movie.backdropPath ?? '';
  }

  String get posterPath {
    return movie.posterPath ?? '';
  }

  String get overview {
    return movie.overview ?? 'No description available.';
  }

  String get releaseDate {
    return movie.releaseDate ?? 'Unknown';
  }

  double get voteAverage {
    final value = movie.voteAverage;

    if (value == null) {
      return 0.0;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString()) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xff20252B),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildMovieHeader(context),
                      _buildMovieInfo(),
                      _buildTabs(),
                      _buildTabContent(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMovieHeader(BuildContext context) {
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
                    onTap: () {
                      Navigator.pop(context);
                    },
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
                        size: 15,
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
                      size: 19,
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
                width: 85,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 85,
                    height: 120,
                    color: const Color(0xff30363D),
                    child: const Icon(
                      Icons.movie,
                      color: Colors.grey,
                      size: 30,
                    ),
                  );
                },
              )
                  : Container(
                width: 85,
                height: 120,
                color: const Color(0xff30363D),
                child: const Icon(
                  Icons.movie,
                  color: Colors.grey,
                  size: 30,
                ),
              ),
            ),
          ),
          Positioned(
            left: 115,
            right: 16,
            bottom: 25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Color(0xffffb800),
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      voteAverage.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                      size: 10,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      releaseDate,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 8,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.movie_outlined,
                      color: Colors.grey,
                      size: 11,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Movie',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 8,
                      ),
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

  Widget _buildMovieInfo() {
    return const SizedBox.shrink();
  }

  Widget _buildTabs() {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xff62676D),
            width: 0.5,
          ),
        ),
      ),
      child: const TabBar(
        indicatorColor: Color(0xff00A8E8),
        indicatorWeight: 2,
        labelColor: Colors.white,
        unselectedLabelColor: Color(0xff858A90),
        labelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        tabs: [
          Tab(
            text: 'About Movie',
          ),
          Tab(
            text: 'Reviews',
          ),
          Tab(
            text: 'Cast',
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return SizedBox(
      height: 360,
      child: TabBarView(
        children: [
          _buildAboutMovie(),
          _buildReviews(),
          _buildCast(),
        ],
      ),
    );
  }

  Widget _buildAboutMovie() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About Movie',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            overview,
            style: const TextStyle(
              color: Color(0xff9A9EA3),
              fontSize: 9,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            'Reviews',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'No reviews available.',
            style: TextStyle(
              color: Color(0xff858A90),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            'Cast',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Cast information will be added here.',
            style: TextStyle(
              color: Color(0xff858A90),
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviews() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reviews',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
          _buildReview(
            name: 'Iqbal Shafiq Rozaan',
            rating: '6.3',
          ),
          const SizedBox(height: 18),
          _buildReview(
            name: 'Iqbal Shafiq Rozaan',
            rating: '6.3',
          ),
        ],
      ),
    );
  }

  Widget _buildReview({
    required String name,
    required String rating,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0xff754D78),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person,
            color: Colors.white,
            size: 17,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                overview,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xff9A9EA3),
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                rating,
                style: const TextStyle(
                  color: Color(0xff00A8E8),
                  fontSize: 8,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCast() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cast',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 20,
            crossAxisSpacing: 25,
            childAspectRatio: 2.3,
            children: [
              _buildCastMember(
                'Tom Holland',
                Icons.person,
              ),
              _buildCastMember(
                'Zendaya',
                Icons.person,
              ),
              _buildCastMember(
                'Benedict Cumberbatch',
                Icons.person,
              ),
              _buildCastMember(
                'Brad Pitt',
                Icons.person,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCastMember(
      String name,
      IconData icon,
      ) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xff3A4047),
          ),
          child: Icon(
            icon,
            color: Colors.grey,
            size: 25,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}