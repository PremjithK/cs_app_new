// To parse this JSON data, do
//
//     final LiveClassroomData = LiveClassroomDataFromJson(jsonString);

// ignore_for_file: prefer_if_null_operators

import 'dart:convert';

LiveClassroomData liveClassroomDataFromJson(String str) =>
    LiveClassroomData.fromJson(json.decode(str));

String liveClassroomDataToJson(LiveClassroomData data) =>
    json.encode(data.toJson());

class LiveClassroomData {
  LiveClassroomData({
    this.liveClasses,
    this.statusCode,
  });

  List<LiveClass>? liveClasses;
  int? statusCode;

  factory LiveClassroomData.fromJson(Map<String, dynamic> json) =>
      LiveClassroomData(
        liveClasses: json["liveClasses"] == null
            ? null
            : List<LiveClass>.from(
                json["liveClasses"].map((x) => LiveClass.fromJson(x))),
        statusCode: json["statusCode"] == null ? null : json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
        "liveClasses": liveClasses == null
            ? null
            : List<dynamic>.from(liveClasses!.map((x) => x.toJson())),
        "statusCode": statusCode == null ? null : statusCode,
      };
}

class LiveClass {
  LiveClass({
    this.endDate,
    this.googleMeetingLink,
    this.createdDate,
    this.crmId,
    this.childCompanyId,
    this.companyId,
    this.currentlyActiveMeeting,
    this.activeFlag,
    this.type,
    this.googleCalendarEvent,
    this.status,
    this.studentMappings,
    this.fkUserLoginId,
    this.startTime,
    this.namePrefix,
    this.date,
    this.id,
    this.name,
    this.presenter,
    this.sessionStartedAt,
    this.fkUserRoleMappingId,
    this.endTime,
    this.presenterJoinedAt,
    this.sameEndDate,
    this.academicYearId,
    this.addStudentsToCalender,
    this.zoomMeetingJoinUrl,
  });

  DateTime? endDate;
  String? googleMeetingLink;
  DateTime? createdDate;
  String? crmId;
  String? childCompanyId;
  String? companyId;
  String? currentlyActiveMeeting;
  int? activeFlag;
  String? type;
  List<GoogleCalendarEvent>? googleCalendarEvent;
  String? status;
  List<StudentMapping>? studentMappings;
  String? fkUserLoginId;
  DateTime? startTime;
  String? namePrefix;
  DateTime? date;
  String? id;
  String? name;
  String? presenter;
  DateTime? sessionStartedAt;
  String? fkUserRoleMappingId;
  DateTime? endTime;
  DateTime? presenterJoinedAt;
  bool? sameEndDate;
  String? academicYearId;
  bool? addStudentsToCalender;
  String? zoomMeetingJoinUrl;

