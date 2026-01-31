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
    'appTitle': '구독잇',
    'subscriptionManager': '구독잇',

    // Home Screen
    'noSubscriptions': '등록된 서비스가 없습니다',
    'skipForNow': '나중에 하기',

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
    'billingCycle': '구독(결제) 주기',
    'selectBillingCycle': '결제 주기를 선택해주세요',
    'once': '일회성',
    'weekly': '매주',
    'monthly': '매달',
    'yearly': '매년',
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
    'customService': '직접 입력',
    'customServiceDesc': '원하는 서비스를 직접 추가하세요',
    'searchService': '서비스 검색',
    'searchServiceHint': '서비스 이름을 검색하세요',
    'noSearchResults': '검색 결과가 없습니다',
    'selectServiceDesc': '구독 중인 서비스를 선택하세요',
    'selectServicePlease': '서비스를 선택하세요',
    'select': '선택',
    'clear': '초기화',
    'other': '기타',
    'serviceName': '서비스 이름',
    'enterServiceName': '서비스 이름을 입력하세요',
    'startDate': '구독 시작일',
    'endDate': '구독 종료일',
    'optional': '선택사항',

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
    'won': '원',
    'dollar': '달러',
    'save': '저장',

    // App Info
    'appSettings': '앱 설정',
    'appInfo': '앱 정보',
    'fontLicense': '폰트 라이선스',
    'fontLicenseText': '이 앱에는 (주)여기어때컴퍼니가 제공한 여기어때 잘난체가 적용되어 있습니다.',

    // Data Management
    'dataManagement': '데이터 관리',
    'resetAllSubscriptions': '구독 초기화',
    'resetAllSubscriptionsDesc': '등록된 모든 구독을 삭제합니다',
    'resetConfirmTitle': '구독 초기화',
    'resetConfirmMessage': '등록된 모든 구독이 삭제됩니다.\n이 작업은 되돌릴 수 없습니다.',
    'reset': '초기화',
    'subscriptionsReset': '모든 구독이 초기화되었습니다',
    'noSubscriptionsToReset': '초기화할 구독이 없습니다',
    'registeredSubscriptions': '개의 구독이 등록됨',

    // Notifications
    'notifications': '알림',
    'notificationSettings': '알림 설정',
    'enableNotifications': '알림 활성화',
    'notificationTime': '알림 시간',
    'notificationTimeDesc': '결제일 며칠 전에 알림을 받을까요?',
    'notificationHour': '알림 받을 시간',
    'notificationHourDesc': '알림을 받을 시간을 선택하세요',
    'daysBeforePayment': '결제일 전',
    'onPaymentDay': '결제일 당일',
    'daysBefore1': '1일 전',
    'daysBefore2': '2일 전',
    'daysBefore3': '3일 전',
    'daysBefore5': '5일 전',
    'daysBefore7': '7일 전',
    'selectNotificationTime': '알림 시간 선택',
    'selectNotificationHour': '알림 받을 시간 선택',
    'notificationPermissionTitle': '알림 권한이 필요합니다',
    'notificationPermissionMessage': '다가오는 결제를\n미리 알려드립니다',
    'allow': '허용하기',
    'later': '나중에',
    'notificationEnabled': '알림이 활성화되었습니다',
    'notificationDisabled': '알림이 비활성화되었습니다',
    'notificationPermissionDenied': '알림 권한이 거부되었습니다',
    'notificationSettingsUpdated': '알림 설정이 변경되었습니다',
  };

  // English strings
  static const Map<String, String> _englishStrings = {
    // App
    'appTitle': 'Subit',
    'subscriptionManager': 'Subit',

    // Home Screen
    'noSubscriptions': 'No registered services',
    'skipForNow': 'Later',

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
    'billingCycle': 'Subscription(Billing) Cycle',
    'selectBillingCycle': 'Please select a billing cycle',
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
    'customService': 'Custom Input',
    'customServiceDesc': 'Add your own service',
    'searchService': 'Search service',
    'searchServiceHint': 'Search for a service',
    'noSearchResults': 'No search results',
    'selectServiceDesc': 'Select a service you subscribe to',
    'selectServicePlease': 'Select a service',
    'select': 'Select',
    'clear': 'Clear',
    'other': 'Other',
    'serviceName': 'Service Name',
    'enterServiceName': 'Enter service name',
    'startDate': 'Subscription Start',
    'endDate': 'Subscription End',
    'optional': 'Optional',

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
    'won': 'Won',
    'dollar': 'Dollar',
    'save': 'Save',

    // App Info
    'appSettings': 'App Settings',
    'appInfo': 'App Info',
    'fontLicense': 'Font License',
    'fontLicenseText': 'This app uses Jalnan font provided by Yanolja Company.',

    // Data Management
    'dataManagement': 'Data Management',
    'resetAllSubscriptions': 'Reset Subscriptions',
    'resetAllSubscriptionsDesc': 'Delete all registered subscriptions',
    'resetConfirmTitle': 'Reset Subscriptions',
    'resetConfirmMessage':
        'All registered subscriptions will be deleted.\nThis action cannot be undone.',
    'reset': 'Reset',
    'subscriptionsReset': 'All subscriptions have been reset',
    'noSubscriptionsToReset': 'No subscriptions to reset',
    'registeredSubscriptions': 'subscription(s) registered',

    // Notifications
    'notifications': 'Notifications',
    'notificationSettings': 'Notification Settings',
    'enableNotifications': 'Enable Notifications',
    'notificationTime': 'Notification Time',
    'notificationTimeDesc': 'How many days before payment?',
    'notificationHour': 'Notification Hour',
    'notificationHourDesc': 'Select notification time',
    'daysBeforePayment': 'Before Payment',
    'onPaymentDay': 'On Payment Day',
    'daysBefore1': '1 Day Before',
    'daysBefore2': '2 Days Before',
    'daysBefore3': '3 Days Before',
    'daysBefore5': '5 Days Before',
    'daysBefore7': '7 Days Before',
    'selectNotificationTime': 'Select Notification Time',
    'selectNotificationHour': 'Select Notification Hour',
    'notificationPermissionTitle': 'Notification Permission Required',
    'notificationPermissionMessage': 'Get notified about\nupcoming payments',
    'allow': 'Allow',
    'later': 'Later',
    'notificationEnabled': 'Notifications enabled',
    'notificationDisabled': 'Notifications disabled',
    'notificationPermissionDenied': 'Notification permission denied',
    'notificationSettingsUpdated': 'Notification settings updated',
  };
}
