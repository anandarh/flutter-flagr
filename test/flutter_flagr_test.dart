import 'package:flutter_flagr/flutter_flagr.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Flagr.init("hallo");

  test('getPlatformVersion', () async {
    expect(Flagr.instance.url, 'hallo');
  });
}
