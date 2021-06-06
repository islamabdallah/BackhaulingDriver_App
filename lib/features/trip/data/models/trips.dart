// @dart=2.9
import 'dart:convert';
import 'package:shhnatycemexdriver/features/trip_detail/data/models/trip.dart';

Trips tripsFromJson(String str) => Trips.fromJson(json.decode(str));

String tripsToJson(Trips data) => json.encode(data.toJson());

TripModel TripModelFromJson(String str) => TripModel.fromJson(json.decode(str));

String TripModelToJson(TripModel data) => json.encode(data.toJson());

class Trips {
  Trips({
    this.data,
  });

  List<TripModel> data;

  Trips copyWith({
    List<TripModel> data,
  }) =>
      Trips(
        data: data ?? this.data,
      );

  factory Trips.fromJson(Map<String, dynamic> json) => Trips(
    data: json["data"] == null ? null : List<TripModel>.from(json["data"].map((x) => TripModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}