class AppConfig {
  static const String environment = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'dev',
  );
  static const String baseUrl = String.fromEnvironment(
    'BACKEND_URL',
    defaultValue: environment == 'dev'
        ? 'http://10.0.2.2:8080'
        : 'https://involt.infira.pe',
  );
  static const String appName = 'Hidroeléctrica Qarwaqiru Michay';
  static const String brandName = 'InVolt';
  static const String creditsName = 'INFIRA';
}
