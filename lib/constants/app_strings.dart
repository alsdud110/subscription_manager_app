class AppStrings {
  // Supported languages
  static const String korean = 'ko';
  static const String english = 'en';

  static final Map<String, Map<String, String>> _localizedStrings = {
    korean: _koreanStrings,
    english: _englishStrings,
  };

  static String get(String key, String languageCode) {
    return _localizedStrings[languageCode]?[key] ??
           _localizedStrings[korean]?[key] ??
           key;
  }

  // Korean strings (default)
  static const Map<String, String> _koreanStrings = {
    // App
    'appTitle': 'SubTrackr',
    'subscriptionManager': 'SubTrackr',

    // Home Screen
    'noSubscriptions': '구독 없음',

    // Settings Screen
    'settings': '설정',
    'appearance': '외관',
    'theme': '테마',
    'darkMode': '다크 모드',
    'lightMode': '라이트 모드',
    'language': '언어',
    'korean': '한국어',
    'english': 'English',
    'general': '일반',
    'helpSupport': '도움말 및 지원',
    'privacyPolicy': '개인정보 처리방침',
    'termsOfService': '이용약관',
    'version': '버전',

    // Add Subscription Screen
    'addSubscription': '구독 추가',
    'selectService': '서비스 선택',
    'selectColor': '색상 선택',
    'customServiceName': '사용자 지정 서비스 이름',
    'pleaseEnterServiceName': '서비스 이름을 입력하세요',
    'price': '가격',
    'amount': '금액',
    'pleaseEnterAmount': '금액을 입력하세요',
    'invalidAmount': '올바른 금액이 아닙니다',
    'billingCycle': '결제 주기',
    'once': '일회성',
    'weekly': '주간',
    'monthly': '월간',
    'yearly': '연간',
    'selectDayOfWeek': '요일 선택',
    'selectDayOfMonth': '날짜 선택',
    'selectMonthAndDay': '월과 날짜 선택',
    'month': '월',
    'day': '일',
    'pleaseSelectService': '서비스를 선택하거나 입력하세요',
    'subscriptionAdded': '구독이 추가되었습니다',

    // Days of week
    'monday': '월요일',
    'tuesday': '화요일',
    'wednesday': '수요일',
    'thursday': '목요일',
    'friday': '금요일',
    'saturday': '토요일',
    'sunday': '일요일',

    // Months
    'january': '1월',
    'february': '2월',
    'march': '3월',
    'april': '4월',
    'may': '5월',
    'june': '6월',
    'july': '7월',
    'august': '8월',
    'september': '9월',
    'october': '10월',
    'november': '11월',
    'december': '12월',

    // Summary Cards
    'weeklyTotal': '주간 합계',
    'monthlyTotal': '월간 합계',

    // Subscription Bottom Sheet
    'subscriptions': '개의 구독',
    'deleteSubscription': '구독 삭제',
    'deleteConfirm': '을(를) 삭제하시겠습니까?',
    'cancel': '취소',
    'delete': '삭제',
    'subscriptionDeleted': '구독이 삭제되었습니다',

    // Splash Screen
    'manageSubscriptionsEasily': '구독을 쉽게 관리하세요',

    // Predefined Services
    'custom': '사용자 지정',

    // Billing Info
    'everyWeekOn': '매주',
    'everyMonthOn': '매월',
    'everyYearOn': '매년',

    // Theme Names
    'themeMidnight': '미드나잇',
    'themeSoftPearl': '소프트 펄',

    // Currency Settings
    'currency': '통화',
    'baseCurrency': '기준 통화',
    'exchangeRate': '환율',
    'exchangeRateDescription': '1 USD = ? KRW',
    'krwFull': '원 (KRW)',
    'usdFull': '달러 (USD)',
    'save': '저장',
  };

  // English strings
  static const Map<String, String> _englishStrings = {
    // App
    'appTitle': 'SubTrackr',
    'subscriptionManager': 'SubTrackr',

    // Home Screen
    'noSubscriptions': 'No subscriptions',

    // Settings Screen
    'settings': 'Settings',
    'appearance': 'Appearance',
    'theme': 'Theme',
    'darkMode': 'Dark Mode',
    'lightMode': 'Light Mode',
    'language': 'Language',
    'korean': '한국어',
    'english': 'English',
    'general': 'General',
    'helpSupport': 'Help & Support',
    'privacyPolicy': 'Privacy Policy',
    'termsOfService': 'Terms of Service',
    'version': 'Version',

    // Add Subscription Screen
    'addSubscription': 'Add Subscription',
    'selectService': 'Select Service',
    'selectColor': 'Select Color',
    'customServiceName': 'Custom Service Name',
    'pleaseEnterServiceName': 'Please enter service name',
    'price': 'Price',
    'amount': 'Amount',
    'pleaseEnterAmount': 'Please enter amount',
    'invalidAmount': 'Invalid amount',
    'billingCycle': 'Billing Cycle',
    'once': 'Once',
    'weekly': 'Weekly',
    'monthly': 'Monthly',
    'yearly': 'Yearly',
    'selectDayOfWeek': 'Select Day of Week',
    'selectDayOfMonth': 'Select Day of Month',
    'selectMonthAndDay': 'Select Month and Day',
    'month': 'Month',
    'day': 'Day',
    'pleaseSelectService': 'Please select or enter a service name',
    'subscriptionAdded': 'Subscription added successfully',

    // Days of week
    'monday': 'Monday',
    'tuesday': 'Tuesday',
    'wednesday': 'Wednesday',
    'thursday': 'Thursday',
    'friday': 'Friday',
    'saturday': 'Saturday',
    'sunday': 'Sunday',

    // Months
    'january': 'January',
    'february': 'February',
    'march': 'March',
    'april': 'April',
    'may': 'May',
    'june': 'June',
    'july': 'July',
    'august': 'August',
    'september': 'September',
    'october': 'October',
    'november': 'November',
    'december': 'December',

    // Summary Cards
    'weeklyTotal': 'Weekly Total',
    'monthlyTotal': 'Monthly Total',

    // Subscription Bottom Sheet
    'subscriptions': 'subscription(s)',
    'deleteSubscription': 'Delete Subscription',
    'deleteConfirm': 'Are you sure you want to delete',
    'cancel': 'Cancel',
    'delete': 'Delete',
    'subscriptionDeleted': 'Subscription deleted successfully',

    // Splash Screen
    'manageSubscriptionsEasily': 'Manage your subscriptions easily',

    // Predefined Services
    'custom': 'Custom',

    // Billing Info
    'everyWeekOn': 'Every week on',
    'everyMonthOn': 'Every month on',
    'everyYearOn': 'Every year on',

    // Theme Names
    'themeMidnight': 'Midnight',
    'themeSoftPearl': 'Soft Pearl',

    // Currency Settings
    'currency': 'Currency',
    'baseCurrency': 'Base Currency',
    'exchangeRate': 'Exchange Rate',
    'exchangeRateDescription': '1 USD = ? KRW',
    'krwFull': 'Won (KRW)',
    'usdFull': 'Dollar (USD)',
    'save': 'Save',
  };
}
