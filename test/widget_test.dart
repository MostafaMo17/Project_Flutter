import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_flutter/data/mock_items.dart';
import 'package:project_flutter/main.dart';
import 'package:project_flutter/models/lost_item_model.dart';

void main() {
  testWidgets('Mafqudati: login navigates to home and shows items', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MafqudatiApp());

    // Login screen
    expect(find.text('مفقوداتي'), findsWidgets);
    expect(find.text('دخول'), findsOneWidget);

    await tester.ensureVisible(find.text('دخول'));
    await tester.tap(find.text('دخول'));
    await tester.pumpAndSettle();

    // Should fail validation — both fields empty
    expect(find.text('دخول'), findsOneWidget);

    // Fill in name and code
    await tester.enterText(
      find.widgetWithText(TextFormField, 'مثال: أحمد محمد'),
      'أحمد سامي',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'مثال: 20210001 أو ahmed@fci.edu'),
      '20210123',
    );
    await tester.ensureVisible(find.text('دخول'));
    await tester.tap(find.text('دخول'));
    await tester.pumpAndSettle();

    // Home screen
    expect(find.text('مفقوداتي'), findsWidgets);
    expect(find.text('إضافة بلاغ'), findsOneWidget);
    expect(find.text('رحلة الساحل'), findsNothing); // old app gone
  });

  test('AppState: addItem prepends and stats update correctly', () {
    final state = MockItems.createInitialState();
    final initialLost = state.lostCount;
    final initialResolved = state.resolvedCount;

    state.addItem(
      LostItem(
        id: 'test_1',
        title: 'محفظة بنية',
        description: 'محفظة صغيرة',
        location: 'المكتبة',
        category: ItemCategory.other,
        contactPhone: '01099999999',
        reporterName: 'تست',
        date: DateTime.now(),
        isLost: true,
      ),
    );

    expect(state.lostCount, initialLost + 1);
    expect(state.items.first.title, 'محفظة بنية');

    state.resolveItem('test_1');
    expect(state.lostCount, initialLost);
    expect(state.resolvedCount, initialResolved + 1);

    state.deleteItem('test_1');
    expect(state.items.where((i) => i.id == 'test_1').isEmpty, true);
  });

  test('AppState: filteredItems works for query, category, and tab', () {
    final state = MockItems.createInitialState();

    final byQuery = state.filteredItems(
      query: 'كارنيه',
      category: null,
      tab: 0,
    );
    expect(byQuery.isNotEmpty, true);
    expect(byQuery.first.title.contains('كارنيه'), true);

    final byCategory = state.filteredItems(
      query: '',
      category: ItemCategory.electronics,
      tab: 0,
    );
    expect(
      byCategory.every((i) => i.category == ItemCategory.electronics),
      true,
    );

    final lostOnly = state.filteredItems(query: '', category: null, tab: 1);
    expect(lostOnly.every((i) => i.isLost), true);
  });
}
