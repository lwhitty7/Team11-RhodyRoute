import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NpsSurverycollectionRecord extends FirestoreRecord {
  NpsSurverycollectionRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "score" field.
  int? _score;
  int get score => _score ?? 0;
  bool hasScore() => _score != null;

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  bool hasCategory() => _category != null;

  // "comment" field.
  String? _comment;
  String get comment => _comment ?? '';
  bool hasComment() => _comment != null;

  // "CreatedAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "user" field.
  DocumentReference? _user;
  DocumentReference? get user => _user;
  bool hasUser() => _user != null;

  void _initializeFields() {
    _score = castToType<int>(snapshotData['score']);
    _category = snapshotData['category'] as String?;
    _comment = snapshotData['comment'] as String?;
    _createdAt = snapshotData['CreatedAt'] as DateTime?;
    _user = snapshotData['user'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('nps_surverycollection');

  static Stream<NpsSurverycollectionRecord> getDocument(
          DocumentReference ref) =>
      ref.snapshots().map((s) => NpsSurverycollectionRecord.fromSnapshot(s));

  static Future<NpsSurverycollectionRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => NpsSurverycollectionRecord.fromSnapshot(s));

  static NpsSurverycollectionRecord fromSnapshot(DocumentSnapshot snapshot) =>
      NpsSurverycollectionRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static NpsSurverycollectionRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      NpsSurverycollectionRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'NpsSurverycollectionRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is NpsSurverycollectionRecord &&
      reference.path == other.reference.path;
}

Map<String, dynamic> createNpsSurverycollectionRecordData({
  int? score,
  String? category,
  String? comment,
  DateTime? createdAt,
  DocumentReference? user,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'score': score,
      'category': category,
      'comment': comment,
      'CreatedAt': createdAt,
      'user': user,
    }.withoutNulls,
  );

  return firestoreData;
}

class NpsSurverycollectionRecordDocumentEquality
    implements Equality<NpsSurverycollectionRecord> {
  const NpsSurverycollectionRecordDocumentEquality();

  @override
  bool equals(NpsSurverycollectionRecord? e1, NpsSurverycollectionRecord? e2) {
    return e1?.score == e2?.score &&
        e1?.category == e2?.category &&
        e1?.comment == e2?.comment &&
        e1?.createdAt == e2?.createdAt &&
        e1?.user == e2?.user;
  }

  @override
  int hash(NpsSurverycollectionRecord? e) => const ListEquality()
      .hash([e?.score, e?.category, e?.comment, e?.createdAt, e?.user]);

  @override
  bool isValidKey(Object? o) => o is NpsSurverycollectionRecord;
}
