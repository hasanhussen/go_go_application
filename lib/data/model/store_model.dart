// class StoreModel {
//   int? id;
//   String? name;
//   int? userId;
//   int? companyType;
//   int? cityId;
//   String? delivery;
//   String? image;
//   String? address;
//   String? x;
//   String? y;
//   String? deletedAt;
//   String? createdAt;
//   String? updatedAt;
//   CompanyOwner? companyOwner;

//   StoreModel(
//       {this.id,
//       this.name,
//       this.userId,
//       this.companyType,
//       this.cityId,
//       this.delivery,
//       this.image,
//       this.address,
//       this.x,
//       this.y,
//       this.deletedAt,
//       this.createdAt,
//       this.updatedAt,
//       this.companyOwner});

//   StoreModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     userId = json['user_id'];
//     companyType = json['company_type'];
//     cityId = json['city_id'];
//     delivery = json['delivery'];
//     image = json['image'];
//     address = json['address'];
//     x = json['x'];
//     y = json['y'];
//     deletedAt = json['deleted_at'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     companyOwner = json['company_owner'] != null
//         ? new CompanyOwner.fromJson(json['company_owner'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['user_id'] = this.userId;
//     data['company_type'] = this.companyType;
//     data['city_id'] = this.cityId;
//     data['delivery'] = this.delivery;
//     data['image'] = this.image;
//     data['address'] = this.address;
//     data['x'] = this.x;
//     data['y'] = this.y;
//     data['deleted_at'] = this.deletedAt;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     if (this.companyOwner != null) {
//       data['company_owner'] = this.companyOwner!.toJson();
//     }
//     return data;
//   }
// }

// class CompanyOwner {
//   int? id;
//   String? name;
//   String? phone;
//   String? email;
//   String? gender;
//   String? avatar;
//   String? apiToken;
//   String? createdAt;
//   String? updatedAt;

//   CompanyOwner(
//       {this.id,
//       this.name,
//       this.phone,
//       this.email,
//       this.gender,
//       this.avatar,
//       this.apiToken,
//       this.createdAt,
//       this.updatedAt});

//   CompanyOwner.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     phone = json['phone'];
//     email = json['email'];
//     gender = json['gender'];
//     avatar = json['avatar'];
//     apiToken = json['api_token'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['phone'] = this.phone;
//     data['email'] = this.email;
//     data['gender'] = this.gender;
//     data['avatar'] = this.avatar;
//     data['api_token'] = this.apiToken;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }
