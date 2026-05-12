class PromoBanner {
  final String id;
  final String imagemPath;
  final String? linkUrl; // Caso o banner leve para algum lugar especifico
  final double preco;

  PromoBanner({
    required this.id,
    required this.imagemPath,
    this.linkUrl,
    required this.preco,
  });

  factory PromoBanner.fromJson(Map<String, dynamic> json) {
    return PromoBanner(
      id: json['id'] ?? '',
      imagemPath: json['imagemPath'] ?? '',
      linkUrl: json['linkUrl'],
      preco: double.tryParse((json['preco'] ?? 0).toString()) ?? 0.0,
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
