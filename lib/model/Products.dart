class Products {
  String? name;
  String? description;
  String? category;
  String? price;
  List<String?>? images;
  List<String>? favouriteBy;
  String? userId;

  Products({
    this.name,
    this.description,
    this.category,
    this.price,
    this.images,
    this.favouriteBy,
    this.userId,
  });

  // map to json
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'images': images,
      'favouritedBy':favouriteBy,
      'userId': userId,
    };
  }
}
