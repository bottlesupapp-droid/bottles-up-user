class Country {
  final String name;
  final String code;
  final String phoneCode;

  const Country({
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

/// The countries the sign-up and profile forms offer for a phone number's dialling code. The first is the default for a number typed with no code.
const supportedCountries = <Country>[
  Country(name: 'Canada', code: 'CA', phoneCode: '+1'),
  Country(name: 'United States', code: 'US', phoneCode: '+1'),
  Country(name: 'United Kingdom', code: 'GB', phoneCode: '+44'),
  Country(name: 'Australia', code: 'AU', phoneCode: '+61'),
  Country(name: 'India', code: 'IN', phoneCode: '+91'),
  Country(name: 'Germany', code: 'DE', phoneCode: '+49'),
  Country(name: 'France', code: 'FR', phoneCode: '+33'),
  Country(name: 'Japan', code: 'JP', phoneCode: '+81'),
  Country(name: 'Singapore', code: 'SG', phoneCode: '+65'),
];
