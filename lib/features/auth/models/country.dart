class Country {
  final String name;
  final String code;
  final String phoneCode;

  Country({
    required this.name,
    required this.code,
    required this.phoneCode,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Country &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => '$name ($code)';
} 