  factory LiveClass.fromJson(Map<String, dynamic> json) => LiveClass(
        endDate:
            json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        googleMeetingLink: json["googleMeetingLink"] == null
            ? null
            : json["googleMeetingLink"],
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
        crmId: json["crmId"] == null ? null : json["crmId"],
        childCompanyId:
            json["childCompanyId"] == null ? null : json["childCompanyId"],
        companyId: json["companyId"] == null ? null : json["companyId"],
        currentlyActiveMeeting: json["currentlyActiveMeeting"] == null
            ? null
            : json["currentlyActiveMeeting"],
        activeFlag: json["activeFlag"] == null ? null : json["activeFlag"],
        type: json["type"] == null ? null : json["type"],
        googleCalendarEvent: json["googleCalendarEvent"] == null
            ? null
            : List<GoogleCalendarEvent>.from(json["googleCalendarEvent"]
                .map((x) => GoogleCalendarEvent.fromJson(x))),
        status: json["status"] == null ? null : json["status"],
        studentMappings: json["studentMappings"] == null
            ? null
            : List<StudentMapping>.from(
                json["studentMappings"].map((x) => StudentMapping.fromJson(x))),
        fkUserLoginId:
            json["fkUserLoginId"] == null ? null : json["fkUserLoginId"],
        startTime: json["startTime"] == null
            ? null
            : DateTime.parse(json["startTime"]),
        namePrefix: json["namePrefix"] == null ? null : json["namePrefix"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        presenter: json["presenter"] == null ? null : json["presenter"],
        sessionStartedAt: json["sessionStartedAt"] == null
            ? null
            : DateTime.parse(json["sessionStartedAt"]),
        fkUserRoleMappingId: json["fkUserRoleMappingId"] == null
            ? null
            : json["fkUserRoleMappingId"],
        endTime:
            json["endTime"] == null ? null : DateTime.parse(json["endTime"]),
        presenterJoinedAt: json["presenterJoinedAt"] == null
            ? null
            : DateTime.parse(json["presenterJoinedAt"]),
        sameEndDate: json["sameEndDate"] == null ? null : json["sameEndDate"],
        academicYearId:
            json["academicYearId"] == null ? null : json["academicYearId"],
        addStudentsToCalender: json["addStudentsToCalender"] == null
            ? null
            : json["addStudentsToCalender"],
        zoomMeetingJoinUrl: json["zoomMeetingJoinUrl"] == null
            ? null
            : json["zoomMeetingJoinUrl"],
      );

  Map<String, dynamic> toJson() => {
        "endDate": endDate == null ? null : endDate!.toIso8601String(),
        "googleMeetingLink":
            googleMeetingLink == null ? null : googleMeetingLink,
        "createdDate":
            createdDate == null ? null : createdDate!.toIso8601String(),
        "crmId": crmId == null ? null : crmId,
        "childCompanyId": childCompanyId == null ? null : childCompanyId,
        "companyId": companyId == null ? null : companyId,
        "currentlyActiveMeeting":
            currentlyActiveMeeting == null ? null : currentlyActiveMeeting,
        "activeFlag": activeFlag == null ? null : activeFlag,
        "type": type == null ? null : type,
        "googleCalendarEvent": googleCalendarEvent == null
            ? null
            : List<dynamic>.from(googleCalendarEvent!.map((x) => x.toJson())),
        "status": status == null ? null : status,
        "studentMappings": studentMappings == null
            ? null
            : List<dynamic>.from(studentMappings!.map((x) => x.toJson())),
        "fkUserLoginId": fkUserLoginId == null ? null : fkUserLoginId,
        "startTime": startTime == null ? null : startTime!.toIso8601String(),
        "namePrefix": namePrefix == null ? null : namePrefix,
        "date": date == null ? null : date!.toIso8601String(),
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "presenter": presenter == null ? null : presenter,
        "sessionStartedAt": sessionStartedAt == null
            ? null
            : sessionStartedAt!.toIso8601String(),
        "fkUserRoleMappingId":
            fkUserRoleMappingId == null ? null : fkUserRoleMappingId,
        "endTime": endTime == null ? null : endTime!.toIso8601String(),
        "presenterJoinedAt": presenterJoinedAt == null
            ? null
            : presenterJoinedAt!.toIso8601String(),
        "sameEndDate": sameEndDate == null ? null : sameEndDate,
        "academicYearId": academicYearId == null ? null : academicYearId,
        "addStudentsToCalender":
            addStudentsToCalender == null ? null : addStudentsToCalender,
        "zoomMeetingJoinUrl":
            zoomMeetingJoinUrl == null ? null : zoomMeetingJoinUrl,
      };
}

class GoogleCalendarEvent {
  GoogleCalendarEvent({
    // this.sequence,
    // this.eventType,
    this.result,
    this.organizer,
    this.id,
    this.hangoutLink,
    this.end,
    // this.htmlLink,
    this.start,
    // this.etag,
    // this.location,
    this.status,
    this.updated,
    this.description,
    // this.iCalUid,
    this.conferenceData,
    // this.kind,
    this.created,
    this.reminders,
    // this.guestsCanSeeOtherGuests,
    // this.summary,
    // this.guestsCanInviteOthers,
    this.attendees,
    this.creator,
  });

