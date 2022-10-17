class Users {
  static const tableField = "users";
  static const idField = "Id";
  static const userNameField = "userName";
  static const mobileNumberField = "mobileNumber";

  int id;
  String userName;
  String mobileNumber;

  Users({required this.id, required this.userName, required this.mobileNumber});

  Users fromJson(json) {
    return Users(
        id: json[idField],
        userName: json[userNameField],
        mobileNumber: json[mobileNumberField]);
  }

  Map<String, dynamic> toJson() {
    return {userNameField: userName, mobileNumberField: mobileNumber};
  }
}
