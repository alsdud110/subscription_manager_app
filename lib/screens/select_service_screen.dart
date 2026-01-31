import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/services.dart';
import '../providers/language_provider.dart';
import '../utils/page_transitions.dart';
import 'add_subscription_screen.dart';

class SelectServiceScreen extends StatefulWidget {
  final bool isFirstLaunch;

  const SelectServiceScreen({super.key, this.isFirstLaunch = false});

  @override
  State<SelectServiceScreen> createState() => _SelectServiceScreenState();
}

class _SelectServiceScreenState extends State<SelectServiceScreen> {
  ServiceInfo? _selectedService;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ServiceInfo> _filterServices(List<ServiceInfo> services) {
    if (_searchQuery.isEmpty) return services;
    return services
        .where((s) => s.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.black : AppColors.white,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.black : AppColors.white,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          languageProvider.tr('selectService'),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.white : AppColors.black,
          ),
        ),
        leading: widget.isFirstLaunch
            ? null
            : IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceContainer
                        : AppColors.lightGray,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: isDark ? AppColors.white : AppColors.black,
                    size: 16,
                  ),
                ),
              ),
        actions: widget.isFirstLaunch
            ? [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/home');
                  },
                  child: Text(
                    languageProvider.tr('skipForNow'),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.gray,
                    ),
                  ),
                ),
              ]
            : null,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSearchBar(isDark, languageProvider),
                    const SizedBox(height: 24),
                    ..._buildCategorySections(isDark, languageProvider),
                  ],
                ),
              ),
            ),
            _buildBottomBar(context, isDark, languageProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(bool isDark, LanguageProvider languageProvider) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceContainer : AppColors.lightGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _searchQuery = value),
        style: TextStyle(
          color: isDark ? AppColors.white : AppColors.black,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          hintText: languageProvider.tr('searchService'),
          hintStyle: const TextStyle(
            color: AppColors.gray,
            fontSize: 15,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.gray,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, color: AppColors.gray),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  List<Widget> _buildCategorySections(
      bool isDark, LanguageProvider languageProvider) {
    final List<Widget> sections = [];

    for (final category in ServiceCategory.values) {
      final services =
          _filterServices(ServiceData.getServicesByCategory(category));
      if (services.isEmpty) continue;

      sections.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            _getCategoryName(category, languageProvider),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.gray,
            ),
          ),
        ),
      );

      sections.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Wrap(
            spacing: 8,
            runSpacing: 10,
            children: services.map((service) {
              return _buildServiceChip(service, isDark);
            }).toList(),
          ),
        ),
      );
    }

    // 직접 입력 섹션
    sections.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          languageProvider.tr('other'),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.gray,
          ),
        ),
      ),
    );

    sections.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: _buildCustomChip(isDark, languageProvider),
      ),
    );

    return sections;
  }

  Widget _buildServiceChip(ServiceInfo service, bool isDark) {
    final isSelected = _selectedService?.id == service.id;
    final hasIcon = service.iconPath != null;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedService = null;
          } else {
            _selectedService = service;
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.mint.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.mint
                : (isDark ? AppColors.darkOutline : AppColors.mediumGray),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasIcon) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  service.iconPath!,
                  width: 18,
                  height: 18,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              service.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? AppColors.teal
                    : (isDark ? AppColors.white : AppColors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomChip(bool isDark, LanguageProvider languageProvider) {
    return GestureDetector(
      onTap: () {
        setState(() => _selectedService = null);
        _navigateToAddSubscription(null);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppColors.darkOutline : AppColors.mediumGray,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_rounded,
              size: 18,
              color: isDark ? AppColors.white : AppColors.black,
            ),
            const SizedBox(width: 6),
            Text(
              languageProvider.tr('customService'),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    bool isDark,
    LanguageProvider languageProvider,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.black : AppColors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkOutline : AppColors.mediumGray,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Clear 버튼
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedService = null);
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceContainer
                      : AppColors.lightGray,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    languageProvider.tr('clear'),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.white : AppColors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // 다음 버튼
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: _selectedService != null
                  ? () => _navigateToAddSubscription(_selectedService)
                  : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 50,
                decoration: BoxDecoration(
                  gradient: _selectedService != null
                      ? AppColors.primaryGradient
                      : null,
                  color: _selectedService == null
                      ? (isDark ? AppColors.darkOutline : AppColors.mediumGray)
                      : null,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    _selectedService != null
                        ? '${_selectedService!.name} ${languageProvider.tr('select')}'
                        : languageProvider.tr('selectServicePlease'),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: _selectedService != null
                          ? Colors.white
                          : (isDark ? AppColors.gray : AppColors.darkGray),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryName(
      ServiceCategory category, LanguageProvider languageProvider) {
    if (languageProvider.isKorean) {
      return ServiceData.categoryNamesKo[category] ?? category.name;
    }
    return ServiceData.categoryNames[category] ?? category.name;
  }

  void _navigateToAddSubscription(ServiceInfo? service) {
    Navigator.push(
      context,
      FadeSlidePageRoute(page: AddSubscriptionScreen(selectedService: service)),
    );
  }
}
