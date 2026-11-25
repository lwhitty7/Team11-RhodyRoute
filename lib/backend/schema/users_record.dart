import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UsersRecord extends FirestoreRecord {
  UsersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "year_level" field.
  String? _yearLevel;
  String get yearLevel => _yearLevel ?? '';
  bool hasYearLevel() => _yearLevel != null;

  // "major" field.
  String? _major;
  String get major => _major ?? '';
  bool hasMajor() => _major != null;

  // "primary_campus" field.
  String? _primaryCampus;
  String get primaryCampus => _primaryCampus ?? '';
  bool hasPrimaryCampus() => _primaryCampus != null;

  // "user_bio" field.
  String? _userBio;
  String get userBio => _userBio ?? '';
  bool hasUserBio() => _userBio != null;

  // "login_Counter" field.
  int? _loginCounter;
  int get loginCounter => _loginCounter ?? 0;
  bool hasLoginCounter() => _loginCounter != null;

  // "NPS_SurveyCompletion" field.
  bool? _nPSSurveyCompletion;
  bool get nPSSurveyCompletion => _nPSSurveyCompletion ?? false;
  bool hasNPSSurveyCompletion() => _nPSSurveyCompletion != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _displayName = snapshotData['display_name'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _uid = snapshotData['uid'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _yearLevel = snapshotData['year_level'] as String?;
    _major = snapshotData['major'] as String?;
    _primaryCampus = snapshotData['primary_campus'] as String?;
    _userBio = snapshotData['user_bio'] as String?;
    _loginCounter = castToType<int>(snapshotData['login_Counter']);
    _nPSSurveyCompletion = snapshotData['NPS_SurveyCompletion'] as bool?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('users');

  static Stream<UsersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UsersRecord.fromSnapshot(s));

  static Future<UsersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UsersRecord.fromSnapshot(s));

  static UsersRecord fromSnapshot(DocumentSnapshot snapshot) => UsersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UsersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UsersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UsersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UsersRecord && reference.path == other.reference.path;
}

Map<String, dynamic> createUsersRecordData({
  String? email,
  String? displayName,
  String? photoUrl,
  String? uid,
  DateTime? createdTime,
  String? phoneNumber,
  String? yearLevel,
  String? major,
  String? primaryCampus,
  String? userBio,
  int? loginCounter,
  bool? nPSSurveyCompletion,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'uid': uid,
      'created_time': createdTime,
      'phone_number': phoneNumber,
      'year_level': yearLevel,
      'major': major,
      'primary_campus': primaryCampus,
      'user_bio': userBio,
      'login_Counter': loginCounter,
      'NPS_SurveyCompletion': nPSSurveyCompletion,
    }.withoutNulls,
  );

  return firestoreData;
}

class UsersRecordDocumentEquality implements Equality<UsersRecord> {
  const UsersRecordDocumentEquality();

  @override
  bool equals(UsersRecord? e1, UsersRecord? e2) {
    return e1?.email == e2?.email &&
        e1?.displayName == e2?.displayName &&
        e1?.photoUrl == e2?.photoUrl &&
        e1?.uid == e2?.uid &&
        e1?.createdTime == e2?.createdTime &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.yearLevel == e2?.yearLevel &&
        e1?.major == e2?.major &&
        e1?.primaryCampus == e2?.primaryCampus &&
        e1?.userBio == e2?.userBio &&
        e1?.loginCounter == e2?.loginCounter &&
        e1?.nPSSurveyCompletion == e2?.nPSSurveyCompletion;
  }

  @override
  int hash(UsersRecord? e) => const ListEquality().hash([
        e?.email,
        e?.displayName,
        e?.photoUrl,
        e?.uid,
        e?.createdTime,
        e?.phoneNumber,
        e?.yearLevel,
        e?.major,
        e?.primaryCampus,
        e?.userBio,
        e?.loginCounter,
        e?.nPSSurveyCompletion
      ]);

  @override
  bool isValidKey(Object? o) => o is UsersRecord;
}
