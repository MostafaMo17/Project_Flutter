import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../page_transitions.dart';
import '../models/lost_item_model.dart';
import '../widgets/bouncy_tap.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  final AppState state;
  const LoginScreen({super.key, required this.state});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  late final AnimationController _orbController;

  @override
  void initState() {
    super.initState();
    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _orbController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await widget.state.login(_nameController.text, _codeController.text);
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushReplacement(buildAnimatedPageRoute(HomeScreen(state: widget.state)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 410,
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(56),
                ),
              ),
              child: AnimatedBuilder(
                animation: _orbController,
                builder: (context, _) {
                  final phase = _orbController.value;
                  return Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      Positioned(
                        top: 35 + 18 * phase,
                        right: -28,
                        child: _lightOrb(170, 0.09),
                      ),
                      Positioned(
                        top: 210 - 22 * phase,
                        left: -34,
                        child: _lightOrb(142, 0.08),
                      ),
                      Positioned(
                        top: 125 + 12 * phase,
                        right: 105,
                        child: _lightOrb(54, 0.12),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),
                      _buildHeroCard(),
                      const SizedBox(height: 8),
                      Transform.translate(
                        offset: const Offset(0, -22),
                        child: _buildFormCard(),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _lightOrb(double size, double opacity) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white.withValues(alpha: opacity),
      boxShadow: [
        BoxShadow(
          color: AppColors.teal.withValues(alpha: opacity * 0.7),
          blurRadius: size * 0.55,
          spreadRadius: size * 0.08,
        ),
      ],
    ),
  );

  Widget _buildHeroCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 14, 8, 38),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.teal.withValues(alpha: 0.24),
                      blurRadius: 22,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.account_balance_rounded,
                  color: Colors.white,
                  size: 29,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'مفقوداتي',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Campus Lost & Found',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.82),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'فقدت أو لقيت حاجة؟\nخلّينا نساعدك!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'منصة الجامعة لبلاغات المفقودات والموجودات داخل الحرم الجامعي.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.88),
              fontSize: 13.5,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
        boxShadow: const [AppColors.cardShadow],
      ),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'أهلاً، سجّل دخولك',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'بياناتك بتنظهر مع كل بلاغ تقدر تتواصل فيه',
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: _inputDecoration(
                label: 'الاسم بالكامل',
                hint: 'مثال: أحمد محمد',
                icon: Icons.person_outline_rounded,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'يرجى إدخال الاسم بالكامل';
                }
                if (!RegExp(r'^[\u0600-\u06FFa-zA-Z\s]+$').hasMatch(value)) {
                  return 'الاسم يجب أن يحتوي على حروف فقط';
                }
                if (value.trim().split(RegExp(r'\s+')).length < 2) {
                  return 'يرجى إدخال الاسم الثنائي على الأقل';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _codeController,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _handleLogin(),
              decoration: _inputDecoration(
                label: 'الكود الجامعي أو البريد الإلكتروني',
                hint: 'مثال: 20210001 أو ahmed@fci.edu',
                icon: Icons.school_outlined,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'يرجى إدخال الكود الجامعي أو البريد الإلكتروني';
                }
                final input = value.trim();
                final isUniversityId = RegExp(r'^\d{6,14}$').hasMatch(input);
                final isEmail = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$')
                    .hasMatch(input);
                if (!isUniversityId && !isEmail) {
                  return 'أدخل كود جامعي صحيح (6-14 رقم) أو بريد إلكتروني صحيح';
                }
                return null;
              },
            ),
            const SizedBox(height: 22),
            BouncyTap(
              onTap: _handleLogin,
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [AppColors.cardShadow],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: null,
                    borderRadius: BorderRadius.circular(16),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          'دخول',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow() {
    return Row(
      children: const [
        Expanded(
          child: _InfoPill(
            icon: Icons.lock_outline_rounded,
            label: 'بيانات آمنة',
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _InfoPill(icon: Icons.school_rounded, label: 'داخل الجامعة'),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _InfoPill(
            icon: Icons.volunteer_activism_rounded,
            label: 'مجاني تماماً',
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, size: 20),
      filled: true,
      fillColor: AppColors.canvas,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
      labelStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.indigo, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFDC2626)),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.indigo, size: 20),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}
