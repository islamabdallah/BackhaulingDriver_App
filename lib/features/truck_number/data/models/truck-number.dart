class TruckNumberModel {
   String truckNumber;
   String sapTruckNumber;
   String firebaseToken;

  TruckNumberModel(
      {
        this.truckNumber,
        this.sapTruckNumber,
        this.firebaseToken,
      });

  factory TruckNumberModel.fromJson(Map<String, dynamic> json) {
    return TruckNumberModel(
      truckNumber: json['truckNumber'],
      sapTruckNumber: json['sapTruckNumber'],
      firebaseToken: json['firebaseToken'],
    );
  }
  Map<String, dynamic> toJson() => {
        "truckNumber": truckNumber,
        "sapTruckNumber": sapTruckNumber,
        "firebaseToken": firebaseToken,
      };
  @override
  String toString() {
    return sapTruckNumber;
  }

//  Map<String,dynamic> toMap() {
//    var map = new Map<String, dynamic>();
//    map["TruckNumber"] = TruckNumber;
//    map["SapTruckNumber"] = SapTruckNumber;
//    map["FirebaseToken"] = FirebaseToken;
//    // Add all other fields
//    return map;
//  }
}
