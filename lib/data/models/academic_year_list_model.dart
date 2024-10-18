// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

// ignore_for_file: prefer_if_null_operators

import 'dart:convert';

AcademicYearData academicYearDataFromJson(String str) => AcademicYearData.fromJson(json.decode(str));

String academicYearDataToJson(AcademicYearData data) => json.encode(data.toJson());

class AcademicYearData {
  AcademicYearData({
    this.academicYear,
  });

  List<AcademicYear>? academicYear;

  factory AcademicYearData.fromJson(Map<String, dynamic> json) => AcademicYearData(
    academicYear: List<AcademicYear>.from(json["academicYear"].map((x) => AcademicYear.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "academicYear": academicYear == null ? [] : List<dynamic>.from(academicYear!.map((x) => x.toJson())),
  };
}

class AcademicYear {
  AcademicYear({
    this.startDate,
    this.urmId,
    this.activeFlag,
    this.term2StartDate,
    this.companyId,
    this.createDate,
    this.term1StartDate,
    this.updatedDate,
    this.activeAcademicYear,
    this.term2EndDate,
    this.term1EndDate,
    this.crmId,
    this.endDate,
    this.id,
    this.academicYearName,
    this.academicProfileConfs,
  });

  DateTime? startDate;
  String? urmId;
  int? activeFlag;
  DateTime? term2StartDate;
  String? companyId;
  dynamic createDate;
  DateTime? term1StartDate;
  String? updatedDate;
  bool? activeAcademicYear;
  DateTime? term2EndDate;
  DateTime? term1EndDate;
  String? crmId;
  DateTime? endDate;
  String? id;
  String? academicYearName;
  List<AcademicProfileConf>? academicProfileConfs;

  factory AcademicYear.fromJson(Map<String, dynamic> json) => AcademicYear(
    startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
    urmId: json["urmId"],
    activeFlag: json["activeFlag"],
    term2StartDate: json["term2StartDate"] == null ? null : DateTime.parse(json["term2StartDate"]),
    companyId: json["companyId"],
    createDate: json["createDate"],
    term1StartDate: json["term1StartDate"] == null ? null : DateTime.parse(json["term1StartDate"]),
    updatedDate: json["updatedDate"] == null ? null : json["updatedDate"],
    activeAcademicYear: json["activeAcademicYear"],
    term2EndDate: json["term2EndDate"] == null ? null : DateTime.parse(json["term2EndDate"]),
    term1EndDate: json["term1EndDate"] == null ? null : DateTime.parse(json["term1EndDate"]),
    crmId: json["crmId"],
    endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
    id: json["_id"],
    academicYearName: json["academicYearName"],
    academicProfileConfs: json["academicProfileConfs"] == null ? null : List<AcademicProfileConf>.from(json["academicProfileConfs"].map((x) => AcademicProfileConf.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "startDate": startDate == "" || startDate == null ? null : startDate!.toIso8601String(),
    "urmId": urmId,
    "activeFlag": activeFlag,
    "term2StartDate": term2StartDate == "" || term2StartDate == null ? null : term2StartDate!.toIso8601String(),
    "companyId": companyId,
    "createDate": createDate,
    "term1StartDate": term1StartDate == "" || term1StartDate == null ? null : term1StartDate!.toIso8601String(),
    "updatedDate": updatedDate == "" || updatedDate == null ? null : updatedDate,
    "activeAcademicYear": activeAcademicYear,
    "term2EndDate": term2EndDate == "" || term2EndDate == null ? null : term2EndDate!.toIso8601String(),
    "term1EndDate": term1EndDate == "" || term1EndDate == null ? null : term1EndDate!.toIso8601String(),
    "crmId": crmId,
    "endDate": endDate == "" || endDate == null ? null : endDate!.toIso8601String(),
    "_id": id,
    "academicYearName": academicYearName,
    "academicProfileConfs": academicProfileConfs == null ? null : List<dynamic>.from(academicProfileConfs!.map((x) => x.toJson())),
  };
}

class AcademicProfileConf {
  AcademicProfileConf({
    this.classId,
    this.generateHistory,
    this.name,
    this.subjects,
    this.crmId,
    this.createdDate,
    this.confId,
    this.updatedDate,
    this.urmId,
  });

  String? classId;
  List<GenerateHistory>? generateHistory;
  String? name;
  List<Subject>? subjects;
  String? crmId;
  dynamic createdDate;
  String? confId;
  DateTime? updatedDate;
  String? urmId;

  factory AcademicProfileConf.fromJson(Map<String, dynamic> json) => AcademicProfileConf(
    classId: json["classId"],
    generateHistory:json["generateHistory"] != null ? List<GenerateHistory>.from(json["generateHistory"].map((x) => GenerateHistory.fromJson(x))) : [],
    name: json["name"],
    subjects: List<Subject>.from(json["subjects"].map((x) => Subject.fromJson(x))),
    crmId: json["crmId"],
    createdDate: json["createdDate"],
    confId: json["confId"],
    updatedDate: json["updatedDate"] == null ? null : DateTime.parse(json["updatedDate"]),
    urmId: json["urmId"] == null ? null : json["urmId"],
  );

  Map<String, dynamic> toJson() => {
    "classId": classId,
    "generateHistory": generateHistory == null ? [] : List<dynamic>.from(generateHistory!.map((x) => x.toJson())),
    "name": name,
    "subjects": subjects == null ? [] : List<dynamic>.from(subjects!.map((x) => x.toJson())),
    "crmId": crmId,
    "createdDate": createdDate,
    "confId": confId,
    "updatedDate": updatedDate == "" || updatedDate == null ? null : updatedDate!.toIso8601String(),
    "urmId": urmId == null ? null : urmId,
  };
}

class CreateDateClass {
  CreateDateClass();

  factory CreateDateClass.fromJson(Map<String, dynamic> json) => CreateDateClass(
  );

  Map<String, dynamic> toJson() => {
  };
}

// enum CrmId { THE_579_B1_F289_C5791610914_ADB7 }
//
// final crmIdValues = EnumValues({
//   "579b1f289c5791610914adb7": CrmId.THE_579_B1_F289_C5791610914_ADB7
// });

class GenerateHistory {
  GenerateHistory({
    this.createdBy,
    this.createdUserName,
    this.deactivatedOn,
    this.activeFlag,
    this.profileId,
    this.deactivatedBy,
    this.profileName,
    this.createdAt,
    this.confId,
  });

  String? createdBy;
  String? createdUserName;
  dynamic deactivatedOn;
  bool? activeFlag;
  String? profileId;
  dynamic deactivatedBy;
  String? profileName;
  DateTime? createdAt;
  String? confId;

  factory GenerateHistory.fromJson(Map<String, dynamic> json) => GenerateHistory(
    createdBy: json["createdBy"],
    createdUserName: json["createdUserName"],
    deactivatedOn: json["deactivatedOn"],
    activeFlag: json["activeFlag"],
    profileId: json["profileId"],
    deactivatedBy: json["deactivatedBy"],
    profileName: json["profileName"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    confId: json["confId"],
  );

  Map<String, dynamic> toJson() => {
    "createdBy": createdBy,
    "createdUserName": createdUserName,
    "deactivatedOn": deactivatedOn,
    "activeFlag": activeFlag,
    "profileId": profileId,
    "deactivatedBy": deactivatedBy,
    "profileName": profileName,
    "createdAt": createdAt == "" || createdAt == null ? null : createdAt!.toIso8601String(),
    "confId": confId,
  };
}

// enum CreatedUserName { DAYAPURAM_RESIDENTIAL_SCHOOL }
//
// final createdUserNameValues = EnumValues({
//   "Dayapuram Residential School": CreatedUserName.DAYAPURAM_RESIDENTIAL_SCHOOL
// });
//
// enum ProfileName { ACADEMIC_PROFILE_PERIODIC_TEST_1, ACADEMIC_PROFILE_PERIODIC_TEST_2, ACADEMIC_PROFILE_PERIODIC_TEST1, ACADEMIC_PROFILE_PERIODIC_TEST2, TESTING }
//
// final profileNameValues = EnumValues({
//   "Academic Profile - Periodic Test1": ProfileName.ACADEMIC_PROFILE_PERIODIC_TEST1,
//   "Academic Profile - Periodic Test2": ProfileName.ACADEMIC_PROFILE_PERIODIC_TEST2,
//   "Academic Profile - Periodic Test 1": ProfileName.ACADEMIC_PROFILE_PERIODIC_TEST_1,
//   "Academic Profile - Periodic Test 2": ProfileName.ACADEMIC_PROFILE_PERIODIC_TEST_2,
//   "Testing": ProfileName.TESTING
// });

class Subject {
  Subject({
    this.courses,
    this.subjectName,
    this.exams,
    this.subjectId,
  });

  List<Course>? courses;
  String? subjectName;
  List<Exam>? exams;
  String? subjectId;

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
    courses: json["courses"] == null ? null : List<Course>.from(json["courses"].map((x) => Course.fromJson(x))),
    subjectName: json["subjectName"],
    exams: json["exams"] == null ? null : List<Exam>.from(json["exams"].map((x) => Exam.fromJson(x))),
    subjectId: json["subjectId"],
  );

  Map<String, dynamic> toJson() => {
    "courses": courses == null ? null : List<dynamic>.from(courses!.map((x) => x.toJson())),
    "subjectName": subjectName,
    "exams": exams == null ? null : List<dynamic>.from(exams!.map((x) => x.toJson())),
    "subjectId": subjectId,
  };
}

class Course {
  Course({
    this.courseId,
    this.courseName,
  });

  String? courseId;
  String? courseName;

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    courseId: json["courseId"],
    courseName: json["courseName"],
  );

  Map<String, dynamic> toJson() => {
    "courseId": courseId,
    "courseName": courseName,
  };
}

class Exam {
  Exam({
    this.courseId,
    this.courseName,
    this.alias,
  });

  String? courseId;
  String? courseName;
  String? alias;

  factory Exam.fromJson(Map<String, dynamic> json) => Exam(
    courseId: json["courseId"],
    courseName: json["courseName"],
    alias: json["alias"] == null ? null : json["alias"],
  );

  Map<String, dynamic> toJson() => {
    "courseId": courseId,
    "courseName": courseName,
    "alias": alias == null ? null : alias,
  };
}

