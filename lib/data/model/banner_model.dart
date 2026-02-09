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
    id = _toInt(json['id']); // تحويل آمن للـ id
    slidertitle = json['slider_title']?.toString();
    image = json['image']?.toString();
    deletedAt = json['deleted_at']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slider_title'] = slidertitle;
    data['image'] = image;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
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
