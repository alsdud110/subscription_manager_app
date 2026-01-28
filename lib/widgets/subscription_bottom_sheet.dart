import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui';
import '../models/subscription.dart';
import '../providers/subscription_provider.dart';
import '../providers/language_provider.dart';

class SubscriptionBottomSheet extends StatefulWidget {
  final DateTime date;
  final List<Subscription> subscriptions;

  const SubscriptionBottomSheet({
    super.key,
    required this.date,
    required this.subscriptions,
  });

  @override
  State<SubscriptionBottomSheet> createState() =>
      _SubscriptionBottomSheetState();
}

class _SubscriptionBottomSheetState extends State<SubscriptionBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.forward();

    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        setState(() {
          _isVisible = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final dateFormat = languageProvider.isKorean
        ? DateFormat('yyyy년 M월 d일')
        : DateFormat('MMMM d, yyyy');
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0.6),
                      ]
                    : [
                        Colors.white.withOpacity(0.85),
                        Colors.white.withOpacity(0.75),
                      ],
              ),
              border: Border(
                top: BorderSide(
                  color: Colors.white.withOpacity(isDark ? 0.1 : 0.3),
                  width: 2,
                ),
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, dateFormat, isDark, languageProvider),
                const SizedBox(height: 24),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: widget.subscriptions.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _buildAnimatedListItem(
                        context,
                        widget.subscriptions[index],
                        index,
                        isDark,
                        languageProvider,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, DateFormat dateFormat, bool isDark,
      LanguageProvider languageProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF00D9FF), const Color(0xFF39FF14)]
                      : [const Color(0xFF0066CC), const Color(0xFF0099FF)],
                ).createShader(bounds),
                child: Text(
                  dateFormat.format(widget.date),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${widget.subscriptions.length} ${languageProvider.tr('subscriptions')}',
                style: TextStyle(
                  fontSize: 14,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
          ),
          child: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedListItem(
    BuildContext context,
    Subscription subscription,
    int index,
    bool isDark,
    LanguageProvider languageProvider,
  ) {
    return AnimatedSlide(
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeOut,
      offset: _isVisible ? Offset.zero : const Offset(0, 0.3),
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 300 + (index * 100)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withOpacity(isDark ? 0.1 : 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                leading: _buildGlowingIcon(subscription, isDark),
                title: Text(
                  subscription.serviceName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Theme.of(context).colorScheme.onSurface,
                    letterSpacing: 0.3,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    subscription.getBillingInfo(),
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: isDark
                            ? [const Color(0xFF00D9FF), const Color(0xFF39FF14)]
                            : [
                                const Color(0xFF0066CC),
                                const Color(0xFF0099FF)
                              ],
                      ).createShader(bounds),
                      child: Text(
                        subscription.getFormattedAmount(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.white,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildDeleteButton(
                        context, subscription, isDark, languageProvider),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlowingIcon(Subscription subscription, bool isDark) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF00D9FF).withOpacity(0.2),
                  const Color(0xFF39FF14).withOpacity(0.2),
                ]
              : [
                  const Color(0xFF0066CC).withOpacity(0.15),
                  const Color(0xFF0099FF).withOpacity(0.15),
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? const Color(0xFF00D9FF).withOpacity(0.3)
              : const Color(0xFF0066CC).withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? const Color(0xFF00D9FF) : const Color(0xFF0066CC))
                .withOpacity(0.2),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Text(
          subscription.serviceIcon,
          style: const TextStyle(fontSize: 28),
        ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context, Subscription subscription,
      bool isDark, LanguageProvider languageProvider) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red.withOpacity(isDark ? 0.2 : 0.1),
              border: Border.all(
                color: Colors.red.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.delete_outline),
              color: Colors.red,
              iconSize: 22,
              onPressed: () {
                _showDeleteDialog(context, subscription, languageProvider);
              },
            ),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, Subscription subscription,
      LanguageProvider languageProvider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (BuildContext dialogContext) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            backgroundColor: isDark ? const Color(0xFF1A1F3A) : Colors.white,
            title: Text(
              languageProvider.tr('deleteSubscription'),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            content: Text(
              '"${subscription.serviceName}" ${languageProvider.tr('deleteConfirm')}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(
                  languageProvider.tr('cancel'),
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF4444), Color(0xFFCC0000)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () {
                    Provider.of<SubscriptionProvider>(context, listen: false)
                        .deleteSubscription(subscription.id);
                    _showCustomToast(context, languageProvider.tr('subscriptionDeleted'), isSuccess: true);
                    Navigator.pop(dialogContext);
                    Navigator.pop(context);
                  },
                  child: Text(
                    languageProvider.tr('delete'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
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
