// To parse this JSON data, do
//
//     final personModel = personModelFromJson(jsonString);

import 'dart:convert';

PersonModel personModelFromJson(String str) => PersonModel.fromJson(json.decode(str));

String personModelToJson(PersonModel data) => json.encode(data.toJson());

class PersonModel {
  PersonModel({
    this.page,
    this.results,
    this.totalPages,
    this.totalResults,
  });

  int? page;
  List<Results>? results;
  int? totalPages;
  int? totalResults;

  factory PersonModel.fromJson(Map<String, dynamic> json) => PersonModel(
    page: json["page"],
    results: List<Results>.from(json["results"].map((x) => Results.fromJson(x))),
    totalPages: json["total_pages"],
    totalResults: json["total_results"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "results": List<dynamic>.from(results!.map((x) => x.toJson())),
    "total_pages": totalPages,
    "total_results": totalResults,
  };
}

class Results {
  Results({
    this.knownFor,
    this.profilePath,
    this.knownForDepartment,
    this.gender,
    this.adult,
    this.id,
    this.name,
    this.popularity,
    this.mediaType,
  });

  List<KnownFor>? knownFor;
  String? profilePath;
  String? knownForDepartment;
  int? gender;
  bool? adult;
  int? id;
  String? name;
  dynamic popularity;
  String? mediaType;

  factory Results.fromJson(Map<String, dynamic> json) => Results(
    knownFor: List<KnownFor>.from(json["known_for"].map((x) => KnownFor.fromJson(x))),
    profilePath: json["profile_path"],
    knownForDepartment: json["known_for_department"],
    gender: json["gender"],
    adult: json["adult"],
    id: json["id"],
    name: json["name"],
    popularity: json["popularity"].toDouble(),
    mediaType: json["media_type"],
  );

  Map<String, dynamic> toJson() => {
    "known_for": List<dynamic>.from(knownFor!.map((x) => x.toJson())),
    "profile_path": profilePath,
    "known_for_department": knownForDepartment,
    "gender": gender,
    "adult": adult,
    "id": id,
    "name": name,
    "popularity": popularity,
    "media_type": mediaType,
  };
}

class KnownFor {
  KnownFor({
    this.popularity,
    this.overview,
    this.releaseDate,
    this.title,
    this.adult,
    this.backdropPath,
    this.mediaType,
    this.genreIds,
    this.voteCount,
    this.originalLanguage,
    this.originalTitle,
    this.posterPath,
    this.id,
    this.video,
    this.voteAverage,
  });

  dynamic popularity;
  String? overview;
  DateTime? releaseDate;
  String? title;
  bool? adult;
  String? backdropPath;
  String? mediaType;
  List<dynamic>? genreIds;
  dynamic voteCount;
  String? originalLanguage;
  String? originalTitle;
  String? posterPath;
  dynamic? id;
  bool? video;
  dynamic voteAverage;

  factory KnownFor.fromJson(Map<String, dynamic> json) => KnownFor(
    popularity: json["popularity"].toDouble(),
    overview: json["overview"],
    releaseDate: DateTime.parse(json["release_date"]),
    title: json["title"],
    adult: json["adult"],
    backdropPath: json["backdrop_path"],
    mediaType: json["media_type"],
    genreIds: List<dynamic>.from(json["genre_ids"].map((x) => x)),
    voteCount: json["vote_count"],
    originalLanguage: json["original_language"],
    originalTitle: json["original_title"],
    posterPath: json["poster_path"],
    id: json["id"],
    video: json["video"],
    voteAverage: json["vote_average"],
  );

  Map<String, dynamic> toJson() => {
    "popularity": popularity,
    "overview": overview,
    "release_date": "${releaseDate!.year.toString().padLeft(4, '0')}-${releaseDate!.month.toString().padLeft(2, '0')}-${releaseDate!.day.toString().padLeft(2, '0')}",
    "title": title,
    "adult": adult,
    "backdrop_path": backdropPath,
    "media_type": mediaType,
    "genre_ids": List<dynamic>.from(genreIds!.map((x) => x)),
    "vote_count": voteCount,
    "original_language": originalLanguage,
    "original_title": originalTitle,
    "poster_path": posterPath,
    "id": id,
    "video": video,
    "vote_average": voteAverage,
  };
}
