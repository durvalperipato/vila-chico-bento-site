import 'package:flutter_test/flutter_test.dart';
import 'package:vila_chico_bento_site/main.dart';

void main() {
  testWidgets('VilaChicoBentoApp inicializa com sucesso', (WidgetTester tester) async {
    await tester.pumpWidget(const VilaChicoBentoApp());
    expect(find.byType(VilaChicoBentoApp), findsOneWidget);
  });
}
