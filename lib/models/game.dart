class Game {
  final String titulo;
  final String categoria;
  final double preco;
  final String imagemPath;

  Game({
    required this.titulo,
    required this.categoria,
    required this.preco,
    required this.imagemPath,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      titulo: json['titulo'],
      categoria: json['categoria'],
      preco: json['preco'].toDouble(),
      imagemPath: json['imagemPath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'categoria': categoria,
      'preco': preco,
      'imagemPath': imagemPath,
    };
  }
}
