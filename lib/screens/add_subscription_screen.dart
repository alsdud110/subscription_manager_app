import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../constants/colors.dart';
import '../models/subscription.dart';
import '../providers/subscription_provider.dart';

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

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildGlassmorphicAppBar(context, isDark),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    AppColors.darkSlate,
                    AppColors.charcoal,
                    const Color(0xFF1E1B4B),
                  ]
                : [
                    AppColors.softWhite,
                    AppColors.lightSurfaceContainer,
                    const Color(0xFFF5F3FF),
                  ],
          ),
        ),
        child: FadeTransition(
          opacity: _animationController,
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 100, 16, 32),
              children: [
                _buildSectionTitle('Select Service', isDark),
                const SizedBox(height: 16),
                _buildServiceChips(isDark),
                const SizedBox(height: 24),
                if (_serviceName == 'Custom') ...[
                  _buildGlassInput(
                    label: 'Custom Service Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter service name';
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
                _buildSectionTitle('Price', isDark),
                const SizedBox(height: 16),
                _buildPriceRow(isDark),
                const SizedBox(height: 24),
                _buildSectionTitle('Billing Cycle', isDark),
                const SizedBox(height: 16),
                _buildBillingCycleSegment(isDark),
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
                  child: _buildBillingCycleOptions(isDark),
                ),
                const SizedBox(height: 32),
                _buildGlowingButton(context, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildGlassmorphicAppBar(BuildContext context, bool isDark) {
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
        'Add Subscription',
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

  Widget _buildServiceChips(bool isDark) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _predefinedServices.map((service) {
        final isSelected = _serviceName == service['name'];
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
                        '${service['icon']} ${service['name']}',
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

  Widget _buildPriceRow(bool isDark) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildGlassInput(
            label: 'Amount',
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter amount';
              }
              if (double.tryParse(value) == null) {
                return 'Invalid amount';
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

  Widget _buildBillingCycleSegment(bool isDark) {
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
            segments: const [
              ButtonSegment(
                value: BillingCycle.weekly,
                label: Text('Weekly'),
              ),
              ButtonSegment(
                value: BillingCycle.monthly,
                label: Text('Monthly'),
              ),
              ButtonSegment(
                value: BillingCycle.yearly,
                label: Text('Yearly'),
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

  Widget _buildBillingCycleOptions(bool isDark) {
    switch (_billingCycle) {
      case BillingCycle.weekly:
        return Column(
          key: const ValueKey('weekly'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Select Day of Week', isDark),
            const SizedBox(height: 12),
            _buildGlassDropdown(
              value: _dayOfWeek,
              items: const [
                DropdownMenuItem(value: 1, child: Text('Monday')),
                DropdownMenuItem(value: 2, child: Text('Tuesday')),
                DropdownMenuItem(value: 3, child: Text('Wednesday')),
                DropdownMenuItem(value: 4, child: Text('Thursday')),
                DropdownMenuItem(value: 5, child: Text('Friday')),
                DropdownMenuItem(value: 6, child: Text('Saturday')),
                DropdownMenuItem(value: 7, child: Text('Sunday')),
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
            _buildSectionTitle('Select Day of Month', isDark),
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
            _buildSectionTitle('Select Month and Day', isDark),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildGlassDropdown(
                    value: _month,
                    label: 'Month',
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('January')),
                      DropdownMenuItem(value: 2, child: Text('February')),
                      DropdownMenuItem(value: 3, child: Text('March')),
                      DropdownMenuItem(value: 4, child: Text('April')),
                      DropdownMenuItem(value: 5, child: Text('May')),
                      DropdownMenuItem(value: 6, child: Text('June')),
                      DropdownMenuItem(value: 7, child: Text('July')),
                      DropdownMenuItem(value: 8, child: Text('August')),
                      DropdownMenuItem(value: 9, child: Text('September')),
                      DropdownMenuItem(value: 10, child: Text('October')),
                      DropdownMenuItem(value: 11, child: Text('November')),
                      DropdownMenuItem(value: 12, child: Text('December')),
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
                    label: 'Day',
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

  Widget _buildGlowingButton(BuildContext context, bool isDark) {
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
              onTap: _saveSubscription,
              borderRadius: BorderRadius.circular(28),
              child: const Center(
                child: Text(
                  'Add Subscription',
                  style: TextStyle(
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

  void _saveSubscription() {
    if (_formKey.currentState!.validate()) {
      if (_serviceName.isEmpty || _serviceName == 'Custom') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select or enter a service name')),
        );
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

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Subscription added successfully')),
      );
    }
  }
}
