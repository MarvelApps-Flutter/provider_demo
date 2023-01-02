import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:provider_demo/model/cast_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_constants.dart';
import '../model/movie_detail_model.dart';
import '../model/movie_image_model.dart';
import '../provider/movie_provider.dart';
import '../utils/text_styles.dart';

class MovieDetailScreen extends StatefulWidget {
  final int? movieId;

  const MovieDetailScreen({Key? key, this.movieId}) : super(key: key);
  @override
  MovieDetailScreenState createState() => MovieDetailScreenState();
}

class MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.movieId != null) {
        Provider.of<MovieProvider>(context, listen: false)
            .getMovieDetail(widget.movieId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: buildBody(context),
      ),
      onWillPop: () async => true,
    );
  }

  Widget buildBody(BuildContext context) {
    return Consumer<MovieProvider>(builder: (context, value, child) {
      MovieDetailModel? movieDetailData = value.movieDetailModel;
      if (value.isLoading) {
        return const Center(
            child: CircularProgressIndicator(
          color: Colors.black,
        ));
      } else {
        if (movieDetailData != null) {
          List<Backdrop>? backdropList = movieDetailData.movieImage!.backdrops;
          DateFormat dateFormat = DateFormat(AppConstants.dateFormatString);
          String date = dateFormat.format(movieDetailData.releaseDate!);
          List<Cast>? castList = movieDetailData.castList;
          return buildData(movieDetailData, backdropList, castList, date);
        } else {
          return Container();
        }
      }
    });
  }

  Widget buildData(movieDetailData, backdropList, castList, date) {
    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          buildAppBar(movieDetailData),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              Container(
                padding: const EdgeInsets.only(top: 120),
                child: GestureDetector(
                  onTap: () async {
                    final youtubeUrl =
                        '${AppConstants.youtubeUrlString}${movieDetailData.trailerId}';
                    if (await canLaunchUrl(Uri.parse(youtubeUrl))) {
                      await launchUrl(Uri.parse(youtubeUrl));
                    }
                  },
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        const Icon(
                          Icons.play_circle_outline,
                          color: Colors.red,
                          size: 65,
                        ),
                        Text(
                          movieDetailData.title!.toUpperCase(),
                          style: AppTextStyles.mediumWhiteLargeTextStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 90),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    buildOverviewWithTitleAndDescription(movieDetailData),
                    const SizedBox(height: 10),
                    buildReleaseRunTimeAndBudget(date, movieDetailData),
                    const SizedBox(height: 10),
                    Text(
                      AppConstants.screenShotsString.toUpperCase(),
                      style: AppTextStyles.mediumBlackkSmallTextStyle,
                    ),
                    screenShotList(backdropList),
                    const SizedBox(height: 10),
                    Text(
                      AppConstants.castsString.toUpperCase(),
                      style: AppTextStyles.mediumBlackkSmallTextStyle,
                    ),
                    castsList(castList)
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildAppBar(movieDetailData) {
    return ClipPath(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        child: CachedNetworkImage(
          imageUrl:
              '${AppConstants.originalImageBaseUrlString}${movieDetailData.backdropPath}',
          height: MediaQuery.of(context).size.height / 2,
          width: double.infinity,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppConstants.notFoundImageAssetString),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildOverviewWithTitleAndDescription(movieDetailData) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                AppConstants.overviewString.toUpperCase(),
                style: AppTextStyles.mediumBlackkSmallTextStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 35,
          child: Text(
            movieDetailData.overview!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.lightGreyBigTextStyle,
          ),
        ),
      ],
    );
  }

  Widget buildReleaseRunTimeAndBudget(date, movieDetailData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              AppConstants.releaseDateString.toUpperCase(),
              style: AppTextStyles.mediumBlackkSmallTextStyle,
            ),
            Text(
              date.toString(),
              style: AppTextStyles.regularForSmallGreyTextStyle,
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              AppConstants.runTimeString.toUpperCase(),
              style: AppTextStyles.mediumBlackkSmallTextStyle,
            ),
            Text(
              movieDetailData.runtime!.toString(),
              style: AppTextStyles.regularForSmallGreyTextStyle,
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              AppConstants.budgetString.toUpperCase(),
              style: AppTextStyles.mediumBlackkSmallTextStyle,
            ),
            Text(
              movieDetailData.budget!.toString(),
              style: AppTextStyles.regularForSmallGreyTextStyle,
            ),
          ],
        ),
      ],
    );
  }

  Widget screenShotList(backdropList) {
    return SizedBox(
      height: 155,
      child: ListView.separated(
        separatorBuilder: (context, index) => const VerticalDivider(
          color: Colors.transparent,
          width: 5,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: backdropList!.length,
        itemBuilder: (context, index) {
          Backdrop image = backdropList[index];
          return Card(
            elevation: 3,
            borderOnForeground: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                placeholder: (context, url) => Center(
                  child: Platform.isAndroid
                      ? const CircularProgressIndicator()
                      : const CupertinoActivityIndicator(),
                ),
                imageUrl:
                    '${AppConstants.backdropAssetImageString}${image.filePath}',
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget castsList(castList) {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const VerticalDivider(
          color: Colors.transparent,
          width: 5,
        ),
        itemCount: castList!.length,
        itemBuilder: (context, index) {
          Cast cast = castList[index];
          return Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                elevation: 3,
                child: ClipRRect(
                  child: CachedNetworkImage(
                    imageUrl:
                        '${AppConstants.castsAssetImageString}${cast.profilePath}',
                    imageBuilder: (context, imageBuilder) {
                      return Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100)),
                          image: DecorationImage(
                            image: imageBuilder,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                    errorWidget: (context, url, error) => Container(
                      width: 80,
                      height: 80,
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
              Center(
                child: Text(cast.name!.toUpperCase(),
                    style: AppTextStyles.lightTextStyle),
              ),
              Center(
                child: Text(cast.character!.toUpperCase(),
                    style: AppTextStyles.lightTextStyle),
              ),
            ],
          );
        },
      ),
    );
  }
}
