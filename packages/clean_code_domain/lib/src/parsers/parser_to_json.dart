abstract class ParserToJson {
  Map<String, dynamic> toMap();

  @override
  String toString() => toMap().toString();
}
