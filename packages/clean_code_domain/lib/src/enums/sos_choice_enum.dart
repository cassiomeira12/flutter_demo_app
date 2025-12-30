// ignore_for_file: constant_identifier_names

enum SosChoiceEnum {
  POLICY_ONLY(1),
  SAFETY_CONTACTS_ONLY(2),
  ALL(3);

  final int code;

  const SosChoiceEnum(this.code);
}
