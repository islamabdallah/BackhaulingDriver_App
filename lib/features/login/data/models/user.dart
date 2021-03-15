class UserModel {
  String UserName;
  String Password;
  String Barcode;

  UserModel({
    this.UserName,
    this.Password,
    this.Barcode,
  });
  UserModel copyWith({UserName, Password, Barcode}) {
    return UserModel(
      UserName: UserName ?? this.UserName,
      Password: Password ?? this.Password,
      Barcode: Barcode?? this.Barcode
      ,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      UserName: json['UserName'],
      Password: json['Password'],
      Barcode: json['Barcode'],

    );
  }

  Map<String, dynamic> toJson() => {
        "UserName": UserName,
        "Password": Password,
        "Barcode": Barcode,
      };
}
