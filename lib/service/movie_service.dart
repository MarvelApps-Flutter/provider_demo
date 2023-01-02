import 'dart:convert';
import '../constants/app_constants.dart';
import '../model/cast_model.dart';
import '../model/genre_model.dart';
import '../model/movie_detail_model.dart';
import '../model/movie_image_model.dart';
import '../model/movie_model.dart';
import 'package:http/http.dart' as http;
import '../model/person_model.dart';

class MovieService
{
  Future<List<Result>> getMovieData() async {
    try{
      final url = Uri.parse('${AppConstants.baseUrl}/movie/now_playing?api_key=${AppConstants.apiKey}');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var movie = movieModelFromJson(response.body);
        List<Result> movieList = movie.results!.toList();
        return movieList;
      } else {
        throw Exception('Couldn\'t fetch the data');
      }
    }
    catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

  Future<List<Result>> getMovieByGenre(int movieId) async {
    try {
      final url = Uri.parse('${AppConstants.baseUrl}/discover/movie?with_genres=$movieId&api_key=${AppConstants.apiKey}');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var movie = movieModelFromJson(response.body);
        List<Result> movieList = movie.results!.toList();
        return movieList;
      }
      else
        {
          throw Exception('Couldn\'t fetch the data');
        }
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

   Future<List<Genre>> getGenreList() async {
    try {
      final url = Uri.parse('${AppConstants.baseUrl}/genre/movie/list?api_key=${AppConstants.apiKey}');
      final response = await http.get(url);
      if (response.statusCode == 200) {

        var genre = genreModelFromJson(response.body);
        List<Genre> genreList = genre.genres!.toList();
        return genreList;
      }
      else
      {
        throw Exception('Couldn\'t fetch the data');

      }
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

   Future<List<Results>> getTrendingPerson() async {
    try {
      final url = Uri.parse('${AppConstants.baseUrl}/trending/person/week?api_key=${AppConstants.apiKey}');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var person = personModelFromJson(response.body);
        List<Results> personList = person.results!.toList();
        return personList;
      }
      else
      {
        throw Exception('Couldn\'t fetch the data');
      }
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

   Future<MovieDetailModel> getMovieDetail(int movieId) async {
    try {
      final url = Uri.parse('${AppConstants.baseUrl}/movie/$movieId?api_key=${AppConstants.apiKey}');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var movieDetailData = movieDetailModelFromJson(response.body);
        movieDetailData.trailerId = await getYoutubeId(movieId);
        movieDetailData.movieImage = await getMovieImage(movieId);
        movieDetailData.castList = await getCastList(movieId);
        return movieDetailData;
      }
      else
      {
        throw Exception('Couldn\'t fetch the data');
      }
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

   Future<String> getYoutubeId(int id) async {
    try {
      final url = Uri.parse('${AppConstants.baseUrl}/movie/$id/videos?api_key=${AppConstants.apiKey}');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var youtubeId = jsonDecode(response.body);
        return youtubeId['results'][0]['key'];
      }
      else
      {
        throw Exception('Couldn\'t fetch the data');
      }
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

   Future<MovieImageModel> getMovieImage(int movieId) async {
    try {
      final url = Uri.parse('${AppConstants.baseUrl}/movie/$movieId/images?api_key=${AppConstants.apiKey}');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var movieImageData = movieImageModelFromJson(response.body);
        return movieImageData;
      }
      else
      {
        throw Exception('Couldn\'t fetch the data');
      }
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

   Future<List<Cast>> getCastList(int movieId) async {
    try {
      final url =
      Uri.parse('${AppConstants.baseUrl}/movie/$movieId/credits?api_key=${AppConstants.apiKey}');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var cast = castModelFromJson(response.body);
        List<Cast> castList = cast.cast!.toList();
        return castList;
      }
      else
      {
        throw Exception('Couldn\'t fetch the data');
      }
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }
}