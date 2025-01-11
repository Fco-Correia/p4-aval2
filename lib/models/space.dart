class Space {
  String key;
  String nomeEspaco;
  int capacidade;
  int disponibilidade;
  String status;

  Space({
    required this.key,
    required this.nomeEspaco,
    required this.capacidade,
    required this.disponibilidade,
    required this.status,
  });

  String get disponibilidadeFormatada {
    return 'Disponibilidade: $disponibilidade horários disponíveis';
  }
}
