// To parse this JSON data, do
//
//     final movieImageModel = movieImageModelFromJson(jsonString);

import 'dart:convert';

MovieImageModel movieImageModelFromJson(String str) => MovieImageModel.fromJson(json.decode(str));

String movieImageModelToJson(MovieImageModel data) => json.encode(data.toJson());

class MovieImageModel {
  MovieImageModel({
    this.backdrops,
    this.id,
    this.logos,
    this.posters,
  });

  List<Backdrop>? backdrops;
  int? id;
  List<Logo>? logos;
  List<Backdrop>? posters;

  factory MovieImageModel.fromJson(Map<String, dynamic> json) => MovieImageModel(
    backdrops: List<Backdrop>.from(json["backdrops"].map((x) => Backdrop.fromJson(x))),
    id: json["id"],
    logos: List<Logo>.from(json["logos"].map((x) => Logo.fromJson(x))),
    posters: List<Backdrop>.from(json["posters"].map((x) => Backdrop.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "backdrops": List<dynamic>.from(backdrops!.map((x) => x.toJson())),
    "id": id,
    "logos": List<dynamic>.from(logos!.map((x) => x.toJson())),
    "posters": List<dynamic>.from(posters!.map((x) => x.toJson())),
  };
}

class Backdrop {
  Backdrop({
    this.aspectRatio,
    this.height,
    this.iso6391,
    this.filePath,
    this.voteAverage,
    this.voteCount,
    this.width,
  });

  double? aspectRatio;
  int? height;
  String? iso6391;
  String? filePath;
  double? voteAverage;
  int? voteCount;
  int? width;

  factory Backdrop.fromJson(Map<String, dynamic> json) => Backdrop(
    aspectRatio: json["aspect_ratio"].toDouble(),
    height: json["height"],
    iso6391: json["iso_639_1"] == null ? null : json["iso_639_1"],
    filePath: json["file_path"],
    voteAverage: json["vote_average"].toDouble(),
    voteCount: json["vote_count"],
    width: json["width"],
  );

  Map<String, dynamic> toJson() => {
    "aspect_ratio": aspectRatio,
    "height": height,
    "iso_639_1": iso6391 == null ? null : iso6391,
    "file_path": filePath,
    "vote_average": voteAverage,
    "vote_count": voteCount,
    "width": width,
  };
}

class Logo {
  Logo({
    this.aspectRatio,
    this.height,
    this.iso6391,
    this.filePath,
    this.voteAverage,
    this.voteCount,
    this.width,
  });

  double? aspectRatio;
  int? height;
  String? iso6391;
  String? filePath;
  double? voteAverage;
  int? voteCount;
  int? width;

  factory Logo.fromJson(Map<String, dynamic> json) => Logo(
    aspectRatio: json["aspect_ratio"].toDouble(),
    height: json["height"],
    iso6391: json["iso_639_1"],
    filePath: json["file_path"],
    voteAverage: json["vote_average"].toDouble(),
    voteCount: json["vote_count"],
    width: json["width"],
  );

  Map<String, dynamic> toJson() => {
    "aspect_ratio": aspectRatio,
    "height": height,
    "iso_639_1": iso6391,
    "file_path": filePath,
    "vote_average": voteAverage,
    "vote_count": voteCount,
    "width": width,
  };
}
