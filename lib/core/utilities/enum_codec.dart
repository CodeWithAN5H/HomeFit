import 'dart:convert';

/// JSON-encodes enum names for storage in a single text column.
///
/// Unknown names are dropped rather than throwing, so that a build which
/// removes or renames an option can still read older rows.
String encodeEnumList(Iterable<Enum> values) =>
    jsonEncode(values.map((value) => value.name).toList());

/// Returns the enum value whose name matches [raw], or null when it does not
/// match any known value (for example data written by a newer build).
T? matchEnum<T extends Enum>(List<T> values, Object? raw) {
  if (raw is! String) return null;
  for (final value in values) {
    if (value.name == raw) return value;
  }
  return null;
}

/// Decodes a JSON list of enum names, skipping anything unrecognised.
List<T> decodeEnumList<T extends Enum>(List<T> values, String? encoded) {
  if (encoded == null || encoded.isEmpty) return <T>[];
  final Object? decoded;
  try {
    decoded = jsonDecode(encoded);
  } on FormatException {
    return <T>[];
  }
  if (decoded is! List) return <T>[];
  final result = <T>[];
  for (final Object? item in decoded) {
    final match = matchEnum(values, item);
    if (match != null) result.add(match);
  }
  return result;
}
