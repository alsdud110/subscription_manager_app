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
          color: isDark ? AppColors.gray : AppColors.gray,
        ),
        onPressed: () => themeProvider.toggleTheme(),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.settings_outlined,
            color: isDark ? AppColors.gray : AppColors.gray,
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
            color: AppColors.mint.withValues(alpha: 0.4),
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
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            markersMaxCount: 3,
            markerSize: 6,
            markerMargin: const EdgeInsets.symmetric(horizontal: 1),
            todayDecoration: BoxDecoration(
              color: AppColors.mint.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            todayTextStyle: TextStyle(
              color: isDark ? AppColors.white : AppColors.black,
              fontWeight: FontWeight.w600,
            ),
            selectedDecoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            selectedTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            defaultTextStyle: TextStyle(
              color: isDark ? AppColors.white : AppColors.black,
              fontWeight: FontWeight.w500,
            ),
            weekendTextStyle: TextStyle(
              color: isDark ? AppColors.gray : AppColors.gray,
              fontWeight: FontWeight.w500,
            ),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            leftChevronPadding: const EdgeInsets.all(12),
            rightChevronPadding: const EdgeInsets.all(12),
            titleTextStyle: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.white : AppColors.black,
            ),
            leftChevronIcon: Icon(
              Icons.chevron_left_rounded,
              color: isDark ? AppColors.gray : AppColors.gray,
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right_rounded,
              color: isDark ? AppColors.gray : AppColors.gray,
            ),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.gray : AppColors.gray,
            ),
            weekendStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color:
                  (isDark ? AppColors.gray : AppColors.gray).withOpacity(0.7),
            ),
          ),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (events.isEmpty) return null;
              return Positioned(
                bottom: 8,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: events.take(3).map((event) {
                    final subscription = event as Subscription;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Color(subscription.colorValue),
                        shape: BoxShape.circle,
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