  // int? sequence;
  // String? eventType;
  GoogleCalendarEvent? result;
  Creator? organizer;
  String? id;
  String? hangoutLink;
  End? end;
  // String? htmlLink;
  End? start;
  // String? etag;
  // String? location;
  String? status;
  DateTime? updated;
  String? description;
  // String? iCalUid;
  ConferenceData? conferenceData;
  // String? kind;
  DateTime? created;
  Reminders? reminders;
  // bool? guestsCanSeeOtherGuests;
  // String? summary;
  // bool? guestsCanInviteOthers;
  List<Attendee>? attendees;
  Creator? creator;

  factory GoogleCalendarEvent.fromJson(Map<String, dynamic> json) =>
      GoogleCalendarEvent(
        // sequence: json["sequence"] == null ? null : json["sequence"],
        // eventType: json["eventType"] == null ? null : json["eventType"],
        result: json["result"] == null
            ? null
            : GoogleCalendarEvent.fromJson(json["result"]),
        organizer: json["organizer"] == null
            ? null
            : Creator.fromJson(json["organizer"]),
        id: json["id"] == null ? null : json["id"],
        hangoutLink: json["hangoutLink"] == null ? null : json["hangoutLink"],
        end: json["end"] == null ? null : End.fromJson(json["end"]),
        // htmlLink: json["htmlLink"] == null ? null : json["htmlLink"],
        start: json["start"] == null ? null : End.fromJson(json["start"]),
        // etag: json["etag"] == null ? null : json["etag"],
        // location: json["location"] == null ? null : json["location"],
        status: json["status"] == null ? null : json["status"],
        updated:
            json["updated"] == null ? null : DateTime.parse(json["updated"]),
        description: json["description"] == null ? null : json["description"],
        // iCalUid: json["iCalUID"] == null ? null : json["iCalUID"],
        conferenceData: json["conferenceData"] == null
            ? null
            : ConferenceData.fromJson(json["conferenceData"]),
        // kind: json["kind"] == null ? null : json["kind"],
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        reminders: json["reminders"] == null
            ? null
            : Reminders.fromJson(json["reminders"]),
        // guestsCanSeeOtherGuests: json["guestsCanSeeOtherGuests"] == null ? null : json["guestsCanSeeOtherGuests"],
        // summary: json["summary"] == null ? null : json["summary"],
        // guestsCanInviteOthers: json["guestsCanInviteOthers"] == null ? null : json["guestsCanInviteOthers"],
        attendees: json["attendees"] == null
            ? null
            : List<Attendee>.from(
                json["attendees"].map((x) => Attendee.fromJson(x))),
        creator:
            json["creator"] == null ? null : Creator.fromJson(json["creator"]),
      );

  Map<String, dynamic> toJson() => {
        // "sequence": sequence == null ? null : sequence,
        // "eventType": eventType == null ? null : eventType,
        "result": result == null ? null : result!.toJson(),
        "organizer": organizer == null ? null : organizer!.toJson(),
        "id": id == null ? null : id,
        "hangoutLink": hangoutLink == null ? null : hangoutLink,
        "end": end == null ? null : end!.toJson(),
        // "htmlLink": htmlLink == null ? null : htmlLink,
        "start": start == null ? null : start!.toJson(),
        // "etag": etag == null ? null : etag,
        // "location": location == null ? null : location,
        "status": status == null ? null : status,
        "updated": updated == null ? null : updated!.toIso8601String(),
        "description": description == null ? null : description,
        // "iCalUID": iCalUid == null ? null : iCalUid,
        "conferenceData":
            conferenceData == null ? null : conferenceData!.toJson(),
        // "kind": kind == null ? null : kind,
        "created": created == null ? null : created!.toIso8601String(),
        "reminders": reminders == null ? null : reminders!.toJson(),
        // "guestsCanSeeOtherGuests": guestsCanSeeOtherGuests == null ? null : guestsCanSeeOtherGuests,
        // "summary": summary == null ? null : summary,
        // "guestsCanInviteOthers": guestsCanInviteOthers == null ? null : guestsCanInviteOthers,
        "attendees": attendees == null
            ? null
            : List<dynamic>.from(attendees!.map((x) => x.toJson())),
        "creator": creator == null ? null : creator!.toJson(),
      };
}

class Attendee {
  Attendee({
    this.email,
    this.self,
    this.organizer,
    this.responseStatus,
    this.displayName,
  });

