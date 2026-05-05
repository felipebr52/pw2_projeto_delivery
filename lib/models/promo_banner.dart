class PromoBanner {
  final String id;
  final String imagemPath;
  final String? linkUrl; // Caso o banner leve para algum lugar especifico

  PromoBanner({
    required this.id,
    required this.imagemPath,
    this.linkUrl,
  });

  factory PromoBanner.fromJson(Map<String, dynamic> json) {
    return PromoBanner(
      id: json['id'].toString(),
      imagemPath: json['imagemPath'],
      linkUrl: json['linkUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagemPath': imagemPath,
      'linkUrl': linkUrl,
    };
  }
}
