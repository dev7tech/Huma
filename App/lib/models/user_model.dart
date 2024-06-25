// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

// TODO: Remove
class UserModel {
  final String? id;
  final String? name;
  final bool? isBlocked;
  String? address;
  final double? latitude;
  final double? longitude;
  final Map? coordinates;
  final Map? currentCoordinates;
  final Map? sexualOrientation;
  final String? userGender;
  final String? living_in;
  final String? job_title;
  final String? company;
  final bool? showMyAge;
  String? showGender;
  final int? age;
  final String? phoneNumber;
  int? maxDistance;
  dynamic lastmsg;
  Map? ageRange;
  final Map? editInfo;
  final Map? streetView;
  List? imageUrl = [];
  // ignore: prefer_typing_uninitialized_variables
  var distanceBW;
  UserModel({
    this.living_in,
    this.job_title,
    this.company,
    this.showMyAge,
    this.id,
    this.age,
    this.address,
    this.latitude,
    this.longitude,
    this.isBlocked,
    this.coordinates,
    this.currentCoordinates,
    this.name,
    this.imageUrl,
    this.phoneNumber,
    this.lastmsg,
    this.userGender,
    this.showGender,
    this.ageRange,
    this.maxDistance,
    this.editInfo,
    this.streetView,
    this.distanceBW,
    this.sexualOrientation,
  });

  @override
  String toString() {
    return 'User: {id: $id,name:$name, isBlocked: $isBlocked, address: $address, coordinates: $coordinates,currentCoordinates :$currentCoordinates,  sexualOrientation: $sexualOrientation, gender: $userGender, showGender: $showGender, age: $age, phoneNumber: $phoneNumber, maxDistance: $maxDistance, lastmsg: $lastmsg, ageRange: $ageRange, editInfo: $editInfo, streetView: $streetView ,  distanceBW : $distanceBW }';
  }

  factory UserModel.fromDocument(dynamic doc) {
    return UserModel(
      id: doc.get('userId'),
      name: doc.get('UserName'),
      isBlocked: doc.get('isBlocked') ?? false,
      address: doc.get('location')['address'] ?? '',
      latitude: doc.get('location')['latitude'] ?? 0,
      longitude: doc.get('location')['longitude'] ?? 0,
      coordinates: doc.get('location') ?? {},
      currentCoordinates: doc.data().toString().contains('currentLocation')
          ? doc.get('currentLocation')
          : doc.get('location') ?? {},
      sexualOrientation: doc.data().toString().contains('sexualOrientation')
          ? doc.get('sexualOrientation')
          : {},

      userGender: doc.get('editInfo')['userGender'] ?? '',
      company: doc.get('editInfo')['company'] ?? '',
      job_title: doc.get('editInfo')['job_title'] ?? '',
      living_in: doc.get('editInfo')['living_in'] ?? '',
      showMyAge: doc.get('editInfo')['showMyAge'] ?? false,

      showGender: doc.get('showGender') ?? '',
      age: doc.get('age') ?? 18,
      phoneNumber: doc.get('phoneNumber') ?? '',
      maxDistance: doc.get('maximum_distance') ?? 0,
      // lastmsg: doc.get('lastmsg'),
      ageRange: doc.get('age_range'),
      editInfo: doc.get('editInfo') ?? {},
      streetView: doc.data().toString().contains('streetView')
          ? doc.get('streetView')
          : {},
      imageUrl: doc.get('Pictures') != null
          ? List.generate(doc.get('Pictures').length, (index) {
              return doc.get('Pictures')[index];
            })
          : [],
      // distanceBW: doc.get('distanceBW') ?? 0,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['userId'],
      name: json['UserName'],
      isBlocked: json['isBlocked'],
      address: json['location']['address'],
      latitude: json['location']['latitude'],
      longitude: json['location']['longitude'],
      coordinates: json['coordinates'],
      currentCoordinates: json['currentCoordinates'],
      sexualOrientation: json['sexualOrientation'],
      userGender: json['editInfo']['userGender'],
      living_in: json['living_in'],
      job_title: json['job_title'],
      company: json['company'],
      showMyAge: json['showMyAge'],
      showGender: json['showGender'],
      age: json['age'],
      phoneNumber: json['phoneNumber'],
      maxDistance: json['maximum_distance'],
      ageRange: json['age_range'],
      editInfo: json['editInfo'],
      streetView: json['streetView'],
      imageUrl: json['Pictures'],
      distanceBW: json['distanceBW'],
    );
  }

  static UserModel convertStringToUserModel(String userString) {
    final userMap = jsonDecode(userString);
    return UserModel.fromJson(userMap);
  }
}
