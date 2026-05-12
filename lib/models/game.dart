class Game {
  final int id;
  final String titulo;
  final String categoria;
  final double preco;
  final String imagemPath;
  final bool disponivel;

  Game({
    required this.id,
    required this.titulo,
    required this.categoria,
    required this.preco,
    required this.imagemPath,
    this.disponivel = true,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['produto_id'] ?? json['id'] ?? 0,
      titulo: json['produto_nome'] ?? json['titulo'] ?? '',
      categoria: json['produto_categoria'] ?? json['categoria'] ?? 'Geral',
      preco: double.tryParse((json['produto_valor'] ?? json['preco'] ?? 0).toString()) ?? 0.0,
      imagemPath: json['produto_imagem'] ?? json['imagemPath'] ?? '',
      disponivel: json['produto_disponivel'] == 1 || json['produto_disponivel'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'produto_id': id,
      'produto_nome': titulo,
      'produto_categoria': categoria,
      'produto_valor': preco,
      'produto_imagem': imagemPath,
      'produto_disponivel': disponivel ? 1 : 0,
    };
  }
}
