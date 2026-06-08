extension UriExtension on String {
  String get removeWWW => toString().replaceAll(RegExp(r'www\.'), '');
  String get removeParams => toString().replaceAll(RegExp(r'\?.*$'), '');
  String get removeLastSlash => toString().replaceAll(RegExp(r'/$'), '');
}

abstract class UriHelper {
  /// Compara duas URIs ignorando `www.`, parâmetros de consulta e barra final.
  /// A comparação é feita por componentes (scheme, host, porta, segmentos do
  /// caminho) em vez de string bruta, evitando falsos negativos como porta
  /// default explícita (`:443` vs sem porta).
  static bool equals(Uri? a, Uri? b) {
    if (a == null || b == null) return false;

    final String aUrl = a.toString().removeWWW.removeParams.removeLastSlash;
    final String bUrl = b.toString().removeWWW.removeParams.removeLastSlash;

    final Uri aUri = Uri.parse(aUrl);
    final Uri bUri = Uri.parse(bUrl);

    // Compara scheme, host e porta (Uri.port já normaliza porta default).
    if (aUri.scheme != bUri.scheme) return false;
    if (aUri.host != bUri.host) return false;
    if (aUri.port != bUri.port) return false;

    // Compara segmentos do path ignorando segmentos vazios (ex: barras
    // duplicadas ou trailing slash já removido).
    final List<String> aSegments = aUri.pathSegments
        .where((s) => s.isNotEmpty)
        .toList();
    final List<String> bSegments = bUri.pathSegments
        .where((s) => s.isNotEmpty)
        .toList();

    if (aSegments.length != bSegments.length) return false;

    for (int i = 0; i < aSegments.length; i++) {
      if (aSegments[i] != bSegments[i]) return false;
    }

    return true;
  }

  /// Verifica se [a] é sub-rota de [b], isto é, se [b] começa com o mesmo
  /// caminho de [a] (comparação segmento por segmento).
  ///
  /// Exemplos:
  /// - `/product` é sub-rota de `/product/123` → `true`
  /// - `/product` NÃO é sub-rota de `/product-return-policy` → `false`
  /// - `/product` é sub-rota de `/product` → `true`
  static bool isSubRoute(Uri? a, Uri? b) {
    if (a == null || b == null) return false;

    final String aUrl = a.toString().removeWWW.removeParams.removeLastSlash;
    final String bUrl = b.toString().removeWWW.removeParams.removeLastSlash;

    final Uri aUri = Uri.parse(aUrl);
    final Uri bUri = Uri.parse(bUrl);

    // Esquema e autoridade (host + porta) precisam ser iguais.
    if (aUri.scheme != bUri.scheme || aUri.authority != bUri.authority) {
      return false;
    }

    final List<String> aSegments = aUri.pathSegments
        .where((s) => s.isNotEmpty)
        .toList();
    final List<String> bSegments = bUri.pathSegments
        .where((s) => s.isNotEmpty)
        .toList();

    // Se [a] tem mais segmentos que [b], não pode ser sub-rota.
    if (aSegments.length > bSegments.length) {
      return false;
    }

    // Compara segmento por segmento.
    for (int i = 0; i < aSegments.length; i++) {
      if (aSegments[i] != bSegments[i]) {
        return false;
      }
    }

    return true;
  }

  static bool isDirectSubRoute(Uri? a, Uri? b) {
    // https://uol.com.br
    // https://www.uol.com.br/esporte aceita
    // https://www.uol.com.br/esporte/futebol não aceita

    // https://www.uol.com.br/esporte/futebol/times/flamengo
    // https://www.uol.com.br/esporte/futebol/times/flamengo/feminino

    // https://www.uol.com.br/esporte/futebol/central-de-jogos
    // https://www.uol.com.br/esporte/futebol/central-de-jogos/feminino

    if (a == null || b == null) return false;

    final String aUrl = a.toString().removeWWW.removeParams.removeLastSlash;
    final String bUrl = b.toString().removeWWW.removeParams.removeLastSlash;

    final Uri aUri = Uri.parse(aUrl);
    final Uri bUri = Uri.parse(bUrl);

    // Esquema e autoridade (host + porta) precisam ser iguais.
    if (aUri.scheme != bUri.scheme || aUri.authority != bUri.authority) {
      return false;
    }

    final List<String> aSegments = aUri.pathSegments
        .where((s) => s.isNotEmpty)
        .toList();
    final List<String> bSegments = bUri.pathSegments
        .where((s) => s.isNotEmpty)
        .toList();

    if (bSegments.length != aSegments.length + 1) {
      return false;
    }

    // Compara segmento por segmento.
    for (int i = 0; i < aSegments.length; i++) {
      if (aSegments[i] != bSegments[i]) {
        return false;
      }
    }

    return true;
  }
}
