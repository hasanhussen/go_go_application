class CategoryModel {
  int? id;
  String? type;
  String? image;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  CategoryModel(
      {this.id,
      this.type,
      this.image,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']); // تحويل آمن للـ id
    type = json['type']?.toString();
    image = json['image']?.toString();
    deletedAt = json['deleted_at']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['image'] = image;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }

  // دوال التحويل الآمنة لضمان استقرار التطبيق
  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is double) return value.toInt();
    return null;
  }
}
