// ===========================================================================
// مفقوداتي - Campus Lost & Found
// lib/models/lost_item_model.dart
// Owner: Team Lead / All Members (shared data model)
// Description: Defines the LostItem data model, category enum with icon &
//   color helpers, and the reactive in-memory AppState using ChangeNotifier.
// ===========================================================================

import 'package:flutter/material.dart';

/// Categories for lost/found items on campus.
enum ItemCategory {
  idCard(
    label: 'بطاقات جامعية',
    icon: Icons.badge_rounded,
    color: Color(0xFF1E3A8A),
    softColor: Color(0xFFEFF6FF),
  ),
  electronics(
    label: 'إلكترونيات',
    icon: Icons.devices_rounded,
    color: Color(0xFF7C3AED),
    softColor: Color(0xFFF5F3FF),
  ),
  keys(
    label: 'مفاتيح',
    icon: Icons.vpn_key_rounded,
    color: Color(0xFFF59E0B),
    softColor: Color(0xFFFEF3C7),
  ),
  bagAndBooks(
    label: 'شنط وكتب',
    icon: Icons.menu_book_rounded,
    color: Color(0xFF0D9488),
    softColor: Color(0xFFF0FDFA),
  ),
  other(
    label: 'أخرى',
    icon: Icons.category_rounded,
    color: Color(0xFF64748B),
    softColor: Color(0xFFF1F5F9),
  );

  final String label;
  final IconData icon;
  final Color color;
  final Color softColor;

  const ItemCategory({
    required this.label,
    required this.icon,
    required this.color,
    required this.softColor,
  });
}

/// A single lost or found item report.
class LostItem {
  final String id;
  final String title;
  final String description;
  final String location;
  final ItemCategory category;
  final String contactPhone;
  final String reporterName;
  final DateTime date;

  /// true = مفقود (lost), false = تم العثور عليه (found by someone)
  final bool isLost;

  /// true = تم التسليم (resolved/handed in)
  final bool isResolved;

  const LostItem({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.category,
    required this.contactPhone,
    required this.reporterName,
    required this.date,
    required this.isLost,
    this.isResolved = false,
  });

  LostItem copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    ItemCategory? category,
    String? contactPhone,
    String? reporterName,
    DateTime? date,
    bool? isLost,
    bool? isResolved,
  }) {
    return LostItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      category: category ?? this.category,
      contactPhone: contactPhone ?? this.contactPhone,
      reporterName: reporterName ?? this.reporterName,
      date: date ?? this.date,
      isLost: isLost ?? this.isLost,
      isResolved: isResolved ?? this.isResolved,
    );
  }
}

/// Reactive in-memory application state using ChangeNotifier.
/// Holds the item list, current user, and all mutation methods.
class AppState extends ChangeNotifier {
  String _userName = '';
  String _userCode = '';
  final List<LostItem> _items;

  AppState({
    required List<LostItem> initialItems,
  }) : _items = List<LostItem>.from(initialItems);

  String get userName => _userName;
  String get userCode => _userCode;
  List<LostItem> get items => List.unmodifiable(_items);

  int get lostCount => _items.where((i) => i.isLost && !i.isResolved).length;
  int get foundCount => _items.where((i) => !i.isLost && !i.isResolved).length;
  int get resolvedCount => _items.where((i) => i.isResolved).length;

  void setUser({required String name, required String code}) {
    _userName = name.trim();
    _userCode = code.trim();
    notifyListeners();
  }

  void addItem(LostItem item) {
    _items.insert(0, item);
    notifyListeners();
  }

  void resolveItem(String id) {
    final index = _items.indexWhere((i) => i.id == id);
    if (index == -1) return;
    _items[index] = _items[index].copyWith(isResolved: true);
    notifyListeners();
  }

  void deleteItem(String id) {
    _items.removeWhere((i) => i.id == id);
    notifyListeners();
  }

  LostItem? itemById(String id) {
    for (final item in _items) {
      if (item.id == id) return item;
    }
    return null;
  }

  /// Returns items filtered by search query, category, and status tab.
  /// [tab]: 0 = all, 1 = lost only, 2 = found only
  List<LostItem> filteredItems({
    required String query,
    required ItemCategory? category,
    required int tab,
  }) {
    return _items.where((item) {
      final q = query.trim().toLowerCase();
      final matchesQuery = q.isEmpty ||
          item.title.toLowerCase().contains(q) ||
          item.location.toLowerCase().contains(q) ||
          item.description.toLowerCase().contains(q);

      final matchesCategory = category == null || item.category == category;

      final matchesTab = tab == 0 ||
          (tab == 1 && item.isLost) ||
          (tab == 2 && !item.isLost);

      return matchesQuery && matchesCategory && matchesTab;
    }).toList();
  }
}
