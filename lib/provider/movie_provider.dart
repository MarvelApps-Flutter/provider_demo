import 'package:flutter/material.dart';
import 'package:provider_demo/service/movie_service.dart';
import '../model/movie_detail_model.dart';
import '../model/movie_model.dart';

class MovieProvider extends ChangeNotifier
{
   final service = MovieService();
   bool isLoading = false;
   List<Result> movieResultList = [];
   List<Result> get movieResult => movieResultList;

   MovieDetailModel? movieDetailModel;
   MovieDetailModel get movieDetail => movieDetailModel!;

   Future getMoviesData() async
   {
      isLoading = true;
      notifyListeners();
      final response = await service.getMovieData();
      movieResultList = response;
      isLoading = false;
      notifyListeners();
   }

   Future getMovieDetail(int movieId) async
   {
     isLoading = true;
      notifyListeners();
      final response = await service.getMovieDetail(movieId);
      movieDetailModel = response;
      isLoading = false;
      notifyListeners();
   }

}