class VCardModel {
  final String? fullName;
  final String? firstName;
  final String? lastName;
  final List<String> phones;
  final List<String> emails;
  final String? organization;
  final String? title;
  final List<String> addresses;
  final List<String> websites;
  final String? note;

  VCardModel({
    this.fullName,
    this.firstName,
    this.lastName,
    required this.phones,
    required this.emails,
    this.organization,
    this.title,
    required this.addresses,
    required this.websites,
    this.note,
  });

  factory VCardModel.fromRaw(String raw) {
    // Normalize folded lines
    final normalized = raw
        .replaceAll(RegExp(r'\r\n|\r|\n'), '\n')
        .replaceAllMapped(RegExp(r'\n\s'), (_) => '');

    String? extractSingle(String key) {
      final match = RegExp(
        '^$key(?:;[^:]*)*:(.*)',
        caseSensitive: false,
        multiLine: true,
      ).firstMatch(normalized);
      return match?.group(1)?.trim();
    }

    List<String> extractAll(String key) {
      return RegExp(
            '^$key(?:;[^:]*)*:(.*)',
            caseSensitive: false,
            multiLine: true,
          )
          .allMatches(normalized)
          .map((match) => match.group(1)?.trim())
          .whereType<String>()
          .toList();
    }

    // String? extractAddress() {
    //   final match = RegExp(
    //     r'^ADR(?:;[^:]*)*:(.*)',
    //     caseSensitive: false,
    //     multiLine: true,
    //   ).firstMatch(normalized);
    //   if (match != null) {
    //     final parts = match
    //         .group(1)!
    //         .split(';')
    //         .where((p) => p.trim().isNotEmpty)
    //         .toList();
    //     return parts.join(', ');
    //   }
    //   return null;
    // }

    List<String> extractAllAddresses(String normalized) {
      final matches = RegExp(
        r'^ADR(?:;[^:]*)*:(.*)',
        caseSensitive: false,
        multiLine: true,
      ).allMatches(normalized);

      return matches.map((match) {
        final parts = match
            .group(1)!
            .split(';')
            .where((p) => p.trim().isNotEmpty)
            .toList();
        return parts.join(', ');
      }).toList();
    }

    // Handle structured name
    String? firstName;
    String? lastName;

    final nField = extractSingle('N');
    if (nField != null) {
      final parts = nField.split(';');
      lastName = parts.isNotEmpty ? parts[0].trim() : null;
      firstName = parts.length > 1 ? parts[1].trim() : null;
    }

    return VCardModel(
      fullName: extractSingle('FN'),
      firstName: firstName,
      lastName: lastName,
      phones: extractAll('TEL'),
      emails: extractAll('EMAIL'),
      organization: extractSingle('ORG'),
      title: extractSingle('TITLE'),
      addresses: extractAllAddresses(normalized),
      websites: extractAll('URL'),
      note: extractSingle('NOTE'),
    );
  }
}
