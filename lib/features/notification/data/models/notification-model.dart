class NotificationModel {
  NotificationModel({
    this.requestId,
    this.shipmentId,
    this.customerId,
    this.customerName,
    this.srcName,
    this.srcLat,
    this.srcLong,
    this.srcAddress,
    this.srcContactName,
    this.srcContactNumber,
    this.destName,
    this.destLat,
    this.destLong,
    this.destAddress,
    this.destContactName,
    this.destContactNumber,
    this.pickupDate,
    this.deliverDate,
    this.accessories,
    this.package,
    this.capacity,
    this.unitType,
    this.comment,
    this.truckNumber,
    this.sapTruckNumber,
    this.firebaseToken,
    this.tripStatus,
    this.tripType,
    this.view,
  });

  int requestId;
  String shipmentId;
  String customerId;
  String customerName;
  String srcName;
  String srcLat;
  String srcLong;
  String srcAddress;
  String srcContactName;
  String srcContactNumber;
  String destName;
  String destLat;
  String destLong;
  String destAddress;
  String destContactName;
  String destContactNumber;
  String pickupDate;
  String deliverDate;
  String accessories;
  String package;
  String capacity;
  String comment;
  String unitType;
  String truckNumber;
  String sapTruckNumber;
  String firebaseToken;
  String tripStatus;
  String tripType;
  bool view;

  NotificationModel copyWith({
    int requestId,
    String shipmentId,
    String customerId,
    String customerName,
    String srcName,
    String srcLat,
    String srcLong,
    String srcAddress,
    String srcContactName,
    String srcContactNumber,
    String destName,
    String destLat,
    String destLong,
    String destAddress,
    String destContactName,
    String destContactNumber,
    String pickupDate,
    String deliverDate,
    String accessories,
    String package,
    String capacity,
    String comment,
    String unitType,
    String truckNumber,
    String sapTruckNumber,
    String firebaseToken,
    String tripStatus,
    String tripType,
    bool view,
  }) =>
      NotificationModel(
        requestId: requestId ?? this.requestId,
        shipmentId: shipmentId ?? this.shipmentId,
        customerId: customerId ?? this.customerId,
        customerName: customerName ?? this.customerName,
        srcName: srcName ?? this.srcName,
        srcLat: srcLat ?? this.srcLat,
        srcLong: srcLong ?? this.srcLong,
        srcAddress: srcAddress ?? this.srcAddress,
        srcContactName: srcContactName ?? this.srcContactName,
        srcContactNumber: srcContactNumber ?? this.srcContactNumber,
        destName: destName ?? this.destName,
        destLat: destLat ?? this.destLat,
        destLong: destLong ?? this.destLong,
        destAddress: destAddress ?? this.destAddress,
        destContactName: destContactName ?? this.destContactName,
        destContactNumber: destContactNumber ?? this.destContactNumber,
        pickupDate: pickupDate ?? this.pickupDate,
        deliverDate: deliverDate ?? this.deliverDate,
        accessories: accessories ?? this.accessories,
        package: package ?? this.package,
        capacity: capacity ?? this.capacity,
        comment: comment ?? this.comment,
        unitType: unitType ?? this.unitType,
        truckNumber: truckNumber ?? this.truckNumber,
        sapTruckNumber: sapTruckNumber ?? this.sapTruckNumber,
        firebaseToken: firebaseToken ?? this.firebaseToken,
        tripStatus: tripStatus ?? this.tripStatus,
        tripType: tripType?? this.tripType,
        view: view?? this.view,

      );

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    requestId: json["requestID"] == null ? null : json["requestID"],
    shipmentId: json["shipmentID"] == null ? null : json ["shipmentID"],
    customerId: json["customerID"] == null ? null : json["customerID"],
    customerName: json["customerName"] == null ? null : json["customerName"],
    srcName: json["srcName"] == null ? null : json["srcName"],
    srcLat: json["srcLat"] == null ? null : json["srcLat"],
    srcLong: json["srcLong"] == null ? null : json["srcLong"],
    srcAddress: json["srcAddress"] == null ? null : json["srcAddress"],
    srcContactName: json["srcContactName"] == null ? null : json["srcContactName"],
    srcContactNumber: json["srcContactNumber"] == null ? null : json["srcContactNumber"],
    destName: json["destName"] == null ? null : json["destName"],
    destLat: json["destLat"] == null ? null : json["destLat"],
    destLong: json["destLong"] == null ? null : json["destLong"],
    destAddress: json["destAddress"] == null ? null : json["destAddress"],
    destContactName: json["destContactName"] == null ? null : json["destContactName"],
    destContactNumber: json["destContactNumber"] == null ? null : json["destContactNumber"],
    pickupDate: json["pickupDate"] == null ? null : json["pickupDate"],
    deliverDate: json["deliverDate"] == null ? null : json["deliverDate"],
    accessories: json["accessories"] == null ? null : json["accessories"],
    package: json["package"] == null ? null : json["package"],
    capacity: json["capacity"] == null ? null : json["capacity"],
    comment: json["comment"] == null ? null : json["comment"],
    unitType: json["unitType"] == null ? null : json["unitType"],
    truckNumber: json["truckNumber"] == null ? null : json["truckNumber"],
    sapTruckNumber: json["sapTruckNumber"] == null ? null : json["sapTruckNumber"],
    firebaseToken: json["firebaseToken"] == null ? null : json["firebaseToken"],
    tripStatus: json["tripStatus"] == null ? null : json["tripStatus"],
    tripType: json["tripType"] == null ? null : json["tripType"],
    view: json["view"] == null ? true : json["view"],

  );

  Map<String, dynamic> toJson() => {
    "requestID": requestId == null ? null : requestId,
    "shipmentID": shipmentId == null ? null : shipmentId,
    "customerID": customerId == null ? null : customerId,
    "customerName": customerName == null ? null : customerName,
    "srcName": srcName == null ? null : srcName,
    "srcLat": srcLat == null ? null : srcLat,
    "srcLong": srcLong == null ? null : srcLong,
    "srcAddress": srcAddress == null ? null : srcAddress,
    "srcContactName": srcContactName == null ? null : srcContactName,
    "srcContactNumber": srcContactNumber == null ? null : srcContactNumber,
    "destName": destName == null ? null : destName,
    "destLat": destLat == null ? null : destLat,
    "destLong": destLong == null ? null : destLong,
    "destAddress": destAddress == null ? null : destAddress,
    "destContactName": destContactName == null ? null : destContactName,
    "destContactNumber": destContactNumber == null ? null : destContactNumber,
    "pickupDate": pickupDate == null ? null : pickupDate,
    "deliverDate": deliverDate == null ? null : deliverDate,
    "accessories": accessories == null ? null : accessories,
    "package": package == null ? null : package,
    "capacity": capacity == null ? null : capacity,
    "comment": comment == null ? null : comment,
    "unitType": unitType == null ? null : unitType,
    "truckNumber": truckNumber == null ? null : truckNumber,
    "sapTruckNumber": sapTruckNumber == null ? null : sapTruckNumber,
    "firebaseToken": firebaseToken == null ? null : firebaseToken,
    "tripStatus": tripStatus == null ? null : tripStatus,
    "tripType": tripType == null ? null : tripType,
    "view": view == null ? true : view,
  };
}