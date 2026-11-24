// ===========================================================================
// مفقوداتي - Campus Lost & Found
// lib/screens/add_item_screen.dart
// Owner: Member 3
// Description: Form screen to submit a new lost or found report. Includes a
//   segmented toggle (أنا فقدت / أنا لقيت), category chips, campus location
//   picker, description, and phone number. Submitting prepends the item to the
//   feed and updates all stats live.
// ===========================================================================

import 'package:flutter/material.dart';
import '../models/lost_item_model.dart';

/// Pre-defined campus locations for quick selection.
const List<String> kCampusLocations = [
  'مدرج 1',
  'مدرج 2',
  'مدرج 3',
  'المعامل - الدور الثاني',
  'معمل البرمجة',
  'المكتبة',
  'الكافيتريا الرئيسية',
  'المدخل الرئيسي',
  'مكتب شؤون الطلاب',
  'ساحة الكلية',
  'مكان آخر',
];

class AddItemScreen extends StatefulWidget {
  final AppState state;
  const AddItemScreen({super.key, required this.state});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLost = true; // true = أنا فقدت, false = أنا لقيت
  ItemCategory _selectedCategory = ItemCategory.idCard;
  String _selectedLocation = kCampusLocations.first;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitReport() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final newItem = LostItem(
      id: 'item_${DateTime.now().microsecondsSinceEpoch}',
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      location: _selectedLocation,
      category: _selectedCategory,
      contactPhone: _phoneController.text.trim(),
      reporterName: widget.state.userName.isNotEmpty
          ? widget.state.userName
          : 'مجهول',
      date: DateTime.now(),
      isLost: _isLost,
    );

    widget.state.addItem(newItem);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم إضافة البلاغ: "${newItem.title}"',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1E3A8A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'إضافة بلاغ جديد',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Color(0xFF0F172A),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            // ── Lost / Found Toggle ──────────────────────────────────────
            _buildToggleCard(),
            const SizedBox(height: 18),

            // ── Item Title ───────────────────────────────────────────────
            _sectionLabel('اسم الغرض'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              textCapitalization: TextCapitalization.sentences,
              decoration: _inputDec(
                hint: 'مثال: كارنيه جامعي، سماعة بلوتوث',
                icon: Icons.label_outline_rounded,
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'من فضلك أدخل اسم الغرض' : null,
            ),
            const SizedBox(height: 18),

            // ── Category ─────────────────────────────────────────────────
            _sectionLabel('التصنيف'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ItemCategory.values.map((cat) {
                final sel = _selectedCategory == cat;
                return ChoiceChip(
                  selected: sel,
                  showCheckmark: false,
                  onSelected: (_) => setState(() => _selectedCategory = cat),
                  avatar: Icon(
                    cat.icon,
                    size: 16,
                    color: sel ? Colors.white : cat.color,
                  ),
                  label: Text(cat.label),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                    color: sel ? Colors.white : const Color(0xFF0F172A),
                  ),
                  selectedColor: cat.color,
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: sel ? cat.color : const Color(0xFFE2E8F0),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),

            // ── Location ─────────────────────────────────────────────────
            _sectionLabel('المكان داخل الكلية'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<String>(
                    value: _selectedLocation,
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(14),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF64748B),
                    ),
                    items: kCampusLocations
                        .map(
                          (loc) => DropdownMenuItem(
                            value: loc,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on_rounded,
                                  size: 16,
                                  color: Color(0xFF1E3A8A),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  loc,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedLocation = val);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // ── Description ───────────────────────────────────────────────
            _sectionLabel('وصف إضافي'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descController,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              decoration: _inputDec(
                hint: 'مثال: اللون، علامات مميزة، الوقت التقريبي',
                icon: Icons.notes_rounded,
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'من فضلك أضف وصفاً مختصراً' : null,
            ),
            const SizedBox(height: 18),

            // ── Phone ─────────────────────────────────────────────────────
            _sectionLabel('رقم الهاتف للتواصل'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: _inputDec(
                hint: 'مثال: 01012345678',
                icon: Icons.phone_outlined,
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'من فضلك أدخل رقم الهاتف';
                if (v.trim().length < 10) return 'رقم الهاتف غير صحيح';
                return null;
              },
            ),
            const SizedBox(height: 28),

            // ── Submit ────────────────────────────────────────────────────
            ElevatedButton.icon(
              onPressed: _submitReport,
              icon: const Icon(Icons.send_rounded, size: 20),
              label: const Text('إرسال البلاغ'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: const Text(
              'نوع البلاغ',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          Row(
            children: [
              Expanded(
                child: _toggleOption(
                  label: 'أنا فقدت غرض',
                  icon: Icons.report_problem_rounded,
                  selected: _isLost,
                  selectedColor: const Color(0xFFDC2626),
                  selectedBg: const Color(0xFFFEE2E2),
                  onTap: () => setState(() => _isLost = true),
                  isFirst: true,
                ),
              ),
              Container(
                width: 1,
                height: 54,
                color: const Color(0xFFE2E8F0),
              ),
              Expanded(
                child: _toggleOption(
                  label: 'أنا لقيت غرض',
                  icon: Icons.check_circle_rounded,
                  selected: !_isLost,
                  selectedColor: const Color(0xFF16A34A),
                  selectedBg: const Color(0xFFDCFCE7),
                  onTap: () => setState(() => _isLost = false),
                  isFirst: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _toggleOption({
    required String label,
    required IconData icon,
    required bool selected,
    required Color selectedColor,
    required Color selectedBg,
    required VoidCallback onTap,
    required bool isFirst,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? selectedBg : Colors.transparent,
          borderRadius: BorderRadius.only(
            bottomRight: isFirst ? const Radius.circular(18) : Radius.zero,
            bottomLeft: !isFirst ? const Radius.circular(18) : Radius.zero,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 18, color: selected ? selectedColor : const Color(0xFF64748B)),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: selected ? selectedColor : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14.5,
        fontWeight: FontWeight.w700,
        color: Color(0xFF0F172A),
      ),
    );
  }

  InputDecoration _inputDec({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13.5),
      prefixIcon: Icon(icon, size: 20, color: const Color(0xFF64748B)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFDC2626)),
      ),
    );
  }
}
