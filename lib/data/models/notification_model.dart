class NotificationModel {
  final bool success;
  final List<NotificationData> data;
  final PaginationModel pagination;
  final int unreadCount;

  NotificationModel({
    required this.success,
    required this.data,
    required this.pagination,
    required this.unreadCount,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      success: json['success'] ?? false,
      data: (json['data'] as List?)
              ?.map((item) => NotificationData.fromJson(item))
              .toList() ??
          [],
      pagination: PaginationModel.fromJson(json['pagination'] ?? {}),
      unreadCount: json['unreadCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((item) => item.toJson()).toList(),
      'pagination': pagination.toJson(),
      'unreadCount': unreadCount,
    };
  }
}

class NotificationData {
  final String id;
  final String userId;
  final String type;
  final String title;
  final String body;
  final bool isRead;
  final NotificationMetadata? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationData({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    required this.isRead,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      isRead: json['isRead'] ?? false,
      metadata: json['data'] != null
          ? NotificationMetadata.fromJson(json['data'])
          : null,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'type': type,
      'title': title,
      'body': body,
      'isRead': isRead,
      'data': metadata?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class NotificationMetadata {
  final String? itemId;
  final String? requestId;

  NotificationMetadata({
    this.itemId,
    this.requestId,
  });

  factory NotificationMetadata.fromJson(Map<String, dynamic> json) {
    return NotificationMetadata(
      itemId: json['itemId'],
      requestId: json['requestId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (itemId != null) 'itemId': itemId,
      if (requestId != null) 'requestId': requestId,
    };
  }
}

class PaginationModel {
  final int page;
  final int limit;
  final int total;
  final int pages;

  PaginationModel({
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 20,
      total: json['total'] ?? 0,
      pages: json['pages'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'pages': pages,
    };
  }
}
