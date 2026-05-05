class CartItem {
  final String titulo;
  final String imagemPath;
  final double preco;
  int quantidade;

  CartItem({
    required this.titulo,
    required this.imagemPath,
    required this.preco,
    this.quantidade = 1,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      titulo: json['titulo'],
      imagemPath: json['imagemPath'],
      preco: json['preco'].toDouble(),
      quantidade: json['quantidade'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'imagemPath': imagemPath,
      'preco': preco,
      'quantidade': quantidade,
    };
  }
}
