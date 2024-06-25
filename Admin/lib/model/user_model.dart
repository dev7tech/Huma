import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? id;
  final String? name;
  bool? isBlocked;
  final String? address;
  final Map? coordinates;
  final List? sexualOrientation;
  final String? gender;
  final String? showGender;
  final int? age;
  final String? phoneNumber;
  final int? maxDistance;

  final Map? ageRange;
  final Map? editInfo;
  List? imageUrl = [];
  int distanceBW;
  User({
    this.id,
    this.age,
    this.address,
    this.coordinates,
    this.name,
    this.imageUrl,
    this.isBlocked,
    this.phoneNumber,
    this.gender,
    this.showGender,
    required this.ageRange,
    this.maxDistance,
    required this.editInfo,
    this.distanceBW = 0,
    this.sexualOrientation,
  });
  factory User.fromDocument(DocumentSnapshot doc) {
    // DateTime date = DateTime.parse(doc["user_DOB"]);
    return User(
        id: doc.data().toString().contains('userId') ? doc.get('userId') : '0',
        isBlocked: doc.data().toString().contains('isBlocked')
            ? doc.get('isBlocked')
            : false,
        phoneNumber: doc.data().toString().contains('phoneNumber')
            ? doc.get('phoneNumber') ?? ""
            : '',
        name: doc.data().toString().contains('UserName')
            ? doc.get('UserName')
            : '',
        editInfo: doc.data().toString().contains('editInfo')
            ? doc.get('editInfo')
            : [],
        gender: doc.data().toString().contains('editInfo')
            ? doc.get('editInfo')['userGender']
            : [],
        ageRange: doc.data().toString().contains('age_range')
            ? doc.get('age_range')
            : [],
        showGender: doc.data().toString().contains('showGender')
            ? doc.get('showGender')
            : [],
        maxDistance: doc.data().toString().contains('maximum_distance')
            ? doc.get('maximum_distance')
            : 0,
        sexualOrientation: doc.data().toString().contains('sexualOrientation')
            ? doc.get('sexualOrientation')['orientation']
            : [],
        age: ((DateTime.now()
                    .difference(DateTime.parse(doc.get('user_DOB')))
                    .inDays) /
                365.2425)
            .truncate(),
        address: doc.data().toString().contains('location')
            ? doc.get('location')['address']
            : '',
        coordinates: doc['location'] ?? "",
        // university: doc['editInfo']['university'],
        imageUrl: doc.get('Pictures') != null
            ? List.generate(doc.get('Pictures').length, (index) {
                return doc.get('Pictures')[index];
              })
            : []);
  }
}
