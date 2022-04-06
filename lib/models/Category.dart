class Category {
  final String id;
  final String categoryName;

  Category(this.id, this.categoryName);

  factory Category.fromJson(dynamic json) {
    return Category(json['id'] as String, json['category'] as String);
  }

  @override
  String toString() {
    return '{ ${this.id}, ${this.categoryName} }';
  }
}