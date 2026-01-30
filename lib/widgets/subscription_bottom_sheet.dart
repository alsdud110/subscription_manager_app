import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../constants/colors.dart';
import '../models/subscription.dart';
import '../providers/subscription_provider.dart';
import '../providers/language_provider.dart';

class SubscriptionBottomSheet extends StatelessWidget {
  final DateTime date;
  final List<Subscription> subscriptions;

  const SubscriptionBottomSheet({
    super.key,
    required this.date,
    required this.subscriptions,
  });

  // 요일 및 결제 주기 번역 핵심 로직
  String _getTranslatedBillingInfo(Subscription sub, LanguageProvider lp) {
    if (lp.isKorean) {
      switch (sub.billingCycle) {
        case BillingCycle.once:
          return '1회성: ${sub.month}월 ${sub.dayOfMonth}일';
        case BillingCycle.weekly:
          final days = ['', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
          return '매주 ${days[sub.dayOfWeek ?? 1]}';
        case BillingCycle.monthly:
          return '매월 ${sub.dayOfMonth}일';
        case BillingCycle.yearly:
          return '매년 ${sub.month}월 ${sub.dayOfMonth}일';
      }
    } else {
      // 기존 모델의 영문 로직 활용
      return sub.getBillingInfo();
    }
  }

  // 금액 포맷 (천단위 콤마 + Suffix)
  String _getFormattedPrice(Subscription sub, LanguageProvider lp) {
    final formatter = NumberFormat('#,###');
    final formattedNumber = formatter.format(sub.amount);

    if (lp.isKorean) {
      // 한국어일 때는 금액 뒤에 '원' 또는 '$' (통화 설정에 따라)
      final unit = sub.currency == Currency.krw ? '원' : '\$';
      return '$formattedNumber$unit';
    } else {
      // 영어일 때는 심볼을 앞에 (기본 모델 로직 활용 가능)
      return sub.getFormattedAmount();
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final dateFormat = languageProvider.isKorean
        ? DateFormat('yyyy년 M월 d일')
        : DateFormat('MMMM d, yyyy');
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.black : AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkOutline : AppColors.mediumGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildHeader(context, dateFormat, isDark, languageProvider),
          const SizedBox(height: 20),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: subscriptions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return _buildSubscriptionItem(
                  context,
                  subscriptions[index],
                  isDark,
                  languageProvider,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    DateFormat dateFormat,
    bool isDark,
    LanguageProvider languageProvider,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateFormat.format(date),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.white : AppColors.black,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${subscriptions.length}${languageProvider.isKorean ? '개의 구독' : ' ${languageProvider.tr('subscriptions')}'}',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.gray,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.close_rounded,
            color: isDark ? AppColors.gray : AppColors.gray,
          ),
          style: IconButton.styleFrom(
            backgroundColor:
                isDark ? AppColors.darkSurfaceContainer : AppColors.lightGray,
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionItem(
    BuildContext context,
    Subscription subscription,
    bool isDark,
    LanguageProvider languageProvider,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceContainer : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkOutline : AppColors.mediumGray,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          subscription.iconPath != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    subscription.iconPath!,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Color(subscription.colorValue).withAlpha(38),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      subscription.serviceIcon,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(subscription.colorValue),
                      ),
                    ),
                  ),
                ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subscription.serviceName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.white : AppColors.black,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _getTranslatedBillingInfo(
                      subscription, languageProvider), // 요일 한글화 적용
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.gray,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            _getFormattedPrice(subscription, languageProvider), // 금액 Suffix 적용
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.white : AppColors.black,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => _showDeleteDialog(
              context,
              subscription,
              languageProvider,
              isDark,
            ),
            icon: Icon(
              Icons.delete_outline_rounded,
              color: isDark ? AppColors.gray : AppColors.darkGray,
              size: 22,
            ),
            style: IconButton.styleFrom(
              backgroundColor:
                  isDark ? AppColors.darkOutline : AppColors.lightGray,
              padding: const EdgeInsets.all(8),
            ),
          ),
        ],
      ),
    );
  }

  // ... (기존 _showDeleteDialog 및 _showToast 코드는 동일)
  void _showDeleteDialog(
    BuildContext context,
    Subscription subscription,
    LanguageProvider languageProvider,
    bool isDark,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor:
              isDark ? AppColors.darkSurfaceContainer : AppColors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            languageProvider.tr('deleteSubscription'),
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.white : AppColors.black),
          ),
          content: Text(
            '"${subscription.serviceName}" ${languageProvider.tr('deleteConfirm')}',
            style: const TextStyle(color: AppColors.gray),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(languageProvider.tr('cancel'),
                  style: const TextStyle(
                      color: AppColors.gray, fontWeight: FontWeight.w600)),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<SubscriptionProvider>(context, listen: false)
                    .deleteSubscription(subscription.id);
                _showToast(context, languageProvider.tr('subscriptionDeleted'),
                    isSuccess: true);
                Navigator.pop(dialogContext);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? AppColors.white : AppColors.black,
                foregroundColor: isDark ? AppColors.black : AppColors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(languageProvider.tr('delete'),
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        );
      },
    );
  }

  void _showToast(BuildContext context, String message,
      {bool isSuccess = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fToast = FToast();
    fToast.init(context);
    fToast.showToast(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isDark ? AppColors.white : AppColors.black),
        child: Text(message,
            style: TextStyle(
                color: isDark ? AppColors.black : AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500)),
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }
}
