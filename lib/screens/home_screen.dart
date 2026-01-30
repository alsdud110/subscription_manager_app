import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../constants/colors.dart';
import '../models/subscription.dart';
import '../providers/theme_provider.dart';
import '../providers/subscription_provider.dart';
import '../providers/language_provider.dart';
import '../widgets/subscription_bottom_sheet.dart';
import '../widgets/summary_cards.dart';
import 'select_service_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.black : AppColors.white,
      appBar: _buildAppBar(context, themeProvider, languageProvider, isDark),
      floatingActionButton: _buildFab(context, isDark),
      body: subscriptionProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  _buildCalendar(
                      context, subscriptionProvider, isDark, languageProvider),
                  const SizedBox(height: 20),
                  const SummaryCards(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ThemeProvider themeProvider,
    LanguageProvider languageProvider,
    bool isDark,
  ) {
    return AppBar(
      backgroundColor: isDark ? AppColors.black : AppColors.white,
      surfaceTintColor: Colors.transparent,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/app_icon.png',
              width: 32,
              height: 32,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            languageProvider.tr('subscriptionManager'),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.white : AppColors.black,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
      leading: IconButton(
        icon: Icon(
          themeProvider.isDarkMode
              ? Icons.light_mode_outlined
              : Icons.dark_mode_outlined,
          color: AppColors.gray,
        ),
        onPressed: () => themeProvider.toggleTheme(),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.settings_outlined,
            color: AppColors.gray,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFab(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.mint.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const SelectServiceScreen()),
          );
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.add_rounded, size: 28, color: Colors.white),
      ),
    );
  }

  Widget _buildCalendar(
    BuildContext context,
    SubscriptionProvider subscriptionProvider,
    bool isDark,
    LanguageProvider languageProvider,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceContainer : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkOutline : AppColors.mediumGray,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: TableCalendar(
          locale: languageProvider.isKorean ? 'ko_KR' : 'en_US',
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          availableGestures: AvailableGestures.horizontalSwipe,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });

            final subscriptions =
                subscriptionProvider.getSubscriptionsForDate(selectedDay);

            if (subscriptions.isNotEmpty) {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => SubscriptionBottomSheet(
                  date: selectedDay,
                  subscriptions: subscriptions,
                ),
              );
            }
          },
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          onPageChanged: (focusedDay) {
            setState(() {
              _focusedDay = focusedDay;
            });
          },
          eventLoader: (day) {
            return subscriptionProvider.getSubscriptionsForDate(day);
          },
          calendarStyle: const CalendarStyle(
            outsideDaysVisible: false,
            // 기본 동그라미 데코레이션 제거하여 커스텀 빌더가 보이게 함
            todayDecoration: BoxDecoration(color: Colors.transparent),
            selectedDecoration: BoxDecoration(color: Colors.transparent),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.white : AppColors.black,
            ),
            leftChevronIcon:
                const Icon(Icons.chevron_left_rounded, color: AppColors.gray),
            rightChevronIcon:
                const Icon(Icons.chevron_right_rounded, color: AppColors.gray),
          ),
          calendarBuilders: CalendarBuilders(
            // 모든 상태에서 사각형 박스 디자인(_buildDayCell)을 사용하도록 고정
            defaultBuilder: (context, date, _) {
              final events = subscriptionProvider.getSubscriptionsForDate(date);
              return _buildDayCell(date, events.cast<Subscription>(), isDark,
                  isSelected: false, isToday: false);
            },
            todayBuilder: (context, date, _) {
              final events = subscriptionProvider.getSubscriptionsForDate(date);
              return _buildDayCell(date, events.cast<Subscription>(), isDark,
                  isSelected: false, isToday: true);
            },
            selectedBuilder: (context, date, _) {
              final events = subscriptionProvider.getSubscriptionsForDate(date);
              return _buildDayCell(date, events.cast<Subscription>(), isDark,
                  isSelected: true, isToday: false);
            },
            markerBuilder: (context, date, events) => const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  Widget _buildDayCell(
    DateTime date,
    List<Subscription> events,
    bool isDark, {
    required bool isSelected,
    required bool isToday,
  }) {
    final hasEvents = events.isNotEmpty;

    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        gradient: isSelected ? AppColors.primaryGradient : null,
        color: isToday && !isSelected ? AppColors.mint.withOpacity(0.2) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${date.day}',
            style: TextStyle(
              fontSize: 14,
              fontWeight:
                  isSelected || isToday ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? Colors.white
                  : (isDark ? AppColors.white : AppColors.black),
            ),
          ),
          const SizedBox(height: 2),
          // 아이콘 영역 높이를 고정하여 이벤트 유무와 상관없이 숫자의 위치를 유지함
          SizedBox(
            height: 16,
            child: hasEvents
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: events
                        .take(3)
                        .map((sub) => _buildMiniIcon(sub))
                        .toList(),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniIcon(Subscription sub) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: sub.iconPath != null
            ? Image.asset(
                sub.iconPath!,
                width: 14,
                height: 14,
                fit: BoxFit.cover,
              )
            : Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Color(sub.colorValue),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Center(
                  child: Text(
                    sub.serviceIcon,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
      ),
    );
  }
}
