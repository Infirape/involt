import 'package:flutter_test/flutter_test.dart';
import 'package:involt/core/config/app_config.dart';
import 'package:involt/core/config/brand.dart';

void main() {
  test('uses the company name and entity', () {
    final brand = Brand.fromCompany(
      name: ' Acme Energía ',
      entity: 'Municipalidad Acme',
    );
    expect(brand.name, 'Acme Energía');
    expect(brand.entity, 'Municipalidad Acme');
    expect(brand.isDefault, isFalse);
  });

  test('is InVolt without a company', () {
    for (final name in [null, '', '   ']) {
      final brand = Brand.fromCompany(name: name, entity: 'x');
      expect(brand.name, AppConfig.brandName);
      expect(brand.isDefault, isTrue);
    }
  });
}
