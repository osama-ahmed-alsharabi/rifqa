class CategoryItemModel {
  final String? id;
  final String name;
  final String description;
  final String type;
  final String imageUrl;
  final List<String> activities;
  final DateTime createdAt;
  final DateTime updatedAt;

  CategoryItemModel({
    this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.imageUrl,
    required this.activities,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert JSON to CategoryItemModel object
  factory CategoryItemModel.fromJson(Map<String, dynamic> json) {
    return CategoryItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      imageUrl: json['image_url'] as String,
      activities: List<String>.from(json['activities'] as List),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    final map = {
      'name': name,
      'description': description,
      'type': type,
      'image_url': imageUrl,
      'activities': activities,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };

    if (id != null) {
      map['id'] = id!;
    }

    return map;
  }

  CategoryItemModel copyWith({
    String? id,
    String? name,
    String? description,
    String? type,
    String? imageUrl,
    List<String>? activities,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      activities: activities ?? this.activities,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
