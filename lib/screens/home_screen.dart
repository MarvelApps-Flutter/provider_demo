import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:provider_demo/provider/movie_provider.dart';
import '../constants/app_constants.dart';
import '../model/movie_model.dart';
import '../utils/text_styles.dart';
import 'movie_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<MovieProvider>(context, listen: false).getMoviesData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(AppConstants.providerModuleString.toUpperCase(),
            style: AppTextStyles.mediumGreyLargeTextStyle),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<MovieProvider>(builder: (context, value, child) {
      if (value.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          value.movieResult.isNotEmpty
              ? buildCarousel(value.movieResult)
              : Container(),
          const SizedBox(height: 10),
          value.movieResult.isNotEmpty
              ? buildNewPlaying(value.movieResult)
              : Container(),
        ],
      );
    });
  }

  Widget buildStarRating() {
    return SizedBox(
      height: 9,
      child: ListView.builder(
          itemCount: 5,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return const Icon(
              Icons.star,
              color: Colors.red,
              size: 14,
            );
          }),
    );
  }

  Widget buildCarousel(List<Result> viewModel) {
    return CarouselSlider.builder(
      itemCount: viewModel.length,
      itemBuilder: (BuildContext context, int index, int realIdx) {
        Result movie = viewModel[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    MovieDetailScreen(movieId: movie.id),
              ),
            );
          },
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: <Widget>[
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                child: CachedNetworkImage(
                  imageUrl:
                      '${AppConstants.originalImageBaseUrlString}${movie.backdropPath}',
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image:
                            AssetImage(AppConstants.notFoundImageAssetString),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 15,
                  left: 15,
                ),
                child: Text(
                  movie.title!.toUpperCase(),
                  style: AppTextStyles.mediumWhiteLargeTextStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
      options: CarouselOptions(
        enableInfiniteScroll: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        pauseAutoPlayOnTouch: true,
        viewportFraction: 0.8,
        enlargeCenterPage: true,
      ),
    );
  }

  Widget buildNewPlaying(List<Result> viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(AppConstants.newPlayingString.toUpperCase(),
              style: AppTextStyles.mediumGreyLargeTextStyle),
          const SizedBox(height: 12),
          Column(
            children: <Widget>[
              SizedBox(
                height: 300,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: viewModel.length,
                  separatorBuilder: (context, index) => const VerticalDivider(
                    color: Colors.transparent,
                    width: 5,
                  ),
                  itemBuilder: (context, index) {
                    Result result = viewModel[index];
                    return buildNewPlayingListItem(result);
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildNewPlayingListItem(result) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MovieDetailScreen(movieId: result.id),
                  ),
                );
              },
              child: ClipRRect(
                child: CachedNetworkImage(
                  imageUrl:
                      '${AppConstants.originalImageBaseUrlString}${result.backdropPath}',
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      width: 180,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  errorWidget: (context, url, error) => Container(
                    width: 180,
                    height: 250,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image:
                            AssetImage(AppConstants.notFoundImageAssetString),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 180,
              child: Text(
                result.title!.toUpperCase(),
                style: AppTextStyles.regularForSmallGreyTextStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            buildStarRating()
          ],
        )
      ],
    );
  }
}
