import 'package:flutter_test/flutter_test.dart';
import 'package:mobility_plus/app/app.dart';

void main() {
  testWidgets('aplicativo apresenta a marca Mobility+', (tester) async {
    await tester.pumpWidget(const MobilityPlusApp());
    await tester.pump(const Duration(milliseconds: 1200));
    expect(find.text('Mobility+'), findsWidgets);
  });
}
