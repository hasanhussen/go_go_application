class MyStoreModel {
  int? id;
  String? name;
  int? userId;
  int? companyType;
  int? cityId;
  String? delivery;
  String? image;
  String? cover;
  String? special;
  String? rejectionReason;
  String? banReason;
  String? banUntil;
  String? appeal;
  String? address;
  int? followers;
  double? bayesianScore;
  int? totalRatings;
  String? phone;
  String? status;
  List<WorkingHours>? workingHours;
  bool? isOpenNow;
  String? x;
  String? y;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  MyStoreModel(
      {this.id,
      this.name,
      this.userId,
      this.companyType,
      this.cityId,
      this.delivery,
      this.image,
      this.cover,
      this.special,
      this.rejectionReason,
      this.banUntil,
      this.banReason,
      this.appeal,
      this.address,
      this.followers,
      this.bayesianScore,
      this.totalRatings,
      this.x,
      this.y,
      this.phone,
      this.status,
      this.workingHours,
      this.isOpenNow,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  MyStoreModel.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    name = json['name']?.toString();
    userId = _toInt(json['user_id']);
    companyType = _toInt(json['company_type']);
    cityId = _toInt(json['city_id']);
    delivery = json['delivery']?.toString();
    image = json['image']?.toString();
    cover = json['cover']?.toString();
    special = json['special']?.toString();
    rejectionReason = json['delete_reason']?.toString();
    banReason = json['ban_reason']?.toString();
    appeal = json['appeal']?.toString();
    banUntil = json['ban_until']?.toString();
    address = json['address']?.toString();
    followers = _toInt(json['followers']);
    totalRatings = _toInt(json['total_ratings']);
    bayesianScore = _toDouble(json['bayesian_score']);
    x = json['x']?.toString();
    y = json['y']?.toString();
    phone = json['phone']?.toString();
    status = json['status']?.toString();

    if (json['working_hours'] != null) {
      workingHours = <WorkingHours>[];
      json['working_hours'].forEach((v) {
        workingHours!.add(new WorkingHours.fromJson(v));
      });
    }

    // تأمين حقل bool في حال جاء كـ int من السيرفر
    if (json['is_open_now'] is bool) {
      isOpenNow = json['is_open_now'];
    } else if (json['is_open_now'] != null) {
      isOpenNow = json['is_open_now'].toString() == '1' ||
          json['is_open_now'].toString() == 'true';
    }

    deletedAt = json['deleted_at']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['user_id'] = this.userId;
    data['company_type'] = this.companyType;
    data['city_id'] = this.cityId;
    data['delivery'] = this.delivery;
    data['image'] = this.image;
    data['cover'] = this.cover;
    data['address'] = this.address;
    data['special'] = this.special;
    data['delete_reason'] = this.rejectionReason;
    data['ban_reason'] = this.banReason;
    data['ban_until'] = this.banUntil;
    data['appeal'] = this.appeal;
    data['status'] = this.status;
    if (this.workingHours != null) {
      data['working_hours'] =
          this.workingHours!.map((v) => v.toJson()).toList();
    }
    data['is_open_now'] = this.isOpenNow;
    data['phone'] = this.phone;
    data['followers'] = this.followers;
    data['x'] = this.x;
    data['y'] = this.y;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }

  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is double) return value.toInt();
    return null;
  }

  double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

class WorkingHours {
  int? id;
  String? day;
  String? openAt;
  String? closeAt;
  int? is24;

  WorkingHours({this.id, this.day, this.openAt, this.closeAt, this.is24});

  WorkingHours.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']); // تأمين حقل id في WorkingHours
    day = json['day']?.toString();
    openAt = json['open_at']?.toString();
    closeAt = json['close_at']?.toString();
    is24 = _toInt(json['is_24']); // تأمين حقل is24
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['day'] = this.day;
    data['open_at'] = this.openAt;
    data['close_at'] = this.closeAt;
    data['is_24'] = this.is24;
    return data;
  }

  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}
