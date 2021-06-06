// @dart=2.9
class TrucKDataModel {
  TrucKDataModel({
    this.requestId,
    this.truckNumber,
    this.sapTruckNumber,
    this.tripStatus,
    this.tripBreak,
    this.firebaseToken,
    this.driverId,
    this.shipmentId,
  });

  int requestId;
  String shipmentId;
  String truckNumber;
  String sapTruckNumber;
  String tripStatus;
  int tripBreak;
  String firebaseToken;
  String driverId;

  TrucKDataModel copyWith({
    int requestId,
    String shipmentId,
    String truckNumber,
    String sapTruckNumber,
    String tripStatus,
    int tripBreak,
    String firebaseToken,
    String driverId,
  }) =>
      TrucKDataModel(
        requestId: requestId ?? this.requestId,
        shipmentId: shipmentId ?? this.shipmentId,
        truckNumber: truckNumber ?? this.truckNumber,
        sapTruckNumber: sapTruckNumber ?? this.sapTruckNumber,
        tripStatus: tripStatus ?? this.tripStatus,
        tripBreak: tripBreak ?? this.tripBreak,
        firebaseToken: firebaseToken ?? this.firebaseToken,
        driverId: driverId ?? this.driverId,
      );

  factory TrucKDataModel.fromJson(Map<String, dynamic> json) => TrucKDataModel(
    requestId: json["requestId"] == null ? null : json["requestId"],
    shipmentId: json["shipmentId"] == null ? null : json["shipmentId"],
    truckNumber: json["truckNumber"] == null ? null : json["truckNumber"],
    sapTruckNumber: json["sapTruckNumber"] == null ? null : json["sapTruckNumber"],
    tripStatus: json["tripStatus"] == null ? null : json["tripStatus"],
    tripBreak: json["tripBreak"] == null ? null : json["tripBreak"],
    firebaseToken: json["firebaseToken"] == null ? null : json["firebaseToken"],
    driverId: json["driverId"] == null ? null : json["driverId"],
  );

  Map<String, dynamic> toJson() => {
    "requestId": requestId == null ? null : requestId,
    "shipmentId": shipmentId == null ? null : shipmentId,
    "truckNumber": truckNumber == null ? null : truckNumber,
    "sapTruckNumber": sapTruckNumber == null ? null : sapTruckNumber,
    "tripStatus": tripStatus == null ? null : tripStatus,
    "tripBreak": tripBreak == null ? null : tripBreak,
    "firebaseToken": firebaseToken == null ? null : firebaseToken,
    "driverId": driverId == null ? null : driverId,
  };

}