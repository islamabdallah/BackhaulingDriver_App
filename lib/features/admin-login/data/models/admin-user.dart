// @dart=2.9
class AdminUserModel {
  String UserName;
  String Password;

  AdminUserModel({
    this.UserName,
    this.Password,
  });
  AdminUserModel copyWith({UserName, Password, Barcode}) {
    return AdminUserModel(
      UserName: UserName ?? this.UserName,
      Password: Password ?? this.Password,

    );
  }

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    return AdminUserModel(
      UserName: json['UserName'],
      Password: json['Password'],

    );
  }

  Map<String, dynamic> toJson() => {
        "UserName": UserName,
        "Password": Password,
      };
}
