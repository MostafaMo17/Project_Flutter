import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'location': location,
    'category': category.name,
    'contactPhone': contactPhone,
    'reporterName': reporterName,
    'date': date.toIso8601String(),
    'isLost': isLost,
    'isResolved': isResolved,
  };

  factory LostItem.fromJson(Map<String, dynamic> json) => LostItem(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    location: json['location'] as String,
    category: ItemCategory.values.firstWhere(
      (category) => category.name == json['category'],
      orElse: () => ItemCategory.other,
    ),
    contactPhone: json['contactPhone'] as String,
    reporterName: json['reporterName'] as String,
    date: DateTime.parse(json['date'] as String),
    isLost: json['isLost'] as bool,
    isResolved: json['isResolved'] as bool? ?? false,
  );
}

/// Reactive in-memory application state using ChangeNotifier.
/// Holds the item list, current user, and all mutation methods.
class AppState extends ChangeNotifier {
  static const _storageKey = 'mafqoudati_items_v1';
  static const _userNameKey = 'mafqoudati_current_user_name_v1';
  static const _userIdKey = 'mafqoudati_current_user_id_v1';
  String _currentUserName = '';
  String _currentUserId = '';
  final List<LostItem> _items;
  final List<LostItem> _initialItems;

  AppState({required List<LostItem> initialItems})
    : _items = List<LostItem>.from(initialItems),
      _initialItems = List<LostItem>.from(initialItems);

  Future<void> restoreItems() async {
    final preferences = await SharedPreferences.getInstance();
    final encodedItems = preferences.getString(_storageKey);
    if (encodedItems == null) {
      await _persistItems();
      return;
    }
    try {
      final decoded = jsonDecode(encodedItems) as List<dynamic>;
      _items
        ..clear()
        ..addAll(
          decoded.map(
            (item) => LostItem.fromJson(item as Map<String, dynamic>),
          ),
        );
      notifyListeners();
    } on FormatException {
      await _restoreInitialItems();
    } on TypeError {
      await _restoreInitialItems();
    }
  }

  Future<void> _persistItems() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _storageKey,
      jsonEncode(_items.map((item) => item.toJson()).toList()),
    );
  }

  Future<void> _restoreInitialItems() async {
    _items
      ..clear()
      ..addAll(_initialItems);
    await _persistItems();
    notifyListeners();
  }

  String get currentUserName => _currentUserName;
  String get currentUserId => _currentUserId;
  List<LostItem> get items => List.unmodifiable(_items);

  int get lostCount => _items.where((i) => i.isLost && !i.isResolved).length;
  int get foundCount => _items.where((i) => !i.isLost && !i.isResolved).length;
  int get resolvedCount => _items.where((i) => i.isResolved).length;

  Future<void> restoreUserSession() async {
    final preferences = await SharedPreferences.getInstance();
    _currentUserName = preferences.getString(_userNameKey) ?? '';
    _currentUserId = preferences.getString(_userIdKey) ?? '';
    notifyListeners();
  }

  Future<void> login(String name, String id) async {
    _currentUserName = name.trim();
    _currentUserId = id.trim();
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_userNameKey, _currentUserName);
    await preferences.setString(_userIdKey, _currentUserId);
    notifyListeners();
  }

  Future<void> logout() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_userNameKey);
    await preferences.remove(_userIdKey);
    _currentUserName = '';
    _currentUserId = '';
    notifyListeners();
  }

  Future<void> addItem(LostItem item) async {
    _items.insert(0, item);
    await _persistItems();
    notifyListeners();
  }

  Future<void> resolveItem(String id) async {
    final index = _items.indexWhere((i) => i.id == id);
    if (index == -1) return;
    _items[index] = _items[index].copyWith(isResolved: true);
    await _persistItems();
    notifyListeners();
  }

  Future<void> deleteItem(String id) async {
    _items.removeWhere((i) => i.id == id);
    await _persistItems();
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
      final matchesQuery =
          q.isEmpty ||
          item.title.toLowerCase().contains(q) ||
          item.location.toLowerCase().contains(q) ||
          item.description.toLowerCase().contains(q);

      final matchesCategory = category == null || item.category == category;

      final matchesTab =
          tab == 0 || (tab == 1 && item.isLost) || (tab == 2 && !item.isLost);

      return matchesQuery && matchesCategory && matchesTab;
    }).toList();
  }
}
