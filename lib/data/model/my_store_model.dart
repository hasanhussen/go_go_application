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
    id = json['id'];
    name = json['name'];
    userId = json['user_id'];
    companyType = json['company_type'];
    cityId = json['city_id'];
    delivery = json['delivery'];
    image = json['image'];
    cover = json['cover'];
    special = json['special'];
    rejectionReason = json['delete_reason'];
    banReason = json['ban_reason'];
    appeal = json['appeal'];
    banUntil = json['ban_until'];
    address = json['address'];
    followers = json['followers'];
    totalRatings = json['total_ratings'];
    bayesianScore = json['bayesian_score'] != null
        ? (json['bayesian_score'] as num).toDouble()
        : 0.0;
    x = json['x'];
    y = json['y'];
    phone = json['phone'];
    status = json['status'];
    if (json['working_hours'] != null) {
      workingHours = <WorkingHours>[];
      json['working_hours'].forEach((v) {
        workingHours!.add(new WorkingHours.fromJson(v));
      });
    }
    isOpenNow = json['is_open_now'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
}

class WorkingHours {
  int? id;
  String? day;
  String? openAt;
  String? closeAt;
  // int? isOpen;
  int? is24;

  WorkingHours({this.id, this.day, this.openAt, this.closeAt, this.is24});

  WorkingHours.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    day = json['day'];
    openAt = json['open_at'];
    closeAt = json['close_at'];
    // isOpen = json['is_open'];
    // is24 = json['is_24'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['day'] = this.day;
    data['open_at'] = this.openAt;
    data['close_at'] = this.closeAt;
    // data['is_open'] = this.isOpen;
    // data['is_24'] = this.is24;
    return data;
  }
}
