import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../constants/colors.dart';
import '../constants/services.dart';
import '../models/subscription.dart';
import '../providers/subscription_provider.dart';
import '../providers/language_provider.dart';

class AddSubscriptionScreen extends StatefulWidget {
  final ServiceInfo? selectedService;

  const AddSubscriptionScreen({super.key, this.selectedService});

  @override
  State<AddSubscriptionScreen> createState() => _AddSubscriptionScreenState();
}

class _AddSubscriptionScreenState extends State<AddSubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _serviceNameController = TextEditingController();
  final _amountController = TextEditingController();

  late int _selectedColorValue;
  Currency _currency = Currency.krw;
  BillingCycle _billingCycle = BillingCycle.monthly;
  int _dayOfWeek = 1;
  int _dayOfMonth = 1;
  int _month = 1;
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  bool _hasEndDate = false;

  @override
  void initState() {
    super.initState();
    if (widget.selectedService != null) {
      _serviceNameController.text = widget.selectedService!.name;
      _selectedColorValue = widget.selectedService!.defaultColor;
    } else {
      _selectedColorValue = AppColors.subscriptionColors[0];
    }
  }

  @override
  void dispose() {
    _serviceNameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

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
            _buildServiceHeader(isDark),
            const SizedBox(height: 24),
            if (widget.selectedService == null) ...[
              _buildSectionTitle(languageProvider.tr('serviceName'), isDark),
              const SizedBox(height: 12),
              _buildServiceNameField(isDark, languageProvider),
              const SizedBox(height: 24),
            ],
            _buildSectionTitle(languageProvider.tr('selectColor'), isDark),
            const SizedBox(height: 12),
            _buildColorSelector(isDark),
            const SizedBox(height: 24),
            _buildSectionTitle(languageProvider.tr('price'), isDark),
            const SizedBox(height: 12),
            _buildPriceRow(isDark, languageProvider),
            const SizedBox(height: 24),
            _buildSectionTitle(languageProvider.tr('startDate'), isDark),
            const SizedBox(height: 12),
            _buildDateSelector(
              isDark,
              languageProvider,
              _startDate,
              (date) => setState(() => _startDate = date),
            ),
            const SizedBox(height: 24),
            _buildEndDateSection(isDark, languageProvider),
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

  Widget _buildServiceHeader(bool isDark) {
    final service = widget.selectedService;
    return Center(
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Color(_selectedColorValue).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Text(
                service != null ? service.name[0].toUpperCase() : '?',
                style: TextStyle(
                  color: Color(_selectedColorValue),
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
            ),
          ),
          if (service != null) ...[
            const SizedBox(height: 12),
            Text(
              service.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
          ],
        ],
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

  Widget _buildServiceNameField(bool isDark, LanguageProvider languageProvider) {
    return TextFormField(
      controller: _serviceNameController,
      decoration: InputDecoration(
        hintText: languageProvider.tr('enterServiceName'),
        hintStyle: TextStyle(
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
            color: isDark ? AppColors.darkOutline : AppColors.mediumGray,
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return languageProvider.tr('pleaseEnterServiceName');
        }
        return null;
      },
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
                  ? const Icon(Icons.check_rounded, color: AppColors.white, size: 20)
                  : null,
            ),
          );
        },
      ),
    );
  }

  Widget _buildPriceRow(bool isDark, LanguageProvider languageProvider) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextFormField(
            controller: _amountController,
            decoration: InputDecoration(
              hintText: languageProvider.tr('amount'),
              hintStyle: TextStyle(
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
                  color: isDark ? AppColors.darkOutline : AppColors.mediumGray,
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

  Widget _buildDateSelector(
    bool isDark,
    LanguageProvider languageProvider,
    DateTime selectedDate,
    Function(DateTime) onDateChanged,
  ) {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: isDark
                    ? const ColorScheme.dark(
                        primary: AppColors.purple,
                        surface: AppColors.darkSurfaceContainer,
                      )
                    : const ColorScheme.light(
                        primary: AppColors.purple,
                        surface: AppColors.white,
                      ),
              ),
              child: child!,
            );
          },
        );
        if (date != null) {
          onDateChanged(date);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurfaceContainer : AppColors.lightGray,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.darkOutline : AppColors.mediumGray,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 20,
              color: isDark ? AppColors.gray : AppColors.gray,
            ),
            const SizedBox(width: 12),
            Text(
              _formatDate(selectedDate, languageProvider),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date, LanguageProvider languageProvider) {
    if (languageProvider.isKorean) {
      return '${date.year}년 ${date.month}월 ${date.day}일';
    }
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Widget _buildEndDateSection(bool isDark, LanguageProvider languageProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildSectionTitle(languageProvider.tr('endDate'), isDark),
            const SizedBox(width: 8),
            Text(
              '(${languageProvider.tr('optional')})',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.gray : AppColors.gray,
              ),
            ),
            const Spacer(),
            Switch(
              value: _hasEndDate,
              onChanged: (value) {
                setState(() {
                  _hasEndDate = value;
                  if (value && _endDate == null) {
                    _endDate = _startDate.add(const Duration(days: 365));
                  }
                });
              },
              activeTrackColor: AppColors.purple,
              activeThumbColor: AppColors.white,
            ),
          ],
        ),
        if (_hasEndDate) ...[
          const SizedBox(height: 12),
          _buildDateSelector(
            isDark,
            languageProvider,
            _endDate ?? DateTime.now(),
            (date) => setState(() => _endDate = date),
          ),
        ],
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
      final serviceName = _serviceNameController.text.trim();
      if (serviceName.isEmpty) {
        _showToast(context, languageProvider.tr('pleaseEnterServiceName'));
        return;
      }

      final amount = double.tryParse(_amountController.text) ?? 0.0;

      final subscription = Subscription(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        serviceName: serviceName,
        serviceIcon: serviceName[0].toUpperCase(),
        amount: amount,
        currency: _currency,
        billingCycle: _billingCycle,
        dayOfWeek: _billingCycle == BillingCycle.weekly ? _dayOfWeek : null,
        dayOfMonth: _billingCycle != BillingCycle.weekly ? _dayOfMonth : null,
        month: (_billingCycle == BillingCycle.yearly || _billingCycle == BillingCycle.once) ? _month : null,
        createdAt: DateTime.now(),
        colorValue: _selectedColorValue,
        startDate: _startDate,
        endDate: _hasEndDate ? _endDate : null,
      );

      Provider.of<SubscriptionProvider>(context, listen: false)
          .addSubscription(subscription);

      _showToast(context, languageProvider.tr('subscriptionAdded'), isSuccess: true);

      // Pop twice to go back to home (past service selection screen)
      Navigator.of(context).popUntil((route) => route.isFirst);
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