  String? email;
  bool? self;
  bool? organizer;
  String? responseStatus;
  String? displayName;

  factory Attendee.fromJson(Map<String, dynamic> json) => Attendee(
        email: json["email"] == null ? null : json["email"],
        self: json["self"] == null ? null : json["self"],
        organizer: json["organizer"] == null ? null : json["organizer"],
        responseStatus:
            json["responseStatus"] == null ? null : json["responseStatus"],
        displayName: json["displayName"] == null ? null : json["displayName"],
      );

  Map<String, dynamic> toJson() => {
        "email": email == null ? null : email,
        "self": self == null ? null : self,
        "organizer": organizer == null ? null : organizer,
        "responseStatus": responseStatus == null ? null : responseStatus,
        "displayName": displayName == null ? null : displayName,
      };
}

// enum ResponseStatus { ACCEPTED, NEEDS_ACTION }
//
// final responseStatusValues = EnumValues({
//   "accepted": ResponseStatus.ACCEPTED,
//   "needsAction": ResponseStatus.NEEDS_ACTION
// });

class ConferenceData {
  ConferenceData({
    this.conferenceId,
    this.entryPoints,
    this.signature,
    this.createRequest,
    this.conferenceSolution,
  });

  String? conferenceId;
  List<EntryPoint>? entryPoints;
  String? signature;
  CreateRequest? createRequest;
  ConferenceSolution? conferenceSolution;

  factory ConferenceData.fromJson(Map<String, dynamic> json) => ConferenceData(
        conferenceId:
            json["conferenceId"] == null ? null : json["conferenceId"],
        entryPoints: json["entryPoints"] == null
            ? null
            : List<EntryPoint>.from(
                json["entryPoints"].map((x) => EntryPoint.fromJson(x))),
        signature: json["signature"] == null ? null : json["signature"],
        createRequest: json["createRequest"] == null
            ? null
            : CreateRequest.fromJson(json["createRequest"]),
        conferenceSolution: json["conferenceSolution"] == null
            ? null
            : ConferenceSolution.fromJson(json["conferenceSolution"]),
      );

  Map<String, dynamic> toJson() => {
        "conferenceId": conferenceId == null ? null : conferenceId,
        "entryPoints": entryPoints == null
            ? null
            : List<dynamic>.from(entryPoints!.map((x) => x.toJson())),
        "signature": signature == null ? null : signature,
        "createRequest": createRequest == null ? null : createRequest!.toJson(),
        "conferenceSolution":
            conferenceSolution == null ? null : conferenceSolution!.toJson(),
      };
}

class ConferenceSolution {
  ConferenceSolution({
    this.iconUri,
    this.name,
    this.key,
  });

  String? iconUri;
  String? name;
  ConferenceSolutionKey? key;

  factory ConferenceSolution.fromJson(Map<String, dynamic> json) =>
      ConferenceSolution(
        iconUri: json["iconUri"] == null ? null : json["iconUri"],
        name: json["name"] == null ? null : json["name"],
        key: json["key"] == null
            ? null
            : ConferenceSolutionKey.fromJson(json["key"]),
      );

