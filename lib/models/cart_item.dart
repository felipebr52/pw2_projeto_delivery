class CartItem {
  final int id; // ID do produto real
  final String titulo;
  final String imagemPath;
  final double preco;
  int quantidade;

  CartItem({
    required this.id,
    required this.titulo,
    required this.imagemPath,
    required this.preco,
    this.quantidade = 1,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? 0,
      titulo: json['titulo'],
      imagemPath: json['imagemPath'],
      preco: double.tryParse((json['preco'] ?? 0).toString()) ?? 0.0,
      quantidade: json['quantidade'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'imagemPath': imagemPath,
      'preco': preco,
      'quantidade': quantidade,
    };
  }
}
