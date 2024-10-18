// To parse this JSON data, do
//
//     final SideMenuData = SideMenuDataFromJson(jsonString);

// ignore_for_file: prefer_if_null_operators

import 'dart:convert';

SideMenuData sideMenuDataFromJson(String str) =>
    SideMenuData.fromJson(json.decode(str));

// String sideMenuDataToJson(SideMenuData data) => json.encode(data.toJson());

class SideMenuData {
  String? urmId;
  DateTime? maintenanceUpdateOn;
  String? childCompanyId;
  String? companyId;
  String? maintenanceUpdateMessage;
  String? crmId;
  String? menuFor;
  DateTime? updatedDate;
  int? activeFlag;
  String? createdDate;
  List<MenuStructure>? menuStructure;
  String? id;
  int? fkRoleId;
  int? statusCode;

  SideMenuData({
    this.urmId,
    this.maintenanceUpdateOn,
    this.childCompanyId,
    this.companyId,
    this.maintenanceUpdateMessage,
    this.crmId,
    this.menuFor,
    this.updatedDate,
    this.activeFlag,
    this.createdDate,
    this.menuStructure,
    this.id,
    this.fkRoleId,
    this.statusCode,
  });

  factory SideMenuData.fromJson(Map<String, dynamic> json) => SideMenuData(
        urmId: json["urmId"] ?? "",
        maintenanceUpdateOn: json["maintenanceUpdateOn"] == null
            ? null
            : DateTime.parse(json["maintenanceUpdateOn"]),
        childCompanyId: json["childCompanyId"],
        companyId: json["companyId"],
        maintenanceUpdateMessage: json["maintenanceUpdateMessage"],
        crmId: json["crmId"],
        menuFor: json["menuFor"],
        updatedDate: json["updatedDate"] == null
            ? null
            : DateTime.parse(json["updatedDate"]),
        activeFlag: json["activeFlag"],
        createdDate: json["createdDate"],
        menuStructure: List<MenuStructure>.from(
            json["menuStructure"].map((x) => MenuStructure.fromJson(x))),
        id: json["_id"],
        fkRoleId: json["fkRoleId"],
        statusCode: json["statusCode"],
      );

  /*Map<String, dynamic> toJson() => {
    "urmId": urmId,
    "maintenanceUpdateOn": maintenanceUpdateOn?.toIso8601String(),
    "childCompanyId": childCompanyId,
    "companyId": companyId,
    "maintenanceUpdateMessage": maintenanceUpdateMessage,
    "crmId": crmId,
    "menuFor": menuFor,
    "updatedDate": updatedDate?.toIso8601String(),
    "activeFlag": activeFlag,
    "createdDate": createdDate,
    "menuStructure": List<dynamic>.from(menuStructure.map((x) => x.toJson())),
    "_id": id,
    "fkRoleId": fkRoleId,
    "statusCode": statusCode,
  };*/
}

class MenuStructure {
  MenuStructure({
    this.fkmenuRegionId,
    this.regionMenuStructure,
  });

  int? fkmenuRegionId;
  List<RegionMenuStructure>? regionMenuStructure;

  factory MenuStructure.fromJson(Map<String, dynamic> json) => MenuStructure(
        fkmenuRegionId: json["fkmenuRegionId"],
        regionMenuStructure: List<RegionMenuStructure>.from(
            json["regionMenuStructure"]
                .map((x) => RegionMenuStructure.fromJson(x))),
      );

  /*Map<String, dynamic> toJson() => {
    "fkmenuRegionId": fkmenuRegionId,
    "regionMenuStructure": List<dynamic>.from(regionMenuStructure.map((x) => x.toJson())),
  };*/
}

class RegionMenuStructure {
  RegionMenuStructure({
    this.menuName,
    this.childMenuStructure,
    this.actions,
    this.updatedDate,
    this.fkMenuId,
    this.activeFlag,
    this.urmId,
    this.menuIcon,
    this.canView,
    this.menuLink,
    this.actionMaster,
    this.actionName,
    this.stateName,
    this.crmId,
    this.createdDate,
    this.publicLink,
    this.menuImgPathRemoved,
    this.menuText,
    this.params,
  });