  Map<String, dynamic> toJson() => {
        "iconUri": iconUri == null ? null : iconUri,
        "name": name == null ? null : name,
        "key": key == null ? null : key!.toJson(),
      };
}

class ConferenceSolutionKey {
  ConferenceSolutionKey({
    this.type,
  });

  String? type;

  factory ConferenceSolutionKey.fromJson(Map<String, dynamic> json) =>
      ConferenceSolutionKey(
        type: json["type"] == null ? null : json["type"],
      );

  Map<String, dynamic> toJson() => {
        "type": type == null ? null : type,
      };
}

// enum Type { HANGOUTS_MEET }
//
// final typeValues = EnumValues({
//   "hangoutsMeet": Type.HANGOUTS_MEET
// });
//
// enum Name { GOOGLE_MEET }
//
// final nameValues = EnumValues({
//   "Google Meet": Name.GOOGLE_MEET
// });

class CreateRequest {
  CreateRequest({
    this.status,
    this.conferenceSolutionKey,
    this.requestId,
  });

  StatusClass? status;
  ConferenceSolutionKey? conferenceSolutionKey;
  String? requestId;

  factory CreateRequest.fromJson(Map<String, dynamic> json) => CreateRequest(
        status: json["status"] == null
            ? null
            : StatusClass.fromJson(json["status"]),
        conferenceSolutionKey: json["conferenceSolutionKey"] == null
            ? null
            : ConferenceSolutionKey.fromJson(json["conferenceSolutionKey"]),
        requestId: json["requestId"] == null ? null : json["requestId"],
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status!.toJson(),
        "conferenceSolutionKey": conferenceSolutionKey == null
            ? null
            : conferenceSolutionKey!.toJson(),
        "requestId": requestId == null ? null : requestId,
      };
}

class StatusClass {
  StatusClass({
    this.statusCode,
  });

  String? statusCode;

  factory StatusClass.fromJson(Map<String, dynamic> json) => StatusClass(
        statusCode: json["statusCode"] == null ? null : json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode == null ? null : statusCode,
      };
}

// final statusCodeValues = EnumValues({
//   "success": StatusCode.SUCCESS
// });

class EntryPoint {
  EntryPoint({
    this.entryPointType,
    this.uri,
    this.label,
    this.regionCode,
    this.pin,
  });

  String? entryPointType;
  String? uri;
  String? label;
  String? regionCode;
  String? pin;

  factory EntryPoint.fromJson(Map<String, dynamic> json) => EntryPoint(
        entryPointType:
            json["entryPointType"] == null ? null : json["entryPointType"],
        uri: json["uri"] == null ? null : json["uri"],
        label: json["label"] == null ? null : json["label"],
        regionCode: json["regionCode"] == null ? null : json["regionCode"],
        pin: json["pin"] == null ? null : json["pin"],
      );

  Map<String, dynamic> toJson() => {
        "entryPointType": entryPointType == null ? null : entryPointType,
        "uri": uri == null ? null : uri,
        "label": label == null ? null : label,
        "regionCode": regionCode == null ? null : regionCode,
        "pin": pin == null ? null : pin,
      };
}

// enum EntryPointType { VIDEO, PHONE }

// final entryPointTypeValues = EnumValues({
//   "phone": EntryPointType.PHONE,
//   "video": EntryPointType.VIDEO
// });

// enum RegionCode { US }
//
// final regionCodeValues = EnumValues({
//   "US": RegionCode.US
// });

class Creator {
  Creator({
    this.self,
    this.email,
  });

  bool? self;
  String? email;

  factory Creator.fromJson(Map<String, dynamic> json) => Creator(
        self: json["self"] == null ? null : json["self"],
        email: json["email"] == null ? null : json["email"],
      );

  Map<String, dynamic> toJson() => {
        "self": self == null ? null : self,
        "email": email == null ? null : email,
      };
}

class End {
  End({
    this.timeZone,
    this.dateTime,
  });

  String? timeZone;
  DateTime? dateTime;

