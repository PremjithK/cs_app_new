import 'dart:convert';

/// teacherName : "CyberSquare"
/// activityName : "test"
/// markScored : 0
/// subjectName : "English"
/// materials : [{"status":"Pending submission","elements":[{"displayName":"Title","type":"cours-element-title","value":"test android app"},
/// {"displayName":"Question","type":"question-viewer",
/// "value":{"direction":"ltr","secondaryAnswer":[],"primaryAnswer":[{"Debug":"{\"type\": \"elementdescription\", \"name\": \"field1798\",\"displayName\": \"Description\",\"customlist\": [{\"text\": \"description\",\"value\": \"previewkey\"}],\"validation\": {\"messages\": {}}}","ticked":true,"Name":"Description","icon":"fa-list-alt"}],"question":"<div class=\"line\" id=\"line-1\">test</div>","mark":{"totalMark":5,"markCriteria":[{}]},"ques":"<div class=\"line\" id=\"line-1\">test</div>","answer":[],"type":"descriptive","multiAnswer":false}}],"Name":"question","title":"test android app","evaluable":true,"fkResourceId":"5fdb74d268e667000a6dc185","version":1,"totalMark":5,"_id":"5fdb74d268e667000a6dc185","Icon":"fa-question-circle"}]
/// createdDate : "2021-10-25T10:37:21.200"
/// totalMark : 5
/// _id : "617688e1d70589071c5b20cb"

class ActivitiesModel {
  String? _teacherName;
  dynamic _activityName;
  double? _markScored;
  String? _subjectName;
  //List<Materials>? _materials;
  int? _materialcount;
  String? _createdDate;
  dynamic _totalMark;
  String? _id;
  int? _submittedCount;

  String? get teacherName => _teacherName;
  dynamic get activityName => _activityName;

  double? get markScored => _markScored;
  int? get materialcount => _materialcount;
  String? get subjectName => _subjectName;
  // List<Materials>? get materials => _materials;
  String? get createdDate => _createdDate;
  dynamic get totalMark => _totalMark;
  String? get id => _id;
  int? get submittedCount => _submittedCount;

  ActivitiesModel(
      {String? teacherName,
      dynamic activityName,
      double? markScored,
      int? materialcount,
      String? subjectName,
      List<Materials>? materials,
      String? createdDate,
      dynamic totalMark,
      String? id,
      int? submittedCount}) {
    _teacherName = teacherName;
    _activityName = activityName;
    _markScored = markScored;
    _materialcount = materialcount;
    _subjectName = subjectName;
    // _materials = materials;
    _createdDate = createdDate;
    _totalMark = totalMark;
    _id = id;
    _submittedCount = submittedCount;
  }

  ActivitiesModel.fromJson(dynamic json) {
    _teacherName = Utf8Decoder().convert(json["teacherName"].codeUnits);
    _activityName = json["activityName"] != null
        ? const Utf8Decoder().convert(json["activityName"].codeUnits)
        : null;
    _markScored = double.parse(json["markScored"].toString());
    _materialcount = json["materialCount"] ?? 1;
    _subjectName = Utf8Decoder().convert(json["subjectName"].codeUnits);
    // if (json["materials"] != null) {
    //   _materials = [];
    //   json["materials"].forEach((v) {
    //     _materials?.add(Materials.fromJson(v));
    //   });
    // }else{
    //   _materials = [];
    // }
    _createdDate = json["createdDate"];
    _totalMark = json["totalMark"];
    _id = json["_id"];
    _submittedCount = json["submittedCount"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["teacherName"] = _teacherName;
    map["activityName"] = _activityName;
    map["markScored"] = _markScored;
    map["materialcount"] = _materialcount;
    map["subjectName"] = _subjectName;
    // if (_materials != null) {
    //   map["materials"] = _materials?.map((v) => v.toJson()).toList();
    // }else{
    //   map["materials"]= "";
    // }
    map["createdDate"] = _createdDate;
    map["totalMark"] = _totalMark;
    map["_id"] = _id;
    map["_submittedCount"] = submittedCount;
    return map;
  }
}

/// status : "Pending submission"
/// elements : [{"displayName":"Title","type":"cours-element-title","value":"test android app"},{"displayName":"Question","type":"question-viewer","value":{"direction":"ltr","secondaryAnswer":[],"primaryAnswer":[{"Debug":"{\"type\": \"elementdescription\", \"name\": \"field1798\",\"displayName\": \"Description\",\"customlist\": [{\"text\": \"description\",\"value\": \"previewkey\"}],\"validation\": {\"messages\": {}}}","ticked":true,"Name":"Description","icon":"fa-list-alt"}],"question":"<div class=\"line\" id=\"line-1\">test</div>","mark":{"totalMark":5,"markCriteria":[{}]},"ques":"<div class=\"line\" id=\"line-1\">test</div>","answer":[],"type":"descriptive","multiAnswer":false}}]
/// Name : "question"
/// title : "test android app"
/// evaluable : true
/// fkResourceId : "5fdb74d268e667000a6dc185"
/// version : 1
/// totalMark : 5
/// _id : "5fdb74d268e667000a6dc185"
/// Icon : "fa-question-circle"

class Materials {
  String? _status;
  List<Elements>? _elements;
  String? _name;
  String? _title;
  bool? _evaluable;
  String? _fkResourceId;
  int? _version;
  dynamic? _totalMark;
  String? _id;
  String? _icon;
  String? _date;
  bool? _showAnswerAfterSubmiting;

