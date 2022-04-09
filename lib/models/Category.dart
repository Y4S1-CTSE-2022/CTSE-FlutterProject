class Category {
  final String id;
  final String category;
  final String description;
  final String image;

  Category(this.id, this.category, this.description, this.image);

  // factory Category.fromJson(dynamic json) {
  //   return Category(json['id'] as String, json['category'] as String, json['description'] as String, json['image'] as String);
  // }
  //
  // @override
  // String toString() {
  //   return '{ ${this.id}, ${this.category}, ${this.description} }';
  // }

}