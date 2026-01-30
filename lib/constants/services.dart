// 구독 서비스 카테고리 및 서비스 목록

enum ServiceCategory {
  streaming,
  music,
  productivity,
  cloud,
  shopping,
  mobility,
  reading,
  gaming,
  camera,
  social,
  other,
}

class ServiceInfo {
  final String id;
  final String name;
  final ServiceCategory category;
  final String? iconPath; // 나중에 아이콘 추가용
  final int defaultColor;

  const ServiceInfo({
    required this.id,
    required this.name,
    required this.category,
    this.iconPath,
    this.defaultColor = 0xFF6C63FF,
  });
}

class ServiceData {
  static const Map<ServiceCategory, String> categoryNames = {
    ServiceCategory.streaming: 'streaming',
    ServiceCategory.music: 'music',
    ServiceCategory.productivity: 'productivity',
    ServiceCategory.cloud: 'cloud',
    ServiceCategory.shopping: 'shopping',
    ServiceCategory.mobility: 'mobility',
    ServiceCategory.reading: 'reading',
    ServiceCategory.gaming: 'gaming',
    ServiceCategory.camera: 'camera',
    ServiceCategory.social: 'social',
    ServiceCategory.other: 'other',
  };

  static const Map<ServiceCategory, String> categoryNamesKo = {
    ServiceCategory.streaming: '스트리밍',
    ServiceCategory.music: '음악',
    ServiceCategory.productivity: '생산성',
    ServiceCategory.cloud: '클라우드',
    ServiceCategory.shopping: '쇼핑',
    ServiceCategory.mobility: '모빌리티',
    ServiceCategory.reading: '독서',
    ServiceCategory.gaming: '게임',
    ServiceCategory.camera: '카메라',
    ServiceCategory.social: '소셜',
    ServiceCategory.other: '기타',
  };

