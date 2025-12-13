class NotificationModel {
  String? id;
  String? type;
  String? notifiableType;
  int? notifiableId;
  Data? data;
  String? readAt;
  String? createdAt;
  String? updatedAt;

  NotificationModel(
      {this.id,
      this.type,
      this.notifiableType,
      this.notifiableId,
      this.data,
      this.readAt,
      this.createdAt,
      this.updatedAt});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    notifiableType = json['notifiable_type'];
    notifiableId = json['notifiable_id'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    readAt = json['read_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['notifiable_type'] = this.notifiableType;
    data['notifiable_id'] = this.notifiableId;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['read_at'] = this.readAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Data {
  int? userId;
  String? status;
  int? storeId;
  String? title;
  String? body;
  String? type;
  String? icon;

  Data(
      {this.userId,
      this.status,
      this.title,
      this.body,
      this.type,
      this.icon,
      this.storeId});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    status = json['status'];
    if (json['store_id'] is int) {
      storeId = json['store_id'];
    } else if (json['store_id'] is String) {
      storeId = int.tryParse(json['store_id']) ?? 0;
    } else {
      storeId = 0;
    }
    title = json['title'];
    body = json['body'];
    type = json['type'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['status'] = this.status;
    data['storeId'] = this.storeId;
    data['title'] = this.title;
    data['body'] = this.body;
    data['type'] = this.type;
    data['icon'] = this.icon;
    return data;
  }
}