  double? _markScored;

  String? get status => _status;
  List<Elements>? get elements => _elements;
  String? get name => _name;
  String? get title => _title;
  bool? get evaluable => _evaluable;
  String? get fkResourceId => _fkResourceId;
  int? get version => _version;
  dynamic? get totalMark => _totalMark;
  String? get id => _id;
  String? get icon => _icon;
  String? get date => _date;
  bool? get showAnswerAfterSubmiting => _showAnswerAfterSubmiting;

  double? get markScored => _markScored;

  Materials({
    String? status,
    List<Elements>? elements,
    String? name,
    String? title,
    bool? evaluable,
    String? fkResourceId,
    int? version,
    dynamic? totalMark,
    String? id,
    String? icon,
    String? date,
    double? markScored,
    bool? showAnswerAfterSubmiting,
  }) {
    _status = status;
    // _elements = elements;
    _name = name;
    _title = title;
    _evaluable = evaluable;
    _fkResourceId = fkResourceId;
    _version = version;
    _totalMark = totalMark;
    _id = id;
    _icon = icon;
    _date = date;
    _markScored = markScored == null ? 0 : markScored.toDouble();
    _showAnswerAfterSubmiting = showAnswerAfterSubmiting;
  }

  Materials.fromJson(dynamic json) {
    if (json["status"] != null) {
      if (json["status"].runtimeType == String) {
        _status = json["status"];
      }
    } else {
      _status = "";
    }
    if (json["elements"] != null) {
      _elements = [];
      json["elements"].forEach((v) {
        _elements?.add(Elements.fromJson(v));
      });
    }
    _name = json["Name"];
    _title = json["title"] != null
        ? Utf8Decoder().convert(json["title"].codeUnits)
        : null;
    _evaluable = json["evaluable"];
    _showAnswerAfterSubmiting = json["showAnswerAfterSubmiting"];
    _fkResourceId = json["fkResourceId"];
    _version = json["version"];
    _totalMark = json["totalMark"];
    _id = json["_id"];
    _icon = json["Icon"];
    if (json["evaluatedOnUtc"] != null) {
      _date = json["evaluatedOnUtc"];
    } else {}
    _markScored = json["markScored"] != null
        ? double.parse(json["markScored"].toString())
        : 0.0;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    if (_elements != null) {
      map["elements"] = _elements?.map((v) => v.toJson()).toList();
    }
    map["Name"] = _name;
    map["title"] = _title;
    map["evaluable"] = _evaluable;
    map["showAnswerAfterSubmiting"] = _showAnswerAfterSubmiting;
    map["fkResourceId"] = _fkResourceId;
    map["version"] = _version;
    map["totalMark"] = _totalMark;
    map["_id"] = _id;
    map["Icon"] = _icon;
    map["date"] = _date;
    map["markScored"] = _markScored.runtimeType == int
        ? _markScored!.toInt()
        : _markScored!.toDouble();
    return map;
  }
}

/// displayName : "Title"
/// type : "cours-element-title"
/// value : "test android app"

class Elements {
  dynamic? _displayName;
  dynamic? _type;
  dynamic _value;

  dynamic? get displayName => _displayName;

  dynamic? get type => _type;

  dynamic get value => _value;

  Elements({dynamic? displayName, dynamic? type, dynamic? value}) {
    _displayName = displayName;
    _type = type;
    _value = value;
  }