  String? menuName;
  List<dynamic>? childMenuStructure;
  List<Action>? actions;
  String? updatedDate;
  String? fkMenuId;
  int? activeFlag;
  dynamic urmId;
  String? menuIcon;
  bool? canView;
  String? menuLink;
  List<Action>? actionMaster;
  String? actionName;
  String? stateName;
  String? crmId;
  String? createdDate;
  bool? publicLink;
  String? menuImgPathRemoved;
  String? menuText;
  Params? params;

  factory RegionMenuStructure.fromJson(Map<String, dynamic> json) =>
      RegionMenuStructure(
        menuName: json["MenuName"],
        childMenuStructure:
            List<dynamic>.from(json["childMenuStructure"].map((x) => x)),
        actions:
            List<Action>.from(json["actions"].map((x) => Action.fromJson(x))),
        updatedDate: json["updatedDate"] == null ? null : json["updatedDate"],
        fkMenuId: json["fkMenuId"],
        activeFlag: json["activeFlag"] == null ? null : json["activeFlag"],
        urmId: json["urmId"],
        menuIcon: json["menuIcon"],
        canView: json["canView"] == null ? null : json["canView"],
        menuLink: json["MenuLink"] == null ? null : json["MenuLink"],
        actionMaster: json["actionMaster"] == null
            ? null
            : List<Action>.from(
                json["actionMaster"].map((x) => Action.fromJson(x))),
        actionName: json["actionName"] == null ? null : json["actionName"],
        stateName: json["stateName"] == null ? null : json["stateName"],
        crmId: json["crmId"] == null ? null : json["crmId"],
        createdDate: json["createdDate"] == null ? null : json["createdDate"],
        publicLink: json["publicLink"] == null ? null : json["publicLink"],
        menuImgPathRemoved: json["menuImgPath_removed"] == null
            ? null
            : json["menuImgPath_removed"],
        menuText: json["menuText"] == null ? null : json["menuText"],
        params: json["params"] == null ? null : Params.fromJson(json["params"]),
      );

  /*Map<String, dynamic> toJson() => {
    "MenuName": menuName,
    "childMenuStructure": List<dynamic>.from(childMenuStructure.map((x) => x)),
    "actions": List<dynamic>.from(actions.map((x) => x.toJson())),
    "updatedDate": updatedDate == null ? null : updatedDate,
    "fkMenuId": fkMenuId,
    "activeFlag": activeFlag == null ? null : activeFlag,
    "urmId": urmId,
    "menuIcon": menuIcon,
    "canView": canView == null ? null : canView,
    "MenuLink": menuLink == null ? null : menuLink,
    "actionMaster": actionMaster == null ? null : List<dynamic>.from(actionMaster.map((x) => x.toJson())),
    "actionName": actionName == null ? null : actionName,
    "stateName": stateName == null ? null : stateName,
    "crmId": crmId == null ? null : crmId,
    "createdDate": createdDate == null ? null : createdDate,
    "publicLink": publicLink == null ? null : publicLink,
    "menuImgPath_removed": menuImgPathRemoved == null ? null : menuImgPathRemoved,
    "menuText": menuText == null ? null : menuText,
    "params": params == null ? null : params.toJson(),
  };*/
}

class Action {
  Action({
    this.actionName,
    this.stateName,
  });

  String? actionName;
  String? stateName;

  factory Action.fromJson(Map<String, dynamic> json) => Action(
        actionName: json["actionName"],
        stateName: json["stateName"],
      );

  /*Map<String, dynamic> toJson() => {
    "actionName": actionName,
    "stateName": stateName,
  };*/
}

class Params {
  Params({
    this.game,
  });

  String? game;

  factory Params.fromJson(Map<String, dynamic> json) => Params(
        game: json["game"],
      );

  /*Map<String, dynamic> toJson() => {
    "game": game,
  };*/
}

class UrmIdClass {
  UrmIdClass();

  factory UrmIdClass.fromJson(Map<String, dynamic> json) => UrmIdClass();

  /*Map<String, dynamic> toJson() => {
  };*/
}
