import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../constants/colors.dart';
import '../constants/services.dart';
import '../models/subscription.dart';
import '../providers/subscription_provider.dart';
import '../providers/language_provider.dart';
import '../widgets/banner_ad_widget.dart';

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

  // 스크롤 컨트롤러
  final ScrollController _dayScrollController = ScrollController();
  final ScrollController _weekdayScrollController = ScrollController();
  final ScrollController _monthScrollController = ScrollController();

  late int _selectedColorValue;
  Currency _currency = Currency.krw;
  BillingCycle _billingCycle = BillingCycle.monthly;
  late int _dayOfWeek;
  late int _dayOfMonth;
  late int _month;
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  bool _hasStartDate = false;
  bool _hasEndDate = false;
  bool _billingCycleSelected = false;

  bool _initialScrollDone = false;

  @override
  void initState() {
    super.initState();
    if (widget.selectedService != null) {
      _serviceNameController.text = widget.selectedService!.name;
      _selectedColorValue = widget.selectedService!.defaultColor;
    } else {
      _selectedColorValue = AppColors.subscriptionColors[0];
    }
    // 결제 주기 옵션 첫 번째 값으로 초기화
    _dayOfMonth = 1;
    _month = 1;
    _dayOfWeek = 1; // 월요일
  }

  void _onStartDateChanged(DateTime date) {
    setState(() {
      _startDate = date;
    });
  }

  void _onBillingCycleChanged(BillingCycle cycle) {
    setState(() {
      _billingCycle = cycle;
      _billingCycleSelected = true;
    });
    // 결제 주기에 따라 해당 스크롤러로 스크롤
    switch (cycle) {
      case BillingCycle.weekly:
        _scrollToSelectedWeekday();
        break;
      case BillingCycle.monthly:
        _scrollToSelectedDay();
        break;
      case BillingCycle.yearly:
      case BillingCycle.once:
        _scrollToSelectedMonth();
        _scrollToSelectedDay();
        break;
    }
  }

  @override
  void dispose() {
    _serviceNameController.dispose();
    _amountController.dispose();
    _dayScrollController.dispose();
    _weekdayScrollController.dispose();
    _monthScrollController.dispose();
    super.dispose();
  }

  // 선택된 항목으로 스크롤 애니메이션
  void _scrollToSelectedDay() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_dayScrollController.hasClients) {
        final itemWidth = 54.0; // 46 + 8 margin
        final screenWidth = MediaQuery.of(context).size.width;
        final targetOffset = ((_dayOfMonth - 1) * itemWidth) - (screenWidth / 2) + (itemWidth / 2) + 4;
        _dayScrollController.animateTo(
          targetOffset.clamp(0.0, _dayScrollController.position.maxScrollExtent),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  void _scrollToSelectedWeekday() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_weekdayScrollController.hasClients) {
        final itemWidth = 70.0; // 요일 아이템 평균 너비
        final screenWidth = MediaQuery.of(context).size.width;
        final targetOffset = ((_dayOfWeek - 1) * itemWidth) - (screenWidth / 2) + (itemWidth / 2) + 4;
        _weekdayScrollController.animateTo(
          targetOffset.clamp(0.0, _weekdayScrollController.position.maxScrollExtent),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  void _scrollToSelectedMonth() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_monthScrollController.hasClients) {
        final itemWidth = 70.0; // 월 아이템 평균 너비
        final screenWidth = MediaQuery.of(context).size.width;
        final targetOffset = ((_month - 1) * itemWidth) - (screenWidth / 2) + (itemWidth / 2) + 4;
        _monthScrollController.animateTo(
          targetOffset.clamp(0.0, _monthScrollController.position.maxScrollExtent),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.black : AppColors.white,
      appBar: _buildAppBar(context, isDark, languageProvider),
      bottomNavigationBar: const BannerAdWidget(),
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
              _buildSectionTitle(languageProvider.tr('selectColor'), isDark),
              const SizedBox(height: 12),
              _buildColorSelector(isDark),
              const SizedBox(height: 24),
            ],
            _buildSectionTitle(languageProvider.tr('price'), isDark),
            const SizedBox(height: 12),
            _buildPriceRow(isDark, languageProvider),
            const SizedBox(height: 24),
            Row(
              children: [
                _buildSectionTitle(languageProvider.tr('billingCycle'), isDark),
                if (!_billingCycleSelected) ...[
                  const SizedBox(width: 8),
                  Text(
                    '- ${languageProvider.tr('selectBillingCycle')}',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.purple,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            _buildBillingCycleSelector(isDark, languageProvider),
            // 결제 주기 선택 후 결제일 옵션만 fade in
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _billingCycleSelected ? 1.0 : 0.0,
                child: _billingCycleSelected
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          _buildBillingCycleOptions(isDark, languageProvider),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: 24),
            _buildStartDateSection(isDark, languageProvider),
            const SizedBox(height: 24),
            _buildEndDateSection(isDark, languageProvider),
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
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceContainer : AppColors.lightGray,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? AppColors.white : AppColors.black,
            size: 16,
          ),
        ),
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
    final hasIcon = service?.iconPath != null;
    return Center(
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: hasIcon
                  ? Colors.transparent
                  : Color(_selectedColorValue).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(18),
            ),
            child: hasIcon
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      service!.iconPath!,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                    ),
                  )
                : Center(
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

  Widget _buildServiceNameField(
      bool isDark, LanguageProvider languageProvider) {
    return TextFormField(
      controller: _serviceNameController,
      decoration: InputDecoration(
        hintText: languageProvider.tr('enterServiceName'),
        hintStyle: TextStyle(
          color: isDark ? AppColors.gray : AppColors.gray,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor:
            isDark ? AppColors.darkSurfaceContainer : AppColors.lightGray,
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                  ? const Icon(Icons.check_rounded,
                      color: AppColors.white, size: 20)
                  : null,
            ),
          );
        },
      ),
    );
  }

  Widget _buildPriceRow(bool isDark, LanguageProvider languageProvider) {
    final currencySymbol = _currency == Currency.krw ? '₩' : '\$';

    return TextFormField(
      controller: _amountController,
      decoration: InputDecoration(
        hintText: languageProvider.tr('amount'),
        hintStyle: TextStyle(
          color: isDark ? AppColors.gray : AppColors.gray,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            currencySymbol,
            style: TextStyle(
              color: isDark ? AppColors.white : AppColors.black,
              fontWeight: FontWeight.w600,
              fontSize: 18,
              fontFamily: 'Roboto',
            ),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 32, minHeight: 0),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 1,
              height: 24,
              color: isDark ? AppColors.darkOutline : AppColors.mediumGray,
            ),
            const SizedBox(width: 8),
            DropdownButtonHideUnderline(
              child: DropdownButton<Currency>(
                value: _currency,
                isDense: true,
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: isDark ? AppColors.white : AppColors.black,
                  size: 18,
                ),
                dropdownColor:
                    isDark ? AppColors.darkSurfaceContainer : AppColors.white,
                style: TextStyle(
                  color: isDark ? AppColors.white : AppColors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                borderRadius: BorderRadius.circular(12),
                items: [
                  DropdownMenuItem(
                    value: Currency.krw,
                    child: Row(
                      children: [
                        Text(
                          '₩',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.white : AppColors.black,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(languageProvider.tr('won')),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: Currency.usd,
                    child: Row(
                      children: [
                        Text(
                          '\$',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.white : AppColors.black,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(languageProvider.tr('dollar')),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _currency = value);
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
        suffixIconConstraints: const BoxConstraints(minWidth: 90),
        filled: true,
        fillColor:
            isDark ? AppColors.darkSurfaceContainer : AppColors.lightGray,
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      style: TextStyle(
        color: isDark ? AppColors.white : AppColors.black,
        fontWeight: FontWeight.w500,
        fontSize: 16,
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
    );
  }

  Widget _buildDateSelector(
    bool isDark,
    LanguageProvider languageProvider,
    DateTime selectedDate,
    Function(DateTime) onDateChanged,
  ) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        _showCupertinoDatePicker(
          isDark,
          selectedDate,
          onDateChanged,
        );
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

  void _showCupertinoDatePicker(
    bool isDark,
    DateTime initialDate,
    Function(DateTime) onDateChanged,
  ) {
    DateTime tempDate = initialDate;

    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 300,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurfaceContainer : AppColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // 상단 바 (완료 버튼)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color:
                        isDark ? AppColors.darkOutline : AppColors.mediumGray,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      '취소',
                      style: TextStyle(
                        color: isDark ? AppColors.gray : AppColors.gray,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      onDateChanged(tempDate);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      '완료',
                      style: TextStyle(
                        color: AppColors.purple,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 날짜 선택기
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: initialDate,
                minimumDate: DateTime(2020),
                maximumDate: DateTime(2100),
                onDateTimeChanged: (date) {
                  tempDate = date;
                },
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
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Widget _buildStartDateSection(bool isDark, LanguageProvider languageProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildSectionTitle(languageProvider.tr('startDate'), isDark),
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
              value: _hasStartDate,
              onChanged: (value) {
                setState(() {
                  _hasStartDate = value;
                });
              },
              activeTrackColor: AppColors.purple,
              activeThumbColor: AppColors.white,
            ),
          ],
        ),
        if (_hasStartDate) ...[
          const SizedBox(height: 12),
          _buildDateSelector(
            isDark,
            languageProvider,
            _startDate,
            _onStartDateChanged,
          ),
        ],
      ],
    );
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

  Widget _buildBillingCycleSelector(
      bool isDark, LanguageProvider languageProvider) {
    final cycles = [
      (BillingCycle.monthly, languageProvider.tr('monthly')),
      (BillingCycle.yearly, languageProvider.tr('yearly')),
      (BillingCycle.weekly, languageProvider.tr('weekly')),
      (BillingCycle.once, languageProvider.tr('once')),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: cycles.map((cycle) {
        final isSelected = _billingCycleSelected && _billingCycle == cycle.$1;
        return GestureDetector(
          onTap: () => _onBillingCycleChanged(cycle.$1),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? (isDark ? AppColors.white : AppColors.black)
                  : (isDark
                      ? AppColors.darkSurfaceContainer
                      : AppColors.lightGray),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? Colors.transparent
                    : (isDark ? AppColors.darkOutline : AppColors.mediumGray),
                width: 1,
              ),
            ),
            child: Text(
              cycle.$2,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? (isDark ? AppColors.black : AppColors.white)
                    : (isDark ? AppColors.white : AppColors.black),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBillingCycleOptions(
      bool isDark, LanguageProvider languageProvider) {
    switch (_billingCycle) {
      case BillingCycle.once:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMonthSelector(isDark, languageProvider),
            const SizedBox(height: 16),
            _buildSectionTitle(languageProvider.tr('day'), isDark),
            const SizedBox(height: 12),
            _buildDayGrid(isDark, languageProvider),
          ],
        );

      case BillingCycle.weekly:
        return _buildWeekdaySelector(isDark, languageProvider);

      case BillingCycle.monthly:
        return _buildDayGrid(isDark, languageProvider);

      case BillingCycle.yearly:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMonthSelector(isDark, languageProvider),
            const SizedBox(height: 16),
            _buildSectionTitle(languageProvider.tr('day'), isDark),
            const SizedBox(height: 12),
            _buildDayGrid(isDark, languageProvider),
          ],
        );
    }
  }

  Widget _buildMonthSelector(bool isDark, LanguageProvider languageProvider) {
    final months = [
      (1, languageProvider.tr('january')),
      (2, languageProvider.tr('february')),
      (3, languageProvider.tr('march')),
      (4, languageProvider.tr('april')),
      (5, languageProvider.tr('may')),
      (6, languageProvider.tr('june')),
      (7, languageProvider.tr('july')),
      (8, languageProvider.tr('august')),
      (9, languageProvider.tr('september')),
      (10, languageProvider.tr('october')),
      (11, languageProvider.tr('november')),
      (12, languageProvider.tr('december')),
    ];

    // 초기 스크롤 위치 설정
    if (!_initialScrollDone) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelectedMonth();
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(languageProvider.tr('month'), isDark),
        const SizedBox(height: 12),
        SizedBox(
          height: 54, // 다른 선택기들과 높이 통일
          child: ListView.builder(
            controller: _monthScrollController,
            scrollDirection: Axis.horizontal,
            itemCount: months.length,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemBuilder: (context, index) {
              final month = months[index];
              final isSelected = _month == month.$1;

              return GestureDetector(
                onTap: () => setState(() => _month = month.$1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDark ? AppColors.white : AppColors.black)
                        : (isDark
                            ? AppColors.darkSurfaceContainer
                            : AppColors.lightGray),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: (isDark ? Colors.white : Colors.black)
                                  .withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ]
                        : [],
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : (isDark
                              ? AppColors.darkOutline
                              : AppColors.mediumGray),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          month.$2,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected
                                ? (isDark ? AppColors.black : AppColors.white)
                                : (isDark ? AppColors.white : AppColors.black),
                          ),
                        ),
                        if (isSelected)
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.black : AppColors.white,
                              shape: BoxShape.circle,
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWeekdaySelector(bool isDark, LanguageProvider languageProvider) {
    final weekdays = [
      (1, languageProvider.tr('monday')),
      (2, languageProvider.tr('tuesday')),
      (3, languageProvider.tr('wednesday')),
      (4, languageProvider.tr('thursday')),
      (5, languageProvider.tr('friday')),
      (6, languageProvider.tr('saturday')),
      (7, languageProvider.tr('sunday')),
    ];

    // 초기 스크롤 위치 설정
    if (!_initialScrollDone) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelectedWeekday();
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 54, // 날짜 선택기와 높이 통일
          child: ListView.builder(
            controller: _weekdayScrollController,
            scrollDirection: Axis.horizontal,
            itemCount: weekdays.length,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemBuilder: (context, index) {
              final day = weekdays[index];
              final isSelected = _dayOfWeek == day.$1;

              return GestureDetector(
                onTap: () => setState(() => _dayOfWeek = day.$1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16), // 요일 텍스트 길이에 맞춰 여백 조절
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDark ? AppColors.white : AppColors.black)
                        : (isDark
                            ? AppColors.darkSurfaceContainer
                            : AppColors.lightGray),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: (isDark ? Colors.white : Colors.black)
                                  .withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ]
                        : [],
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : (isDark
                              ? AppColors.darkOutline
                              : AppColors.mediumGray),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          day.$2,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected
                                ? (isDark ? AppColors.black : AppColors.white)
                                : (isDark ? AppColors.white : AppColors.black),
                          ),
                        ),
                        if (isSelected)
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.black : AppColors.white,
                              shape: BoxShape.circle,
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            languageProvider.isKorean
                ? "매주 ${weekdays.firstWhere((d) => d.$1 == _dayOfWeek).$2}에 결제됩니다."
                : "Billed every ${weekdays.firstWhere((d) => d.$1 == _dayOfWeek).$2}.",
            style: TextStyle(
              fontSize: 12,
              color: AppColors.gray.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDayGrid(bool isDark, LanguageProvider languageProvider) {
    // 초기 스크롤 위치 설정
    if (!_initialScrollDone) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelectedDay();
        _initialScrollDone = true;
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 54, // 피커 높이
          child: ListView.builder(
            controller: _dayScrollController,
            scrollDirection: Axis.horizontal,
            itemCount: 31,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemBuilder: (context, index) {
              final day = index + 1;
              final isSelected = _dayOfMonth == day;

              return GestureDetector(
                onTap: () => setState(() => _dayOfMonth = day),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  width: 46,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDark ? AppColors.white : AppColors.black)
                        : (isDark
                            ? AppColors.darkSurfaceContainer
                            : AppColors.lightGray),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: (isDark ? Colors.white : Colors.black)
                                  .withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ]
                        : [],
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : (isDark
                              ? AppColors.darkOutline
                              : AppColors.mediumGray),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$day',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected
                                ? (isDark ? AppColors.black : AppColors.white)
                                : (isDark ? AppColors.white : AppColors.black),
                          ),
                        ),
                        if (isSelected)
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.black : AppColors.white,
                              shape: BoxShape.circle,
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            _getCycleNotificationText(languageProvider), // 함수로 분리하여 호출
            style: TextStyle(
              fontSize: 12,
              color: AppColors.gray.withOpacity(0.8),
            ),
          ),
        ),
      ],
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
        iconPath: widget.selectedService?.iconPath,
        amount: amount,
        currency: _currency,
        billingCycle: _billingCycle,
        dayOfWeek: _billingCycle == BillingCycle.weekly ? _dayOfWeek : null,
        dayOfMonth: _billingCycle != BillingCycle.weekly ? _dayOfMonth : null,
        month: (_billingCycle == BillingCycle.yearly ||
                _billingCycle == BillingCycle.once)
            ? _month
            : null,
        createdAt: DateTime.now(),
        colorValue: _selectedColorValue,
        startDate: _hasStartDate ? _startDate : null,
        endDate: _hasEndDate ? _endDate : null,
      );

      Provider.of<SubscriptionProvider>(context, listen: false)
          .addSubscription(subscription);

      _showToast(context, languageProvider.tr('subscriptionAdded'),
          isSuccess: true);

      // Pop twice to go back to home (past service selection screen)
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  void _showToast(BuildContext context, String message,
      {bool isSuccess = false}) {
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

  String _getCycleNotificationText(LanguageProvider lp) {
    if (lp.isKorean) {
      switch (_billingCycle) {
        case BillingCycle.once:
          return "$_month월 $_dayOfMonth일에 결제됩니다.";
        case BillingCycle.weekly:
          final days = ['', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
          return "매주 ${days[_dayOfWeek]}에 결제됩니다.";
        case BillingCycle.monthly:
          return "매월 $_dayOfMonth일에 결제됩니다.";
        case BillingCycle.yearly:
          return "매년 $_month월 $_dayOfMonth일에 결제됩니다."; // '매년'으로 수정
      }
    } else {
      // 영어 버전 대응
      switch (_billingCycle) {
        case BillingCycle.once:
          return "Will be billed on $_month/$_dayOfMonth.";
        case BillingCycle.weekly:
          return "Billed every week.";
        case BillingCycle.monthly:
          return "Billed on the ${_dayOfMonth}th of every month.";
        case BillingCycle.yearly:
          return "Billed on $_month/$_dayOfMonth every year.";
      }
    }
  }
}