  static const List<ServiceInfo> services = [
    // 스트리밍
    ServiceInfo(
        id: 'netflix',
        name: 'Netflix',
        category: ServiceCategory.streaming,
        defaultColor: 0xFFE50914,
        iconPath: 'assets/icon/Netflix_logo_icon.png'),
    ServiceInfo(
        id: 'disney_plus',
        name: 'Disney+',
        category: ServiceCategory.streaming,
        defaultColor: 0xFF113CCF,
        iconPath: 'assets/icon/Disney_plus_logo_icon.png'),
    ServiceInfo(
        id: 'amazon_prime_video',
        name: 'Amazon Prime Video',
        category: ServiceCategory.streaming,
        defaultColor: 0xFF00A8E1,
        iconPath: 'assets/icon/Amazon_prime_video_logo_icon.png'),
    ServiceInfo(
        id: 'apple_tv',
        name: 'Apple TV',
        category: ServiceCategory.streaming,
        defaultColor: 0xFF000000,
        iconPath: 'assets/icon/Apple_TV_logo_icon.png'),
    ServiceInfo(
        id: 'watcha',
        name: 'Watcha',
        category: ServiceCategory.streaming,
        defaultColor: 0xFFFF0558,
        iconPath: 'assets/icon/WATCHA_logo_icon.png'),
    ServiceInfo(
        id: 'wavve',
        name: 'Wavve',
        category: ServiceCategory.streaming,
        defaultColor: 0xFF1C1C1C,
        iconPath: 'assets/icon/WAVVE_logo_icon.png'),
    ServiceInfo(
        id: 'tving',
        name: 'TVING',
        category: ServiceCategory.streaming,
        defaultColor: 0xFFFF0000,
        iconPath: 'assets/icon/TVING_logo_icon.png'),
    ServiceInfo(
        id: 'coupang_play',
        name: '쿠팡플레이',
        category: ServiceCategory.streaming,
        defaultColor: 0xFFFF5722,
        iconPath: 'assets/icon/COUPANG_PLAY_logo_icon.png'),
    ServiceInfo(
        id: 'youtube_premium',
        name: 'YouTube Premium',
        category: ServiceCategory.streaming,
        defaultColor: 0xFFFF0000,
        iconPath: 'assets/icon/Youtube_logo_icon.png'),
    ServiceInfo(
        id: 'chzzk',
        name: '치지직',
        category: ServiceCategory.streaming,
        defaultColor: 0xFF00FFA3,
        iconPath: 'assets/icon/CHZZK_logo_icon.png'),
    ServiceInfo(
        id: 'fleek',
        name: '플릭',
        category: ServiceCategory.streaming,
        defaultColor: 0xFF6C63FF,
        iconPath: 'assets/icon/FLEEK_logo_icon.png'),
    ServiceInfo(
        id: 'spotv_now',
        name: 'SPOTV NOW',
        category: ServiceCategory.streaming,
        defaultColor: 0xFFE31C23,
        iconPath: 'assets/icon/SPOTV_logo_icon.png'),

    // 음악
    ServiceInfo(
        id: 'spotify',
        name: 'Spotify',
        category: ServiceCategory.music,
        defaultColor: 0xFF1DB954,
        iconPath: 'assets/icon/SPOTIFY_logo_icon.png'),
    ServiceInfo(
        id: 'apple_music',
        name: 'Apple Music',
        category: ServiceCategory.music,
        defaultColor: 0xFFFA243C,
        iconPath: 'assets/icon/APPLE_MUSIC_logo_icon.png'),
    ServiceInfo(
        id: 'youtube_music',
        name: 'Youtube Music',
        category: ServiceCategory.music,
        defaultColor: 0xFFFF0000,
        iconPath: 'assets/icon/YOUTUBE_MUSIC_logo_icon.png'),
    ServiceInfo(
        id: 'melon',
        name: '멜론',
        category: ServiceCategory.music,
        defaultColor: 0xFF00CD3C,
        iconPath: 'assets/icon/MELON_logo_icon.png'),
    ServiceInfo(
        id: 'genie',
        name: '지니뮤직',
        category: ServiceCategory.music,
        defaultColor: 0xFF3D85C6,
        iconPath: 'assets/icon/GENIE_logo_icon.png'),
    ServiceInfo(
        id: 'flo',
        name: 'FLO',
        category: ServiceCategory.music,
        defaultColor: 0xFF3F3FFF,
        iconPath: 'assets/icon/FLO_logo_icon.png'),
    ServiceInfo(
        id: 'bugs',
        name: '벅스',
        category: ServiceCategory.music,
        defaultColor: 0xFFFF3D00,
        iconPath: 'assets/icon/BUGS_logo_icon.png'),
    ServiceInfo(
        id: 'vibe',
        name: 'NAVER VIBE',
        category: ServiceCategory.music,
        defaultColor: 0xFF1EC800,
        iconPath: 'assets/icon/NAVER_VIBE_logo_icon.png'),
    ServiceInfo(
        id: 'amazon_music',
        name: 'Amazon Music',
        category: ServiceCategory.music,
        defaultColor: 0xFF00A8E1,
        iconPath: 'assets/icon/AMAZON_MUSIC_logo_icon.png'),
    ServiceInfo(
        id: 'soundcloud',
        name: 'Soundcloud',
        category: ServiceCategory.music,
        defaultColor: 0xFFFF5500,
        iconPath: 'assets/icon/SOUNDCLOUD_logo_icon.png'),

    // 생산성
    ServiceInfo(
        id: 'notion',
        name: 'Notion',
        category: ServiceCategory.productivity,
        defaultColor: 0xFF000000,
        iconPath: 'assets/icon/NOTION_logo_icon.png'),
    ServiceInfo(
        id: 'figma',
        name: 'Figma',
        category: ServiceCategory.productivity,
        defaultColor: 0xFFF24E1E,
        iconPath: 'assets/icon/FIGMA_logo_icon.png'),
    ServiceInfo(
        id: 'adobe',
        name: 'Adobe',
        category: ServiceCategory.productivity,
        defaultColor: 0xFFFF0000,
        iconPath: 'assets/icon/ADOBE_logo_icon.png'),
    ServiceInfo(
        id: 'photoshop',
        name: 'Photoshop',
        category: ServiceCategory.productivity,
        defaultColor: 0xFF31A8FF,
        iconPath: 'assets/icon/PHOTOSHOP_logo_icon.png'),
    ServiceInfo(
        id: 'premiere_pro',
        name: 'Premiere Pro',
        category: ServiceCategory.productivity,
        defaultColor: 0xFF9999FF,
        iconPath: 'assets/icon/PREMIERE_PRO_logo_icon.png'),
    ServiceInfo(
        id: 'office_365',
        name: 'Office 365',
        category: ServiceCategory.productivity,
        defaultColor: 0xFFD83B01,
        iconPath: 'assets/icon/OFFICE_365_logo_icon.png'),
    ServiceInfo(
        id: 'slack',
        name: 'Slack',
        category: ServiceCategory.productivity,
        defaultColor: 0xFF4A154B,
        iconPath: 'assets/icon/SLACK_logo_icon.png'),
    ServiceInfo(
        id: 'github',
        name: 'Github',
        category: ServiceCategory.productivity,
        defaultColor: 0xFF181717,
        iconPath: 'assets/icon/GITHUB_logo_icon.png'),
    ServiceInfo(
        id: 'chatgpt',
        name: 'Chat GPT',
        category: ServiceCategory.productivity,
        defaultColor: 0xFF10A37F,
        iconPath: 'assets/icon/CHATGPT_logo_icon.png'),
    ServiceInfo(
        id: 'copilot',
        name: 'Copilot',
        category: ServiceCategory.productivity,
        defaultColor: 0xFF000000,
        iconPath: 'assets/icon/COPILOT_logo_icon.png'),
    ServiceInfo(
        id: 'gemini',
        name: 'Gemini',
        category: ServiceCategory.productivity,
        defaultColor: 0xFF000000,
        iconPath: 'assets/icon/GEMINI_logo_icon.png'),
    ServiceInfo(
        id: 'claude_code',
        name: 'Claude Code',
        category: ServiceCategory.productivity,
        defaultColor: 0xFF000000,
        iconPath: 'assets/icon/CLAUDE_CODE_logo_icon.png'),

    // 클라우드
    ServiceInfo(
        id: 'icloud',
        name: 'iCloud',
        category: ServiceCategory.cloud,
        defaultColor: 0xFF3693F3,
        iconPath: 'assets/icon/ICLOUD_logo_icon.png'),
    ServiceInfo(
        id: 'google_drive',
        name: 'Google 드라이브',
        category: ServiceCategory.cloud,
        defaultColor: 0xFF4285F4,
        iconPath: 'assets/icon/GOOGLE_DRIVE_logo_icon.png'),
    ServiceInfo(
        id: 'naver_mybox',
        name: 'Naver MYBOX',
        category: ServiceCategory.cloud,
        defaultColor: 0xFF03C75A,
        iconPath: 'assets/icon/MYBOX_logo_icon.png'),

    // 쇼핑
    ServiceInfo(
        id: 'coupang',
        name: '쿠팡',
        category: ServiceCategory.shopping,
        defaultColor: 0xFFFF5722,
        iconPath: 'assets/icon/COUPANG_logo_icon.png'),
    ServiceInfo(
        id: 'naver_membership',
        name: 'Naver 멤버십',
        category: ServiceCategory.shopping,
        defaultColor: 0xFF03C75A,
        iconPath: 'assets/icon/NAVER_MEMBERSHIP_logo_icon.png'),
    ServiceInfo(
        id: 'toss_prime',
        name: '토스 프라임',
        category: ServiceCategory.shopping,
        defaultColor: 0xFF0064FF,
        iconPath: 'assets/icon/TOSS_PRIME_logo_icon.png'),
    ServiceInfo(
        id: 'payco',
        name: '페이코',
        category: ServiceCategory.shopping,
        defaultColor: 0xFFE31C23,
        iconPath: 'assets/icon/PAYCO_logo_icon.png'),

    // 모빌리티
    ServiceInfo(
        id: 'ddareungi',
        name: '따릉이',
        category: ServiceCategory.mobility,
        defaultColor: 0xFF00A651,
        iconPath: 'assets/icon/DDAREUNGI_logo_icon.png'),
    ServiceInfo(
        id: 'deer',
        name: 'deer',
        category: ServiceCategory.mobility,
        defaultColor: 0xFF00D4AA,
        iconPath: 'assets/icon/DEER_logo_icon.png'),
    ServiceInfo(
        id: 'elecle',
        name: 'elecle',
        category: ServiceCategory.mobility,
        defaultColor: 0xFF00C7B7,
        iconPath: 'assets/icon/ELECLE_logo_icon.png'),
    ServiceInfo(
        id: 'kickgoing',
        name: '킥고잉',
        category: ServiceCategory.mobility,
        defaultColor: 0xFFFFD600,
        iconPath: 'assets/icon/KICKGOING_logo_icon.png'),
    ServiceInfo(
        id: 'swing',
        name: '스윙',
        category: ServiceCategory.mobility,
        defaultColor: 0xFFFF6B00,
        iconPath: 'assets/icon/SWING_logo_icon.png'),
    ServiceInfo(
        id: 'laundrygo',
        name: '런드리고',
        category: ServiceCategory.mobility,
        defaultColor: 0xFF00B4D8,
        iconPath: 'assets/icon/LAUNDRYGO_logo_icon.png'),
    ServiceInfo(
        id: 'gymbox',
        name: '짐박스',
        category: ServiceCategory.mobility,
        defaultColor: 0xFF000000,
        iconPath: 'assets/icon/GYMBOXX_logo_icon.png'),

    // 독서
    ServiceInfo(
        id: 'millie',
        name: '밀리의서재',
        category: ServiceCategory.reading,
        defaultColor: 0xFFFFE600,
        iconPath: 'assets/icon/MILLIE_logo_icon.png'),
    ServiceInfo(
        id: 'ridi',
        name: '리디',
        category: ServiceCategory.reading,
        defaultColor: 0xFF1F8CE6,
        iconPath: 'assets/icon/RIDI_logo_icon.png'),
    ServiceInfo(
        id: 'yes24',
        name: '예스 24',
        category: ServiceCategory.reading,
        defaultColor: 0xFF003399,
        iconPath: 'assets/icon/YES24_logo_icon.png'),
    ServiceInfo(
        id: 'publy',
        name: '퍼블리',
        category: ServiceCategory.reading,
        defaultColor: 0xFF000000,
        iconPath: 'assets/icon/PUBLY_logo_icon.png'),
    ServiceInfo(
        id: 'medium',
        name: 'Medium',
        category: ServiceCategory.reading,
        defaultColor: 0xFF000000,
        iconPath: 'assets/icon/MEDIUM_logo_icon.png'),

    // 게임
    ServiceInfo(
        id: 'playstation_plus',
        name: 'PlayStation Plus',
        category: ServiceCategory.gaming,
        defaultColor: 0xFF003087,
        iconPath: 'assets/icon/PLAYSTATION_PLUS_logo_icon.png'),
    ServiceInfo(
        id: 'xbox_live',
        name: 'Xbox Live',
        category: ServiceCategory.gaming,
        defaultColor: 0xFF107C10,
        iconPath: 'assets/icon/XBOX_logo_icon.png'),
    // 카메라
    ServiceInfo(
        id: 'snow',
        name: 'SNOW',
        category: ServiceCategory.camera,
        defaultColor: 0xFF00D8FF,
        iconPath: 'assets/icon/SNOW_logo_icon.png'),
    ServiceInfo(
        id: 'soda',
        name: 'SODA',
        category: ServiceCategory.camera,
        defaultColor: 0xFFFF6B81,
        iconPath: 'assets/icon/SODA_logo_icon.png'),
    ServiceInfo(
        id: 'b612',
        name: 'B612',
        category: ServiceCategory.camera,
        defaultColor: 0xFFFF9500,
        iconPath: 'assets/icon/B612_logo_icon.png'),
    ServiceInfo(
        id: 'foodie',
        name: 'Foodie',
        category: ServiceCategory.camera,
        defaultColor: 0xFFFFD700,
        iconPath: 'assets/icon/FOODIE_logo_icon.png'),
    ServiceInfo(
        id: 'ulike',
        name: 'Ulike',
        category: ServiceCategory.camera,
        defaultColor: 0xFFFF6699,
        iconPath: 'assets/icon/ULIKE_logo_icon.png'),
    ServiceInfo(
        id: 'capcut',
        name: 'CapCut',
        category: ServiceCategory.camera,
        defaultColor: 0xFF000000,
        iconPath: 'assets/icon/CAPCUT_logo_icon.png'),
    ServiceInfo(
        id: 'vita',
        name: 'VITA',
        category: ServiceCategory.camera,
        defaultColor: 0xFF00D4AA,
        iconPath: 'assets/icon/VITA_logo_icon.png'),

    // 소셜
    ServiceInfo(
        id: 'between',
        name: '비트윈',
        category: ServiceCategory.social,
        defaultColor: 0xFFFF6B6B,
        iconPath: 'assets/icon/BETWEEN_logo_icon.png'),
    ServiceInfo(
        id: 'someone',
        name: '썸원',
        category: ServiceCategory.social,
        defaultColor: 0xFFFF85A2,
        iconPath: 'assets/icon/SOMEONE_logo_icon.png'),
    ServiceInfo(
        id: 'cupist',
        name: '글램',
        category: ServiceCategory.social,
        defaultColor: 0xFFE91E63,
        iconPath: 'assets/icon/GLAM_logo_icon.png'),
    ServiceInfo(
        id: 'tinder',
        name: 'Tinder',
        category: ServiceCategory.social,
        defaultColor: 0xFFFF6B6B,
        iconPath: 'assets/icon/TINDER_logo_icon.png'),

    // 기타
    ServiceInfo(
        id: 'kakaotalk',
        name: '카카오톡',
        category: ServiceCategory.other,
        defaultColor: 0xFFFEE500,
        iconPath: 'assets/icon/KAKAOTALK_logo_icon.png'),

    // 추가 인기 서비스
    // 스트리밍
    ServiceInfo(
        id: 'hbo_max',
        name: 'HBO Max',
        category: ServiceCategory.streaming,
        defaultColor: 0xFF5822B4,
        iconPath: 'assets/icon/HBO_MAX_logo_icon.png'),
    ServiceInfo(
        id: 'twitch',
        name: 'Twitch',
        category: ServiceCategory.streaming,
        defaultColor: 0xFF9146FF,
        iconPath: 'assets/icon/TWITCH_logo_icon.png'),

    // 클라우드
    ServiceInfo(
        id: 'dropbox',
        name: 'Dropbox',
        category: ServiceCategory.cloud,
        defaultColor: 0xFF0061FF,
        iconPath: 'assets/icon/DROPBOX_logo_icon.png'),

    // 생산성
    ServiceInfo(
        id: 'canva',
        name: 'Canva',
        category: ServiceCategory.productivity,
        defaultColor: 0xFF00C4CC,
        iconPath: 'assets/icon/CANVA_logo_icon.png'),
    ServiceInfo(
        id: 'zoom',
        name: 'Zoom',
        category: ServiceCategory.productivity,
        defaultColor: 0xFF2D8CFF,
        iconPath: 'assets/icon/ZOOM_logo_icon.png'),

    // 독서
    ServiceInfo(
        id: 'audible',
        name: 'Audible',
        category: ServiceCategory.reading,
        defaultColor: 0xFFF8991C,
        iconPath: 'assets/icon/AUDIBLE_logo_icon.png'),
  ];

  static List<ServiceInfo> getServicesByCategory(ServiceCategory category) {
    return services.where((s) => s.category == category).toList();
  }

  static ServiceInfo? getServiceById(String id) {
    try {
      return services.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<ServiceCategory> get allCategories => ServiceCategory.values;
}
