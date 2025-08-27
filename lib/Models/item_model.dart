class Item {
  final int id;
  final String title;
  final String description;
  final String? imageUrl;
  final bool isFavorite;

  Item({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.isFavorite = false,
  });

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      imageUrl: map['image_url'],
      isFavorite: map['is_favorite'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'is_favorite': isFavorite ? 1 : 0,
    };
  }

  Item copyWith({
    int? id,
    String? title,
    String? description,
    String? imageUrl,
    bool? isFavorite,
  }) {
    return Item(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}