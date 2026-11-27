import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_flutter/data/mock_items.dart';
import 'package:project_flutter/main.dart';
import 'package:project_flutter/models/lost_item_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  testWidgets('Mafqudati: login navigates to home and shows items', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MafqudatiApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Login screen
    expect(find.text('مفقوداتي'), findsWidgets);
    expect(find.text('دخول'), findsOneWidget);

    await tester.ensureVisible(find.text('دخول'));
    await tester.tap(find.text('دخول'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

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
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Home screen
    expect(find.text('مفقوداتي'), findsWidgets);
    expect(find.text('إضافة بلاغ'), findsOneWidget);
    expect(find.text('رحلة الساحل'), findsNothing); // old app gone
  });

  testWidgets('logout returns to LoginScreen and clears navigation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MafqudatiApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Ahmed Samy');
    await tester.enterText(fields.at(1), '20210123');
    await tester.tap(find.text('دخول'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byTooltip('تسجيل الخروج'), findsOneWidget);
    await tester.tap(find.byTooltip('تسجيل الخروج'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.text('تسجيل الخروج').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('دخول'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
  });

  test('AppState: addItem prepends and stats update correctly', () async {
    final state = MockItems.createInitialState();
    final initialLost = state.lostCount;
    final initialResolved = state.resolvedCount;

    await state.addItem(
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

    await state.resolveItem('test_1');
    expect(state.lostCount, initialLost);
    expect(state.resolvedCount, initialResolved + 1);

    await state.deleteItem('test_1');
    expect(state.items.where((i) => i.id == 'test_1').isEmpty, true);
  });

  test('AppState: items persist and restore from local storage', () async {
    final original = MockItems.createInitialState();
    await original.addItem(
      LostItem(
        id: 'saved_item',
        title: '\u0645\u0641\u062a\u0627\u062d \u0645\u062d\u0641\u0648\u0638',
        description: '\u0645\u0641\u062a\u0627\u062d \u0628\u062c\u0648\u0627\u0631 \u0627\u0644\u0645\u0639\u0645\u0644',
        location: '\u0627\u0644\u0645\u0639\u0645\u0644',
        category: ItemCategory.keys,
        contactPhone: '01012345678',
        reporterName: '\u0637\u0627\u0644\u0628',
        date: DateTime(2026, 1, 1),
        isLost: false,
      ),
    );

    final restored = MockItems.createInitialState();
    await restored.restoreItems();
    expect(restored.items.first.id, 'saved_item');
    expect(restored.items.first.category, ItemCategory.keys);
    expect(restored.items.first.date, DateTime(2026, 1, 1));
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
