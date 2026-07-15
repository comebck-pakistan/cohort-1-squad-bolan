import 'package:flutter_test/flutter_test.dart';
import 'package:hisaabai_mobile/core/config/app_config.dart';

void main() {
  test('has a default API base URL', () {
    expect(AppConfig.apiBaseUrl, isNotEmpty);
  });
}
