class Space {
  String key;
  String nomeEspaco;
  int capacidade;
  int disponibilidade;
  String status;
  Map<String, bool> horarios;

  Space({
    required this.key,
    required this.nomeEspaco,
    required this.capacidade,
    required this.disponibilidade,
    required this.status,
    required this.horarios,
  });

  String get disponibilidadeFormatada {
    return 'Disponibilidade: $disponibilidade horários disponíveis';
  }
}