  factory End.fromJson(Map<String, dynamic> json) => End(
        timeZone: json["timeZone"] == null ? null : json["timeZone"],
        dateTime:
            json["dateTime"] == null ? null : DateTime.parse(json["dateTime"]),
      );

  Map<String, dynamic> toJson() => {
        "timeZone": timeZone == null ? null : timeZone,
        "dateTime": dateTime == null ? null : dateTime!.toIso8601String(),
      };
}

/*enum TimeZone { ASIA_DUBAI }

final timeZoneValues = EnumValues({
  "Asia/Dubai": TimeZone.ASIA_DUBAI
});

enum EventType { DEFAULT }

final eventTypeValues = EnumValues({
  "default": EventType.DEFAULT
});

enum Kind { CALENDAR_EVENT }

final kindValues = EnumValues({
  "calendar#event": Kind.CALENDAR_EVENT
});

enum Location { THE_99_LMS }

final locationValues = EnumValues({
  "99LMS": Location.THE_99_LMS
});*/

class Reminders {
  Reminders({
    this.overrides,
    this.useDefault,
  });

  List<Override>? overrides;
  bool? useDefault;

  factory Reminders.fromJson(Map<String, dynamic> json) => Reminders(
        overrides: json["overrides"] == null
            ? null
            : List<Override>.from(
                json["overrides"].map((x) => Override.fromJson(x))),
        useDefault: json["useDefault"] == null ? null : json["useDefault"],
      );

  Map<String, dynamic> toJson() => {
        "overrides": overrides == null
            ? null
            : List<dynamic>.from(overrides!.map((x) => x.toJson())),
        "useDefault": useDefault == null ? null : useDefault,
      };
}

class Override {
  Override({
    this.minutes,
    this.method,
  });

  int? minutes;
  String? method;

  factory Override.fromJson(Map<String, dynamic> json) => Override(
        minutes: json["minutes"] == null ? null : json["minutes"],
        method: json["method"] == null ? null : json["method"],
      );

  Map<String, dynamic> toJson() => {
        "minutes": minutes == null ? null : minutes,
        "method": method == null ? null : method,
      };
}

// enum Method { POPUP, EMAIL }

// final methodValues = EnumValues({
//   "email": Method.EMAIL,
//   "popup": Method.POPUP
// });

// enum StatusEnum { CONFIRMED }
//
// final statusEnumValues = EnumValues({
//   "confirmed": StatusEnum.CONFIRMED
// });

class StudentMapping {
  StudentMapping({
    this.divisionId,
    this.className,
    this.divisionName,
    this.classId,
    this.type,
    this.streamName,
    this.streamId,
    this.academicYearId,
  });

  String? divisionId;
  String? className;
  String? divisionName;
  String? classId;
  String? type;
  String? streamName;
  String? streamId;
  String? academicYearId;

  factory StudentMapping.fromJson(Map<String, dynamic> json) => StudentMapping(
        divisionId: json["divisionId"] == null ? null : json["divisionId"],
        className: json["className"] == null ? null : json["className"],
        divisionName:
            json["divisionName"] == null ? null : json["divisionName"],
        classId: json["classId"] == null ? null : json["classId"],
        type: json["type"] == null ? null : json["type"],
        streamName: json["streamName"] == null ? null : json["streamName"],
        streamId: json["streamId"] == null ? null : json["streamId"],
        academicYearId:
            json["academicYearId"] == null ? null : json["academicYearId"],
      );

  Map<String, dynamic> toJson() => {
        "divisionId": divisionId == null ? null : divisionId,
        "className": className == null ? null : className,
        "divisionName": divisionName == null ? null : divisionName,
        "classId": classId == null ? null : classId,
        "type": type == null ? null : type,
        "streamName": streamName == null ? null : streamName,
        "streamId": streamId == null ? null : streamId,
        "academicYearId": academicYearId == null ? null : academicYearId,
      };
}
