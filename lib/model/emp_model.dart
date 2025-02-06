import 'dart:convert';

EmployeeModel employeeModelFromJson(String str) =>
    EmployeeModel.fromJson(json.decode(str));

String employeeModelToJson(EmployeeModel data) => json.encode(data.toJson());

class EmployeeModel {
  EmployeeModel({
    this.employeeProfileId,
    this.grade,
    this.aadharCard,
    this.panCard,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.alterNativephoneNumber,
    this.vechicleNumber,
    this.drivingLisenceNumber,
    this.drivingLisenceExpriry,
    this.delivaryArea,
    this.email,
    this.userImageId,
    this.isDeleted,
    this.isActive,
    this.createdAt,
    this.createdBy,
    this.modifiedBy,
    this.modifiedDate,
    this.employeeRole = const <String>[],
    this.password,
    this.joinDate,
    this.dateOfBirth,
    this.bankAccountName,
    this.bankAccountNumber,
    this.ifsccode,
    this.bankBranch,
    this.fcmToken,
    this.city,
    this.bankName,
    this.assetsGiven,
    this.amountDeposited,
    this.applicationVerified = false,
    this.profileUpdateEnable = false,
  });

  String? employeeProfileId;
  dynamic grade;
  dynamic aadharCard;
  dynamic panCard;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? alterNativephoneNumber;
  dynamic vechicleNumber;
  dynamic drivingLisenceNumber;
  dynamic drivingLisenceExpriry;
  dynamic delivaryArea;
  String? email;
  String? userImageId;
  dynamic isDeleted;
  dynamic isActive;
  DateTime? createdAt;
  dynamic createdBy;
  String? modifiedBy;
  DateTime? modifiedDate;
  List<String> employeeRole;
  String? password;
  dynamic joinDate;
  dynamic dateOfBirth;
  dynamic bankAccountName;
  dynamic bankAccountNumber;
  dynamic ifsccode;
  dynamic bankBranch;
  dynamic fcmToken;
  dynamic city;
  dynamic bankName;
  dynamic assetsGiven;
  dynamic amountDeposited;
  bool applicationVerified;
  bool profileUpdateEnable;

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
        employeeProfileId: json["employeeProfileId"],
        grade: json["grade"],
        aadharCard: json["aadharCard"],
        panCard: json["panCard"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        phoneNumber: json["phoneNumber"],
        alterNativephoneNumber: json["alterNativephoneNumber"],
        vechicleNumber: json["vechicleNumber"],
        drivingLisenceNumber: json["drivingLisenceNumber"],
        drivingLisenceExpriry: json["drivingLisenceExpriry"],
        delivaryArea: json["delivaryArea"],
        email: json["email"],
        userImageId: json["userImageId"],
        isDeleted: json["isDeleted"],
        isActive: json["isActive"],
        createdAt: DateTime.parse(json["createdAt"]),
        createdBy: json["createdBy"],
        modifiedBy: json["modifiedBy"],
        modifiedDate: DateTime.parse(json["modifiedDate"]),
        employeeRole: json["employeeRole"] == null
            ? []
            : List<String>.from(json["employeeRole"].map((x) => x)),
        password: json["password"],
        joinDate: json["joinDate"],
        dateOfBirth: json["dateOfBirth"],
        bankAccountName: json["bankAccountName"],
        bankAccountNumber: json["bankAccountNumber"],
        ifsccode: json["ifsccode"],
        bankBranch: json["bankBranch"],
        fcmToken: json["fcmToken"],
        city: json["city"],
        bankName: json["bankName"],
        assetsGiven: json["assetsGiven"],
        amountDeposited: json["amountDeposited"],
        applicationVerified: json["applicationVerified"],
        profileUpdateEnable: json["profileUpdateEnable"],
      );

  Map<String, dynamic> toJson() => {
        "employeeProfileId": employeeProfileId,
        "grade": grade,
        "aadharCard": aadharCard,
        "panCard": panCard,
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
        "alterNativephoneNumber": alterNativephoneNumber,
        "vechicleNumber": vechicleNumber,
        "drivingLisenceNumber": drivingLisenceNumber,
        "drivingLisenceExpriry": drivingLisenceExpriry,
        "delivaryArea": delivaryArea,
        "email": email,
        "userImageId": userImageId,
        "isDeleted": isDeleted,
        "isActive": isActive,
        "createdAt": createdAt!.toIso8601String(),
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
        "modifiedDate": modifiedDate!.toIso8601String(),
        "employeeRole": List<dynamic>.from(employeeRole.map((x) => x)),
        "password": password,
        "joinDate": joinDate,
        "dateOfBirth": dateOfBirth,
        "bankAccountName": bankAccountName,
        "bankAccountNumber": bankAccountNumber,
        "ifsccode": ifsccode,
        "bankBranch": bankBranch,
        "fcmToken": fcmToken,
        "city": city,
        "bankName": bankName,
        "assetsGiven": assetsGiven,
        "amountDeposited": amountDeposited,
        "applicationVerified": applicationVerified,
        "profileUpdateEnable": profileUpdateEnable,
      };
}
