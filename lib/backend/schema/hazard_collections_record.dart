import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class HazardCollectionsRecord extends FirestoreRecord {
  HazardCollectionsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "Title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "Description" field.
  String? _description;
  String get description => _description ?? '';
  bool hasDescription() => _description != null;

  // "Expired" field.
  bool? _expired;
  bool get expired => _expired ?? false;
  bool hasExpired() => _expired != null;

  // "TimeToExpire" field.
  int? _timeToExpire;
  int get timeToExpire => _timeToExpire ?? 0;
  bool hasTimeToExpire() => _timeToExpire != null;

  // "CreatedTime" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "Location" field.
  LatLng? _location;
  LatLng? get location => _location;
  bool hasLocation() => _location != null;

  // "User" field.
  DocumentReference? _user;
  DocumentReference? get user => _user;
  bool hasUser() => _user != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  void _initializeFields() {
    _title = snapshotData['Title'] as String?;
    _description = snapshotData['Description'] as String?;
    _expired = snapshotData['Expired'] as bool?;
    _timeToExpire = castToType<int>(snapshotData['TimeToExpire']);
    _createdTime = snapshotData['CreatedTime'] as DateTime?;
    _location = snapshotData['Location'] as LatLng?;
    _user = snapshotData['User'] as DocumentReference?;
    _photoUrl = snapshotData['photo_url'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('hazard_collections');

  static Stream<HazardCollectionsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => HazardCollectionsRecord.fromSnapshot(s));

  static Future<HazardCollectionsRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => HazardCollectionsRecord.fromSnapshot(s));

  static HazardCollectionsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      HazardCollectionsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static HazardCollectionsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      HazardCollectionsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'HazardCollectionsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is HazardCollectionsRecord &&
      reference.path == other.reference.path;
}

Map<String, dynamic> createHazardCollectionsRecordData({
  String? title,
  String? description,
  bool? expired,
  int? timeToExpire,
  DateTime? createdTime,
  LatLng? location,
  DocumentReference? user,
  String? photoUrl,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'Title': title,
      'Description': description,
      'Expired': expired,
      'TimeToExpire': timeToExpire,
      'CreatedTime': createdTime,
      'Location': location,
      'User': user,
      'photo_url': photoUrl,
    }.withoutNulls,
  );

  return firestoreData;
}

class HazardCollectionsRecordDocumentEquality
    implements Equality<HazardCollectionsRecord> {
  const HazardCollectionsRecordDocumentEquality();

  @override
  bool equals(HazardCollectionsRecord? e1, HazardCollectionsRecord? e2) {
    return e1?.title == e2?.title &&
        e1?.description == e2?.description &&
        e1?.expired == e2?.expired &&
        e1?.timeToExpire == e2?.timeToExpire &&
        e1?.createdTime == e2?.createdTime &&
        e1?.location == e2?.location &&
        e1?.user == e2?.user &&
        e1?.photoUrl == e2?.photoUrl;
  }

  @override
  int hash(HazardCollectionsRecord? e) => const ListEquality().hash([
        e?.title,
        e?.description,
        e?.expired,
        e?.timeToExpire,
        e?.createdTime,
        e?.location,
        e?.user,
        e?.photoUrl
      ]);

  @override
  bool isValidKey(Object? o) => o is HazardCollectionsRecord;
}
