class TripModel {
  TripModel({
    this.requestId,
    this.truckNumber,
    this.tripStatus,
    this.dateTime,
    this.sapTruckNumber,
    this.firebaseToken,
    this.lat,
    this.long,
    this.driverId,
    this.shipmentId,
  });

  int requestId;
  String shipmentId;
  String truckNumber;
  String tripStatus;
  String dateTime;
  String sapTruckNumber;
  String firebaseToken;
  String lat;
  String long;
  String driverId;

  TripModel copyWith({
    int requestId,
    String shipmentId,
    String truckNumber,
    String tripStatus,
    String dateTime,
    String sapTruckNumber,
    String firebaseToken,
    String lat,
    String long,
    String driverId,
  }) =>
      TripModel(
        requestId: requestId ?? this.requestId,
        shipmentId: shipmentId ?? this.shipmentId,
        truckNumber: truckNumber ?? this.truckNumber,
        tripStatus: tripStatus ?? this.tripStatus,
        dateTime: dateTime ?? this.dateTime,
        sapTruckNumber: sapTruckNumber ?? this.sapTruckNumber,
        firebaseToken: firebaseToken ?? this.firebaseToken,
        lat: lat ?? this.lat,
        long: long ?? this.long,
        driverId: driverId ?? this.driverId,
      );

  factory TripModel.fromJson(Map<String, dynamic> json) => TripModel(
    requestId: json["requestId"] == null ? null : json["requestId"],
    shipmentId: json["shipmentId"] == null ? null : json["shipmentId"],
    truckNumber: json["truckNumber"] == null ? null : json["truckNumber"],
    tripStatus: json["tripStatus"] == null ? null : json["tripStatus"],
    dateTime: json["dateTime"] == null ? null : json["dateTime"],
    sapTruckNumber: json["sapTruckNumber"] == null ? null : json["sapTruckNumber"],
    firebaseToken: json["firebaseToken"] == null ? null : json["firebaseToken"],
    lat: json["lat"] == null ? null : json["lat"],
    long: json["long"] == null ? null : json["long"],
    driverId: json["driverId"] == null ? null : json["driverId"],
  );

  Map<String, dynamic> toJson() => {
    "requestId": requestId == null ? null : requestId,
    "shipmentId": shipmentId == null ? null : shipmentId,
    "truckNumber": truckNumber == null ? null : truckNumber,
    "tripStatus": tripStatus == null ? null : tripStatus,
    "dateTime": dateTime == null ? null : dateTime,
    "sapTruckNumber": sapTruckNumber == null ? null : sapTruckNumber,
    "firebaseToken": firebaseToken == null ? null : firebaseToken,
    "lat": lat == null ? null : lat,
    "long": long == null ? null : long,
    "driverId": driverId == null ? null : driverId,
  };

}