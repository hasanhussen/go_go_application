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
    name = json['name'];
    companyType = json['company_type'];
    userId = json['user_id'];
    cityId = json['city_id'];
    delivery = json['delivery'];
    image = json['image'];
    address = json['address'];

    cover = json['cover'];
    special = json['special'];
    phone = json['phone'];

    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['company_type'] = this.companyType;
    data['user_id'] = this.userId;
    data['city_id'] = this.cityId;
    data['delivery'] = this.delivery;
    data['image'] = this.image;

    data['cover'] = this.cover;
    data['special'] = this.special;
    data['phone'] = this.phone;

    data['address'] = this.address;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
