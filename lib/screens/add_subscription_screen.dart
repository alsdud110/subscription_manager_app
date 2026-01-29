import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../constants/colors.dart';
import '../models/subscription.dart';
import '../providers/subscription_provider.dart';
import '../providers/language_provider.dart';

class AddSubscriptionScreen extends StatefulWidget {
  const AddSubscriptionScreen({super.key});

  @override
  State<AddSubscriptionScreen> createState() => _AddSubscriptionScreenState();
}

class _AddSubscriptionScreenState extends State<AddSubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();

  String _serviceName = '';
  String _selectedIcon = '💳';
  double _amount = 0.0;
  Currency _currency = Currency.krw;
  BillingCycle _billingCycle = BillingCycle.monthly;
  int _dayOfWeek = 1;
  int _dayOfMonth = 1;
  int _month = 1;
  int _selectedColorValue = AppColors.subscriptionColors[0];

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
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.black : AppColors.white,
      appBar: _buildAppBar(context, isDark, languageProvider),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'S',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(languageProvider.tr('selectService'), isDark),
            const SizedBox(height: 12),
            _buildServiceChips(isDark, languageProvider),
            const SizedBox(height: 24),
            _buildSectionTitle(languageProvider.tr('selectColor'), isDark),
            const SizedBox(height: 12),
            _buildColorSelector(isDark),
            const SizedBox(height: 24),
            if (_serviceName == 'Custom') ...[
              _buildTextField(
                label: languageProvider.tr('customServiceName'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return languageProvider.tr('pleaseEnterServiceName');
                  }
                  return null;
                },
                onChanged: (value) => setState(() => _serviceName = value),
                isDark: isDark,
              ),
              const SizedBox(height: 24),
            ],
            _buildSectionTitle(languageProvider.tr('price'), isDark),
            const SizedBox(height: 12),
            _buildPriceRow(isDark, languageProvider),
            const SizedBox(height: 24),
            _buildSectionTitle(languageProvider.tr('billingCycle'), isDark),
            const SizedBox(height: 12),
            _buildBillingCycleSelector(isDark, languageProvider),
            const SizedBox(height: 20),
            _buildBillingCycleOptions(isDark, languageProvider),
            const SizedBox(height: 32),
            _buildSubmitButton(context, isDark, languageProvider),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    bool isDark,
    LanguageProvider languageProvider,
  ) {
    return AppBar(
      backgroundColor: isDark ? AppColors.black : AppColors.white,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: isDark ? AppColors.white : AppColors.black,
          size: 20,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        languageProvider.tr('addSubscription'),
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.white : AppColors.black,
          letterSpacing: -0.3,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.white : AppColors.black,
        letterSpacing: -0.2,
      ),
    );
  }

  Widget _buildServiceChips(bool isDark, LanguageProvider languageProvider) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _predefinedServices.length,
        itemBuilder: (context, index) {
          final service = _predefinedServices[index];
          final isSelected = _serviceName == service['name'];
          final displayName = service['name'] == 'Custom'
              ? languageProvider.tr('custom')
              : service['name']!;
          return GestureDetector(
            onTap: () {
              setState(() {
                _serviceName = service['name']!;
                _selectedIcon = service['icon']!;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.primaryGradient : null,
                color: isSelected
                    ? null
                    : (isDark ? AppColors.darkSurfaceContainer : AppColors.white),
                borderRadius: BorderRadius.circular(25),
                border: isSelected
                    ? null
                    : Border.all(
                        color: isDark
                            ? AppColors.darkOutline
                            : AppColors.mediumGray,
                        width: 1,
                      ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(service['icon']!, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Text(
                    displayName,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? AppColors.white : AppColors.black),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildColorSelector(bool isDark) {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: AppColors.subscriptionColors.length,
        itemBuilder: (context, index) {
          final colorValue = AppColors.subscriptionColors[index];
          final isSelected = _selectedColorValue == colorValue;
          return GestureDetector(
            onTap: () => setState(() => _selectedColorValue = colorValue),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Color(colorValue),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? (isDark ? AppColors.white : AppColors.black)
                      : Colors.transparent,
                  width: 2.5,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check_rounded, color: isDark ? AppColors.white : AppColors.white, size: 20)
                  : null,
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String? Function(String?) validator,
    required Function(String) onChanged,
    required bool isDark,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDark ? AppColors.gray : AppColors.gray,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: isDark ? AppColors.darkSurfaceContainer : AppColors.lightGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark
                ? AppColors.darkOutline
                : AppColors.mediumGray,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.white : AppColors.black,
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      style: TextStyle(
        color: isDark ? AppColors.white : AppColors.black,
        fontWeight: FontWeight.w500,
      ),
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
    );
  }

  Widget _buildPriceRow(bool isDark, LanguageProvider languageProvider) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildTextField(
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
            onChanged: (value) => _amount = double.tryParse(value) ?? 0.0,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceContainer : AppColors.lightGray,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SegmentedButton<Currency>(
              segments: const [
                ButtonSegment(value: Currency.krw, label: Text('₩')),
                ButtonSegment(value: Currency.usd, label: Text('\$')),
              ],
              selected: {_currency},
              onSelectionChanged: (Set<Currency> newSelection) {
                setState(() => _currency = newSelection.first);
              },
              showSelectedIcon: false,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return isDark ? AppColors.white : AppColors.black;
                  }
                  return Colors.transparent;
                }),
                foregroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return isDark ? AppColors.black : AppColors.white;
                  }
                  return isDark ? AppColors.white : AppColors.black;
                }),
                side: WidgetStateProperty.all(BorderSide.none),
                padding: WidgetStateProperty.all(EdgeInsets.zero),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBillingCycleSelector(bool isDark, LanguageProvider languageProvider) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceContainer : AppColors.lightGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SegmentedButton<BillingCycle>(
        segments: [
          ButtonSegment(
            value: BillingCycle.once,
            label: Text(languageProvider.tr('once')),
          ),
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
          setState(() => _billingCycle = newSelection.first);
        },
        showSelectedIcon: false,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return isDark ? AppColors.white : AppColors.black;
            }
            return Colors.transparent;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return isDark ? AppColors.black : AppColors.white;
            }
            return isDark ? AppColors.white : AppColors.black;
          }),
          side: WidgetStateProperty.all(BorderSide.none),
          padding: WidgetStateProperty.all(EdgeInsets.zero),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }

  Widget _buildBillingCycleOptions(bool isDark, LanguageProvider languageProvider) {
    switch (_billingCycle) {
      case BillingCycle.once:
        return Row(
          children: [
            Expanded(
              child: _buildDropdown(
                label: languageProvider.tr('month'),
                value: _month,
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
                onChanged: (value) => setState(() => _month = value!),
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDropdown(
                label: languageProvider.tr('day'),
                value: _dayOfMonth,
                items: List.generate(
                  31,
                  (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text('${index + 1}'),
                  ),
                ),
                onChanged: (value) => setState(() => _dayOfMonth = value!),
                isDark: isDark,
              ),
            ),
          ],
        );

      case BillingCycle.weekly:
        return _buildDropdown(
          label: languageProvider.tr('selectDayOfWeek'),
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
          onChanged: (value) => setState(() => _dayOfWeek = value!),
          isDark: isDark,
        );

      case BillingCycle.monthly:
        return _buildDropdown(
          label: languageProvider.tr('selectDayOfMonth'),
          value: _dayOfMonth,
          items: List.generate(
            31,
            (index) => DropdownMenuItem(
              value: index + 1,
              child: Text('${index + 1}'),
            ),
          ),
          onChanged: (value) => setState(() => _dayOfMonth = value!),
          isDark: isDark,
        );

      case BillingCycle.yearly:
        return Row(
          children: [
            Expanded(
              child: _buildDropdown(
                label: languageProvider.tr('month'),
                value: _month,
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
                onChanged: (value) => setState(() => _month = value!),
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDropdown(
                label: languageProvider.tr('day'),
                value: _dayOfMonth,
                items: List.generate(
                  31,
                  (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text('${index + 1}'),
                  ),
                ),
                onChanged: (value) => setState(() => _dayOfMonth = value!),
                isDark: isDark,
              ),
            ),
          ],
        );
    }
  }

  Widget _buildDropdown({
    required String label,
    required int value,
    required List<DropdownMenuItem<int>> items,
    required Function(int?) onChanged,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceContainer : AppColors.lightGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<int>(
        value: value,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          labelStyle: TextStyle(
            color: isDark ? AppColors.gray : AppColors.gray,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: TextStyle(
          color: isDark ? AppColors.white : AppColors.black,
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
        dropdownColor: isDark ? AppColors.darkSurfaceContainer : AppColors.white,
        items: items,
        onChanged: onChanged,
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: isDark ? AppColors.gray : AppColors.gray,
        ),
      ),
    );
  }

  Widget _buildSubmitButton(
    BuildContext context,
    bool isDark,
    LanguageProvider languageProvider,
  ) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        gradient: AppColors.buttonGradient,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.purple.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => _saveSubscription(languageProvider),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          languageProvider.tr('addSubscription'),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _saveSubscription(LanguageProvider languageProvider) {
    if (_formKey.currentState!.validate()) {
      if (_serviceName.isEmpty || _serviceName == 'Custom') {
        _showToast(context, languageProvider.tr('pleaseSelectService'));
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
        month: (_billingCycle == BillingCycle.yearly || _billingCycle == BillingCycle.once) ? _month : null,
        createdAt: DateTime.now(),
        colorValue: _selectedColorValue,
      );

      Provider.of<SubscriptionProvider>(context, listen: false)
          .addSubscription(subscription);

      _showToast(context, languageProvider.tr('subscriptionAdded'), isSuccess: true);

      Navigator.pop(context);
    }
  }

  void _showToast(BuildContext context, String message, {bool isSuccess = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fToast = FToast();
    fToast.init(context);

    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDark ? AppColors.white : AppColors.black,
      ),
      child: Text(
        message,
        style: TextStyle(
          color: isDark ? AppColors.black : AppColors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
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
