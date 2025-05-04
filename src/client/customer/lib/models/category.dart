class Category {
  final int categoryId;
  final String name;
  final String catImage;

  Category({
    required this.categoryId,
    required this.name,
    required this.catImage,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['category_id'] is int
          ? json['category_id']
          : int.tryParse(json['category_id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? 'Unnamed',
      catImage: json['cat_image']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'name': name,
      'cat_image': catImage,
    };
  }
}
