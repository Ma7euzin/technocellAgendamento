class UnboardingContent {
  String image;
  String title;
  String description;
  UnboardingContent({
    required this.description,
    required this.image,
    required this.title,
  });
}

List<UnboardingContent> contents = [
  UnboardingContent(
    description: 'Bem vindo ao E.M Venda Livre\n o seu comercio local',
    image: 'assets/images/screen1.png',
    title: 'Selecione em nosso\n     Melhor Menu',
  ),
  UnboardingContent(
    description: 'Você pode Pagar com dinheiro na hora da entrega e\n o pagamento com Cartão esta disponível',
    image: 'assets/images/screen2.png',
    title: 'Pagamento Fácil e online',
  ),
  UnboardingContent(
    description: 'Entrega o pedido em sua porta',
    image: 'assets/images/screen3.png',
    title: 'Entrega rapida',
  ),
];
