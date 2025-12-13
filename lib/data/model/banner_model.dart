class BannerModel {
  int? id;
  String? slidertitle;
  String? image;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  BannerModel(
      {this.id,
      this.slidertitle,
      this.image,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  BannerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slidertitle = json['slider_title'];
    image = json['image'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['slider_title'] = this.slidertitle;
    data['image'] = this.image;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
