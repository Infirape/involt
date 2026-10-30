import 'app_config.dart';

/// Brand shown in the app: the company of the logged-in user, or InVolt by default.
class Brand {
  const Brand({required this.name, this.entity = ''});

  /// InVolt, used before login and for users without a company.
  static const fallback = Brand(name: AppConfig.brandName);

  /// Builds the brand from the company saved at login (blank values mean no company).
  factory Brand.fromCompany({String? name, String? entity}) {
    final trimmed = name?.trim() ?? '';
    if (trimmed.isEmpty) return fallback;
    return Brand(name: trimmed, entity: entity?.trim() ?? '');
  }

  final String name;

  /// Organisation behind the company (e.g. a municipality); may be empty.
  final String entity;

  bool get isDefault => name == AppConfig.brandName && entity.isEmpty;
}
