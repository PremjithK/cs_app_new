class CourseProgressModel {
  String? _classId;
  List<String>? _materialOrder;
  String? _name;
  int? _markScored;
  int? _materialCount;
  String? _fkUserLoginId;
  int? _submittedCount;
  List<ExamDueDates>? _examDueDates;
  String? _divisionId;
  String? _id;

  String? get classId => _classId;
  List<String>? get materialOrder => _materialOrder;
  String? get name => _name;
  int? get markScored => _markScored;
  int? get materialCount => _materialCount;
  String? get fkUserLoginId => _fkUserLoginId;
  int? get submittedCount => _submittedCount;
  List<ExamDueDates>? get examDueDates => _examDueDates;
  String? get divisionId => _divisionId;
  String? get id => _id;

  CourseProgressModel(
      {String? classId,
      List<String>? materialOrder,
      String? name,
      int? markScored,
      int? materialCount,
      String? fkUserLoginId,
      int? submittedCount,
      List<ExamDueDates>? examDueDates,
      String? divisionId,
      String? id}) {
    _classId = classId;
    _materialOrder = materialOrder;
    _name = name;
    _markScored = markScored;
    _materialCount = materialCount;
    _fkUserLoginId = fkUserLoginId;
    _submittedCount = submittedCount;
    _examDueDates = examDueDates;
    _divisionId = divisionId;
    _id = id;
  }

  CourseProgressModel.fromJson(dynamic json) {
    _classId = json["classId"];
    _materialOrder = json["materialOrder"] != null
        ? json["materialOrder"].cast<String>()
        : [];
    _name = json["Name"];
    _markScored = json["markScored"];
    _materialCount = json["materialCount"];
    _fkUserLoginId = json["fkUserLoginId"];
    _submittedCount = json["submittedCount"];
    if (json["examDueDates"] != null) {
      _examDueDates = [];
      json["examDueDates"].forEach((v) {
        _examDueDates?.add(ExamDueDates.fromJson(v));
      });
    }
    _divisionId = json["divisionId"];
    _id = json["_id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["classId"] = _classId;
    map["materialOrder"] = _materialOrder;
    map["Name"] = _name;
    map["markScored"] = _markScored;
    map["materialCount"] = _materialCount;
    map["fkUserLoginId"] = _fkUserLoginId;
    map["submittedCount"] = _submittedCount;
    if (_examDueDates != null) {
      map["examDueDates"] = _examDueDates?.map((v) => v.toJson()).toList();
    }
    map["divisionId"] = _divisionId;
    map["_id"] = _id;
    return map;
  }
}

/// examId : "60b0cf0454c54d22ebc8dc68"
/// title : "E Safety G5-G8: Final Assessment"

class ExamDueDates {
  String? _examId;
  String? _title;

  String? get examId => _examId;
  String? get title => _title;

  ExamDueDates({String? examId, String? title}) {
    _examId = examId;
    _title = title;
  }

  ExamDueDates.fromJson(dynamic json) {
    _examId = json["examId"];
    _title = json["title"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["examId"] = _examId;
    map["title"] = _title;
    return map;
  }
}
