class DomainValidation {
  String? loginUrl;
  String? dashboardUrl;
  ParentCompanyId? parentCompanyId;
  String? result;
  String? companyType;
  String? companyName;
  AppSettings? appSettings;
  ParentCompanyId? companyId;
  ParentCompanyId? crmId;
  String? openGameUrl;
  String? platform;

  DomainValidation(
      {this.loginUrl,
      this.dashboardUrl,
      this.parentCompanyId,
      this.result,
      this.companyType,
      this.companyName,
      this.appSettings,
      this.companyId,
      this.crmId,
      this.openGameUrl,
      this.platform});

  DomainValidation.fromJson(Map<String, dynamic> json) {
    loginUrl = json['loginUrl'];
    dashboardUrl = json['dashboardUrl'];
    parentCompanyId = json['parentCompanyId'] != null
        ? ParentCompanyId.fromJson(json['parentCompanyId'])
        : null;
    result = json['result'];
    companyType = json['companyType'];
    companyName = json['companyName'];
    appSettings = json['appSettings'] != null
        ? AppSettings.fromJson(json['appSettings'])
        : null;
    companyId = json['companyId'] != null
        ? ParentCompanyId.fromJson(json['companyId'])
         : null;
    crmId = json['crmId'] != null
        ? ParentCompanyId.fromJson(json['crmId'])
        : null;
    openGameUrl = json['openGameUrl'];
    platform = json['platform'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['loginUrl'] = loginUrl;
    data['dashboardUrl'] = dashboardUrl;
    if (parentCompanyId != null) {
      data['parentCompanyId'] = parentCompanyId!.toJson();
    }
    data['result'] = result;
    data['companyType'] = companyType;
    data['companyName'] = companyName;
    if (appSettings != null) {
      data['appSettings'] = appSettings!.toJson();
    }
    if (companyId != null) {
      data['companyId'] = companyId!.toJson();
    }
    if (crmId != null) {
      data['crmId'] = crmId!.toJson();
    }
    data['openGameUrl'] = openGameUrl;
    data['platform'] = platform;
    return data;
  }
}

class ParentCompanyId {
  String? oid;

  ParentCompanyId({this.oid});

  ParentCompanyId.fromJson(Map<String, dynamic> json) {
    oid = json["\$oid"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['\$oid'] = oid;
    return data;
  }
}

class AppSettings {
  String? logo;
  String? favicon;

  AppSettings({this.logo, this.favicon});

  AppSettings.fromJson(Map<String, dynamic> json) {
    logo = json['logo'];
    favicon = json['favicon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['logo'] = logo;
    data['favicon'] = favicon;
    return data;
  }
}