  Elements.fromJson(dynamic json) {
    _displayName = Utf8Decoder().convert(json["displayName"].codeUnits);
    _type = Utf8Decoder().convert(json["type"].codeUnits);
    _value = json["value"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["displayName"] = _displayName;
    map["type"] = _type;
    map["value"] = _value;
    return map;
  }

//
// class Materials {
//   Materials({
//     required this.elements,
//     required this.Name,
//     required this.title,
//     required this.evaluable,
//     required this.version,
//     required this.totalMark,
//     required this.id,
//     required this.Icon,
//   });
//   late final List<Elements> elements;
//   late final String Name;
//   late final String title;
//   late final bool evaluable;
//   late final int version;
//   late final int totalMark;
//   late final String id;
//   late final String Icon;
//
//   Materials.fromJson(Map<String, dynamic> json){
//     elements = List.from(json['elements']).map((e)=>Elements.fromJson(e)).toList();
//     Name = json['Name'];
//     title = json['title'];
//     evaluable = json['evaluable'];
//     version = json['version'];
//     totalMark = json['totalMark'];
//     id = json['_id'];
//     Icon = json['Icon'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['elements'] = elements.map((e)=>e.toJson()).toList();
//     _data['Name'] = Name;
//     _data['title'] = title;
//     _data['evaluable'] = evaluable;
//     _data['version'] = version;
//     _data['totalMark'] = totalMark;
//     _data['_id'] = id;
//     _data['Icon'] = Icon;
//     return _data;
//   }
// }
//
// class Elements {
//   Elements({
//     required this.displayName,
//     required this.type,
//     required this.value,
//   });
//   late final String displayName;
//   late final String type;
//   late final String? value;
//
//   Elements.fromJson(Map<String, dynamic> json){
//     displayName = json['displayName'];
//     type = json['type'];
//     value = json['value'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['displayName'] = displayName;
//     _data['type'] = type;
//     _data['value'] = value;
//     return _data;
//   }
// }
//
// class Value {
//   Value({
//     required this.secondaryAnswer,
//     required this.primaryAnswer,
//     required this.question,
//     required this.mark,
//     required this.ques,
//     required this.answer,
//     required this.type,
//     required this.multiAnswer,
//   });
//   late final List<dynamic> secondaryAnswer;
//   late final List<PrimaryAnswer> primaryAnswer;
//   late final String question;
//   late final Mark mark;
//   late final String ques;
//   late final List<dynamic> answer;
//   late final String type;
//   late final bool multiAnswer;
//
//   Value.fromJson(Map<String, dynamic> json){
//     secondaryAnswer = List.castFrom<dynamic, dynamic>(json['secondaryAnswer']);
//     primaryAnswer = List.from(json['primaryAnswer']).map((e)=>PrimaryAnswer.fromJson(e)).toList();
//     question = json['question'];
//     mark = Mark.fromJson(json['mark']);
//     ques = json['ques'];
//     answer = List.castFrom<dynamic, dynamic>(json['answer']);
//     type = json['type'];
//     multiAnswer = json['multiAnswer'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['secondaryAnswer'] = secondaryAnswer;
//     _data['primaryAnswer'] = primaryAnswer.map((e)=>e.toJson()).toList();
//     _data['question'] = question;
//     _data['mark'] = mark.toJson();
//     _data['ques'] = ques;
//     _data['answer'] = answer;
//     _data['type'] = type;
//     _data['multiAnswer'] = multiAnswer;
//     return _data;
//   }
// }
//
// class PrimaryAnswer {
//   PrimaryAnswer({
//     required this.Debug,
//     required this.ticked,
//     required this.Name,
//     required this.icon,
//   });
//   late final String Debug;
//   late final bool ticked;
//   late final String Name;
//   late final String icon;
//
//   PrimaryAnswer.fromJson(Map<String, dynamic> json){
//     Debug = json['Debug'];
//     ticked = json['ticked'];
//     Name = json['Name'];
//     icon = json['icon'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['Debug'] = Debug;
//     _data['ticked'] = ticked;
//     _data['Name'] = Name;
//     _data['icon'] = icon;
//     return _data;
//   }
// }
//
// class Mark {
//   Mark({
//     required this.totalMark,
//     required this.markCriteria,
//   });
//   late final int totalMark;
//   late final List<MarkCriteria> markCriteria;
//
//   Mark.fromJson(Map<String, dynamic> json){
//     totalMark = json['totalMark'];
//     markCriteria = List.from(json['markCriteria']).map((e)=>MarkCriteria.fromJson(e)).toList();
//   }
//
//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['totalMark'] = totalMark;
//     _data['markCriteria'] = markCriteria.map((e)=>e.toJson()).toList();
//     return _data;
//   }
// }
//
// class MarkCriteria {
//   MarkCriteria();
//
//   MarkCriteria.fromJson(Map json);
//
//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     return _data;
//   }
// }
//
}
