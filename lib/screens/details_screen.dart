// ===========================================================================
// مفقوداتي - Campus Lost & Found
// lib/screens/details_screen.dart
// Owner: Member 4
// Description: Full item details view. Shows large category header, status
//   badge, reporter name, campus location card, full description, and a
//   contact phone box with a "نسخ الرقم" button (Clipboard). Bottom action
//   buttons: "تأكيد التسليم وإغلاق البلاغ" (mark resolved) and delete.
// ===========================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/lost_item_model.dart';

class DetailsScreen extends StatelessWidget {
  final AppState state;
  final String itemId;

  const DetailsScreen({
    super.key,
    required this.state,
    required this.itemId,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final item = state.itemById(itemId);

        // If item was deleted, pop back automatically.
        if (item == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (Navigator.of(context).canPop()) Navigator.of(context).pop();
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: CustomScrollView(
            slivers: [
              _buildSliverAppBar(context, item),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildStatusRow(item),
                    const SizedBox(height: 18),
                    _buildInfoCard(item),
                    const SizedBox(height: 14),
                    _buildDescriptionCard(item),
                    const SizedBox(height: 14),
                    _buildContactCard(context, item),
                  ]),
                ),
              ),
            ],
          ),
          bottomNavigationBar: _buildBottomBar(context, item),
        );
      },
    );
  }

  // ── Sliver AppBar with colored header ──────────────────────────────────────

  Widget _buildSliverAppBar(BuildContext context, LostItem item) {
    final cat = item.category;
    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      backgroundColor: cat.color,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [cat.color, cat.color.withValues(alpha: 0.75)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 72, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(cat.icon, color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Status Row ─────────────────────────────────────────────────────────────

  Widget _buildStatusRow(LostItem item) {
    Widget badge;
    if (item.isResolved) {
      badge = _statusBadge('تم التسليم', const Color(0xFFF59E0B),
          const Color(0xFFFEF3C7), Icons.handshake_rounded);
    } else if (item.isLost) {
      badge = _statusBadge('مفقود', const Color(0xFFDC2626),
          const Color(0xFFFEE2E2), Icons.report_problem_rounded);
    } else {
      badge = _statusBadge('تم العثور عليه', const Color(0xFF16A34A),
          const Color(0xFFDCFCE7), Icons.check_circle_rounded);
    }

    return Row(
      children: [
        badge,
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.category_rounded,
                size: 13,
                color: Color(0xFF64748B),
              ),
              const SizedBox(width: 4),
              Text(
                item.category.label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statusBadge(String text, Color fg, Color bg, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: fg),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }

  // ── Info Card ──────────────────────────────────────────────────────────────

  Widget _buildInfoCard(LostItem item) {
    final dateStr = _formatDate(item.date);
    return _DetailCard(
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.person_outline_rounded,
            label: 'المُبلِّغ',
            value: item.reporterName,
          ),
          const Divider(height: 20),
          _InfoRow(
            icon: Icons.location_on_rounded,
            label: 'المكان',
            value: item.location,
            valueColor: const Color(0xFF1E3A8A),
          ),
          const Divider(height: 20),
          _InfoRow(
            icon: Icons.access_time_rounded,
            label: 'تاريخ البلاغ',
            value: dateStr,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}  |  ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  // ── Description Card ───────────────────────────────────────────────────────

  Widget _buildDescriptionCard(LostItem item) {
    return _DetailCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.notes_rounded, size: 18, color: Color(0xFF64748B)),
              SizedBox(width: 8),
              Text(
                'الوصف',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            item.description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF334155),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  // ── Contact Card ───────────────────────────────────────────────────────────

  Widget _buildContactCard(BuildContext context, LostItem item) {
    return _DetailCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.phone_rounded, size: 18, color: Color(0xFF64748B)),
              SizedBox(width: 8),
              Text(
                'للتواصل',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Text(
                    item.contactPhone,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: item.contactPhone));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'تم نسخ رقم الهاتف!',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                        backgroundColor: const Color(0xFF0D9488),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.all(16),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.copy_rounded, size: 16),
                label: const Text('نسخ'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D9488),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Bottom Action Bar ──────────────────────────────────────────────────────

  Widget _buildBottomBar(BuildContext context, LostItem item) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: const Color(0xFFE2E8F0))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: item.isResolved
          ? Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF16A34A),
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'تم التسليم وإغلاق البلاغ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF16A34A),
                  ),
                ),
                const Spacer(),
                _deleteButton(context, item),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      state.resolveItem(item.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'تم تأكيد التسليم وإغلاق البلاغ ✓',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: const Color(0xFF16A34A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.all(16),
                        ),
                      );
                    },
                    icon: const Icon(Icons.handshake_rounded, size: 20),
                    label: const Text('تأكيد التسليم وإغلاق البلاغ'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                _deleteButton(context, item),
              ],
            ),
    );
  }

  Widget _deleteButton(BuildContext context, LostItem item) {
    return IconButton(
      tooltip: 'حذف البلاغ',
      style: IconButton.styleFrom(
        backgroundColor: const Color(0xFFFEE2E2),
        foregroundColor: const Color(0xFFDC2626),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: const Size(46, 46),
      ),
      icon: const Icon(Icons.delete_outline_rounded),
      onPressed: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text(
              'حذف البلاغ',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            content: const Text('هل أنت متأكد إنك تعوز تحذف البلاغ ده؟'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('حذف'),
              ),
            ],
          ),
        );
        if (confirmed == true && context.mounted) {
          state.deleteItem(item.id);
          Navigator.of(context).pop();
        }
      },
    );
  }
}

// ── Shared Widgets ────────────────────────────────────────────────────────────

class _DetailCard extends StatelessWidget {
  final Widget child;
  const _DetailCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
      child: child,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor = const Color(0xFF334155),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF64748B)),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF94A3B8),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: valueColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
