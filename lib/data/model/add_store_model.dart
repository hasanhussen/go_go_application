class AddStoreModel {
  String? name;
  String? companyType;
  int? userId;
  String? cityId;
  String? delivery;
  String? image;
  String? cover;
  String? special;
  String? address;
  String? phone;
  String? updatedAt;
  String? createdAt;
  int? id;

  AddStoreModel(
      {this.name,
      this.companyType,
      this.userId,
      this.cityId,
      this.delivery,
      this.image,
      this.cover,
      this.special,
      this.phone,
      this.address,
      this.updatedAt,
      this.createdAt,
      this.id});

  AddStoreModel.fromJson(Map<String, dynamic> json) {
    name = json['name']?.toString();
    companyType = json['company_type']?.toString();
    userId = _toInt(json['user_id']); // تحويل آمن لـ int
    cityId =
        json['city_id']?.toString(); // تحويل آمن لـ String في حال جاء رقماً
    delivery = json['delivery']?.toString();
    image = json['image']?.toString();
    address = json['address']?.toString();
    cover = json['cover']?.toString();
    special = json['special']?.toString();
    phone = json['phone']?.toString();
    updatedAt = json['updated_at']?.toString();
    createdAt = json['created_at']?.toString();
    id = _toInt(json['id']); // تحويل آمن لـ int
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['company_type'] = companyType;
    data['user_id'] = userId;
    data['city_id'] = cityId;
    data['delivery'] = delivery;
    data['image'] = image;
    data['cover'] = cover;
    data['special'] = special;
    data['phone'] = phone;
    data['address'] = address;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }

  // دوال التحويل الآمنة
  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is double) return value.toInt();
    return null;
  }
}
