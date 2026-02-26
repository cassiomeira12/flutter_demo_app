class CheckHourPointEntity {
  final String objectId;
  final bool manual;
  final String? valor;

  CheckHourPointEntity({
    required this.objectId,
    required this.manual,
    required this.valor,
  });

  int get hour {
    if (valor == null) return 0;
    if (valor!.split(':').isEmpty) return 0;
    return int.tryParse(valor!.split(':').first) ?? 0;
  }

  int get minute {
    if (valor == null) return 0;
    if (valor!.split(':').isEmpty) return 0;
    return int.tryParse(valor!.split(':').last) ?? 0;
  }
}
