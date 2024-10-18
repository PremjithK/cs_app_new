class NewsEventsModel {
  List<NewsAndEvents>? _newsAndEvents;
  int? _statusCode;

  List<NewsAndEvents>? get newsAndEvents => _newsAndEvents;
  int? get statusCode => _statusCode;

  NewsEventsModel({List<NewsAndEvents>? newsAndEvents, int? statusCode}) {
    _newsAndEvents = newsAndEvents;
    _statusCode = statusCode;
  }

  NewsEventsModel.fromJson(dynamic json) {
    if (json["newsAndEvents"] != null) {
      _newsAndEvents = [];
      json["newsAndEvents"].forEach((v) {
        _newsAndEvents?.add(NewsAndEvents.fromJson(v));
      });
    }
    _statusCode = json["statusCode"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_newsAndEvents != null) {
      map["newsAndEvents"] = _newsAndEvents?.map((v) => v.toJson()).toList();
    }
    map["statusCode"] = _statusCode;
    return map;
  }
}

class NewsAndEvents {
  String? _description;
  String? _title;
  String? _createdDateTime;
  String? _showUntil;
  String? _showFrom;
  String? _updatedDateTime;
  bool? _news;
  String? _id;

  String? get description => _description;
  String? get title => _title;
  String? get createdDateTime => _createdDateTime;
  String? get showUntil => _showUntil;
  String? get showFrom => _showFrom;
  String? get updatedDateTime => _updatedDateTime;
  bool? get news => _news;
  String? get id => _id;

  NewsAndEvents(
      {String? description,
      String? title,
      String? createdDateTime,
      String? showUntil,
      String? showFrom,
      String? updatedDateTime,
      bool? news,
      String? id}) {
    _description = description;
    _title = title;
    _createdDateTime = createdDateTime;
    _showUntil = showUntil;
    _showFrom = showFrom;
    _updatedDateTime = updatedDateTime;
    _news = news;
    _id = id;
  }

  NewsAndEvents.fromJson(dynamic json) {
    _description = json["description"];
    _title = json["title"];
    _createdDateTime = json["createdDateTime"];
    _showUntil = json["showUntil"];
    _showFrom = json["showFrom"];
    _updatedDateTime = json["updatedDateTime"];
    _news = json["news"];
    _id = json["_id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["description"] = _description;
    map["title"] = _title;
    map["createdDateTime"] = _createdDateTime;
    map["showUntil"] = _showUntil;
    map["showFrom"] = _showFrom;
    map["updatedDateTime"] = _updatedDateTime;
    map["news"] = _news;
    map["_id"] = _id;
    return map;
  }
}
