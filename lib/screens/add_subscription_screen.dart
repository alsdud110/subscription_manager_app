import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui';
import '../constants/colors.dart';
import '../models/subscription.dart';
import '../providers/subscription_provider.dart';
import '../providers/language_provider.dart';

class AddSubscriptionScreen extends StatefulWidget {
  const AddSubscriptionScreen({super.key});

  @override
  State<AddSubscriptionScreen> createState() => _AddSubscriptionScreenState();
}

class _AddSubscriptionScreenState extends State<AddSubscriptionScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  String _serviceName = '';
  String _selectedIcon = '💳';
  double _amount = 0.0;
  Currency _currency = Currency.krw;
  BillingCycle _billingCycle = BillingCycle.monthly;
  int _dayOfWeek = 1;
  int _dayOfMonth = 1;
  int _month = 1;
  bool _isButtonPressed = false;

  late AnimationController _animationController;

  final List<Map<String, String>> _predefinedServices = [
    {'name': 'Netflix', 'icon': '🎬'},
    {'name': 'Coupang', 'icon': '🛒'},
    {'name': 'YouTube Premium', 'icon': '▶️'},
    {'name': 'Disney+', 'icon': '🏰'},
    {'name': 'Spotify', 'icon': '🎵'},
    {'name': 'Apple Music', 'icon': '🎶'},
    {'name': 'Amazon Prime', 'icon': '📦'},
    {'name': 'Watcha', 'icon': '🎞️'},
    {'name': 'Wavve', 'icon': '📺'},
    {'name': 'Tving', 'icon': '🎭'},
    {'name': 'Custom', 'icon': '💳'},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildGlassmorphicAppBar(context, isDark, languageProvider),
      body: Container(
        color: isDark ? Colors.black : Colors.white,
        child: FadeTransition(
          opacity: _animationController,
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 100, 16, 32),
              children: [
                _buildSectionTitle(languageProvider.tr('selectService'), isDark),
                const SizedBox(height: 16),
                _buildServiceChips(isDark, languageProvider),
                const SizedBox(height: 24),
                if (_serviceName == 'Custom') ...[
                  _buildGlassInput(
                    label: languageProvider.tr('customServiceName'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return languageProvider.tr('pleaseEnterServiceName');
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _serviceName = value;
                      });
                    },
                    isDark: isDark,
                  ),
                  const SizedBox(height: 24),
                ],
                _buildSectionTitle(languageProvider.tr('price'), isDark),
                const SizedBox(height: 16),
                _buildPriceRow(isDark, languageProvider),
                const SizedBox(height: 24),
                _buildSectionTitle(languageProvider.tr('billingCycle'), isDark),
                const SizedBox(height: 16),
                _buildBillingCycleSegment(isDark, languageProvider),
                const SizedBox(height: 24),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.1),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: _buildBillingCycleOptions(isDark, languageProvider),
                ),
                const SizedBox(height: 32),
                _buildGlowingButton(context, isDark, languageProvider),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildGlassmorphicAppBar(
    BuildContext context,
    bool isDark,
    LanguageProvider languageProvider,
  ) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.white.withOpacity(0.3),
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ),
      title: Text(
        languageProvider.tr('addSubscription'),
        style: TextStyle(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildServiceChips(bool isDark, LanguageProvider languageProvider) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _predefinedServices.map((service) {
        final isSelected = _serviceName == service['name'];
        final displayName = service['name'] == 'Custom'
            ? languageProvider.tr('custom')
            : service['name']!;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: Matrix4.identity()..scale(isSelected ? 1.05 : 1.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark
                          ? AppColors.darkPrimary.withOpacity(0.15)
                          : AppColors.primary.withOpacity(0.15))
                      : (isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.white.withOpacity(0.6)),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected
                        ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                        : Colors.grey.withOpacity(isDark ? 0.2 : 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: (isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.primary)
                                .withOpacity(0.3),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ]
                      : [],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _serviceName = service['name']!;
                        _selectedIcon = service['icon']!;
                      });
                    },
                    borderRadius: BorderRadius.circular(24),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text(
                        '${service['icon']} $displayName',
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGlassInput({
    required String label,
    required String? Function(String?) validator,
    required Function(String) onChanged,
    required bool isDark,
    TextInputType? keyboardType,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(isDark ? 0.1 : 0.3),
              width: 1.5,
            ),
          ),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: label,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(20),
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
            keyboardType: keyboardType,
            validator: validator,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(bool isDark, LanguageProvider languageProvider) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildGlassInput(
            label: languageProvider.tr('amount'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return languageProvider.tr('pleaseEnterAmount');
              }
              if (double.tryParse(value) == null) {
                return languageProvider.tr('invalidAmount');
              }
              return null;
            },
            onChanged: (value) {
              _amount = double.tryParse(value) ?? 0.0;
            },
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(isDark ? 0.1 : 0.3),
                      width: 1.5,
                    ),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: SegmentedButton<Currency>(
                    segments: const [
                      ButtonSegment(
                        value: Currency.krw,
                        label: Text('₩'),
                      ),
                      ButtonSegment(
                        value: Currency.usd,
                        label: Text('\$'),
                      ),
                    ],
                    selected: {_currency},
                    onSelectionChanged: (Set<Currency> newSelection) {
                      setState(() {
                        _currency = newSelection.first;
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return Theme.of(context).colorScheme.primary;
                        }
                        return Colors.transparent;
                      }),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBillingCycleSegment(bool isDark, LanguageProvider languageProvider) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(isDark ? 0.1 : 0.3),
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.all(4),
          child: SegmentedButton<BillingCycle>(
            segments: [
              ButtonSegment(
                value: BillingCycle.weekly,
                label: Text(languageProvider.tr('weekly')),
              ),
              ButtonSegment(
                value: BillingCycle.monthly,
                label: Text(languageProvider.tr('monthly')),
              ),
              ButtonSegment(
                value: BillingCycle.yearly,
                label: Text(languageProvider.tr('yearly')),
              ),
            ],
            selected: {_billingCycle},
            onSelectionChanged: (Set<BillingCycle> newSelection) {
              setState(() {
                _billingCycle = newSelection.first;
              });
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Theme.of(context).colorScheme.primary;
                }
                return Colors.transparent;
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBillingCycleOptions(bool isDark, LanguageProvider languageProvider) {
    switch (_billingCycle) {
      case BillingCycle.weekly:
        return Column(
          key: const ValueKey('weekly'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(languageProvider.tr('selectDayOfWeek'), isDark),
            const SizedBox(height: 12),
            _buildGlassDropdown(
              value: _dayOfWeek,
              items: [
                DropdownMenuItem(value: 1, child: Text(languageProvider.tr('monday'))),
                DropdownMenuItem(value: 2, child: Text(languageProvider.tr('tuesday'))),
                DropdownMenuItem(value: 3, child: Text(languageProvider.tr('wednesday'))),
                DropdownMenuItem(value: 4, child: Text(languageProvider.tr('thursday'))),
                DropdownMenuItem(value: 5, child: Text(languageProvider.tr('friday'))),
                DropdownMenuItem(value: 6, child: Text(languageProvider.tr('saturday'))),
                DropdownMenuItem(value: 7, child: Text(languageProvider.tr('sunday'))),
              ],
              onChanged: (value) {
                setState(() {
                  _dayOfWeek = value!;
                });
              },
              isDark: isDark,
            ),
          ],
        );

      case BillingCycle.monthly:
        return Column(
          key: const ValueKey('monthly'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(languageProvider.tr('selectDayOfMonth'), isDark),
            const SizedBox(height: 12),
            _buildGlassDropdown(
              value: _dayOfMonth,
              items: List.generate(
                31,
                (index) => DropdownMenuItem(
                  value: index + 1,
                  child: Text('${index + 1}'),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _dayOfMonth = value!;
                });
              },
              isDark: isDark,
            ),
          ],
        );

      case BillingCycle.yearly:
        return Column(
          key: const ValueKey('yearly'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(languageProvider.tr('selectMonthAndDay'), isDark),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildGlassDropdown(
                    value: _month,
                    label: languageProvider.tr('month'),
                    items: [
                      DropdownMenuItem(value: 1, child: Text(languageProvider.tr('january'))),
                      DropdownMenuItem(value: 2, child: Text(languageProvider.tr('february'))),
                      DropdownMenuItem(value: 3, child: Text(languageProvider.tr('march'))),
                      DropdownMenuItem(value: 4, child: Text(languageProvider.tr('april'))),
                      DropdownMenuItem(value: 5, child: Text(languageProvider.tr('may'))),
                      DropdownMenuItem(value: 6, child: Text(languageProvider.tr('june'))),
                      DropdownMenuItem(value: 7, child: Text(languageProvider.tr('july'))),
                      DropdownMenuItem(value: 8, child: Text(languageProvider.tr('august'))),
                      DropdownMenuItem(value: 9, child: Text(languageProvider.tr('september'))),
                      DropdownMenuItem(value: 10, child: Text(languageProvider.tr('october'))),
                      DropdownMenuItem(value: 11, child: Text(languageProvider.tr('november'))),
                      DropdownMenuItem(value: 12, child: Text(languageProvider.tr('december'))),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _month = value!;
                      });
                    },
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildGlassDropdown(
                    value: _dayOfMonth,
                    label: languageProvider.tr('day'),
                    items: List.generate(
                      31,
                      (index) => DropdownMenuItem(
                        value: index + 1,
                        child: Text('${index + 1}'),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _dayOfMonth = value!;
                      });
                    },
                    isDark: isDark,
                  ),
                ),
              ],
            ),
          ],
        );
    }
  }

  Widget _buildGlassDropdown({
    required int value,
    String? label,
    required List<DropdownMenuItem<int>> items,
    required Function(int?) onChanged,
    required bool isDark,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(isDark ? 0.1 : 0.3),
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButtonFormField<int>(
            value: value,
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: label,
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
            dropdownColor: isDark ? AppColors.darkSlate : Colors.white,
            items: items,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  Widget _buildGlowingButton(BuildContext context, bool isDark, LanguageProvider languageProvider) {
    return AnimatedScale(
      scale: _isButtonPressed ? 0.95 : 1.0,
      duration: const Duration(milliseconds: 100),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isButtonPressed = true),
        onTapUp: (_) => setState(() => _isButtonPressed = false),
        onTapCancel: () => setState(() => _isButtonPressed = false),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [AppColors.darkPrimary, AppColors.secondary]
                  : [AppColors.primary, AppColors.secondary],
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: (isDark ? AppColors.darkPrimary : AppColors.primary)
                    .withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _saveSubscription(languageProvider),
              borderRadius: BorderRadius.circular(28),
              child: Center(
                child: Text(
                  languageProvider.tr('addSubscription'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveSubscription(LanguageProvider languageProvider) {
    if (_formKey.currentState!.validate()) {
      if (_serviceName.isEmpty || _serviceName == 'Custom') {
        _showCustomToast(context, languageProvider.tr('pleaseSelectService'));
        return;
      }

      final subscription = Subscription(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        serviceName: _serviceName,
        serviceIcon: _selectedIcon,
        amount: _amount,
        currency: _currency,
        billingCycle: _billingCycle,
        dayOfWeek: _billingCycle == BillingCycle.weekly ? _dayOfWeek : null,
        dayOfMonth: _billingCycle != BillingCycle.weekly ? _dayOfMonth : null,
        month: _billingCycle == BillingCycle.yearly ? _month : null,
        createdAt: DateTime.now(),
      );

      Provider.of<SubscriptionProvider>(context, listen: false)
          .addSubscription(subscription);

      _showCustomToast(context, languageProvider.tr('subscriptionAdded'), isSuccess: true);

      Navigator.pop(context);
    }
  }

  void _showCustomToast(BuildContext context, String message, {bool isSuccess = false}) {
    final fToast = FToast();
    fToast.init(context);

    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: isSuccess ? Colors.green : Colors.black87,
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }
}
