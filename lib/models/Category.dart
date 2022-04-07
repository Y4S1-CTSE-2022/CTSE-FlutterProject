class Category {
  final String id;
  final String categoryName;
  final String description;

  Category(this.id, this.categoryName, this.description);

  factory Category.fromJson(dynamic json) {
    return Category(json['id'] as String, json['category'] as String, json['description'] as String);
  }

  @override
  String toString() {
    return '{ ${this.id}, ${this.categoryName}, ${this.description} }';
  }

}