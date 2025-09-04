class Product {
  final int id;
  final int categoryId;
  final String name;
  final List<String> images; // artık tek resim yerine liste
  final double price;
  final String description;

  Product({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.images,
    required this.price,
    required this.description,
  });
  List<String> get descriptionLines => description.split('\n');

  factory Product.fromJson(Map<String, dynamic> json) {
    List<String> imagesList = [];
    if (json['images'] != null) {
      imagesList = List<String>.from(json['images']);
    } else if (json['image'] != null) {
      imagesList = [json['image']];
    }

    return Product(
      id: int.parse(json['id']),
      categoryId: int.parse(json['category_id']),
      name: json['name'],
      images: imagesList,
      price: double.parse(json['price']),
      description: json['description'],
    );
  }
}
