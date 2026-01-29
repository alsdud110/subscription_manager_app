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
              '${subscriptions.length} ${languageProvider.tr('subscriptions')}',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColors.gray : AppColors.gray,
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
            backgroundColor: isDark
                ? AppColors.darkSurfaceContainer
                : AppColors.lightGray,
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
          color: isDark
              ? AppColors.darkOutline
              : AppColors.mediumGray,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Color(subscription.colorValue).withAlpha(38),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                subscription.serviceIcon,
                style: const TextStyle(fontSize: 24),
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
                  subscription.getBillingInfo(),
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.gray : AppColors.gray,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            subscription.getFormattedAmount(),
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
              backgroundColor: isDark
                  ? AppColors.darkOutline
                  : AppColors.lightGray,
              padding: const EdgeInsets.all(8),
            ),
          ),
        ],
      ),
    );
  }

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
          backgroundColor: isDark ? AppColors.darkSurfaceContainer : AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            languageProvider.tr('deleteSubscription'),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.white : AppColors.black,
            ),
          ),
          content: Text(
            '"${subscription.serviceName}" ${languageProvider.tr('deleteConfirm')}',
            style: TextStyle(
              color: isDark ? AppColors.gray : AppColors.gray,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                languageProvider.tr('cancel'),
                style: TextStyle(
                  color: isDark ? AppColors.gray : AppColors.gray,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<SubscriptionProvider>(context, listen: false)
                    .deleteSubscription(subscription.id);
                _showToast(
                  context,
                  languageProvider.tr('subscriptionDeleted'),
                  isSuccess: true,
                );
                Navigator.pop(dialogContext);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? AppColors.white : AppColors.black,
                foregroundColor: isDark ? AppColors.black : AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                languageProvider.tr('delete'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
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
