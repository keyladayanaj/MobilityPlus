class AccessibilityProfile {
  final bool mobility;
  final bool visual;
  final bool hearing;
  final bool cognitive;
  final bool avoidStairs;
  final bool preferRamps;
  final bool screenReader;
  final bool highContrast;
  final bool voiceGuidance;
  final bool visualAlerts;
  final bool simplifiedInterface;
  final double textScale;

  const AccessibilityProfile({
    this.mobility = false,
    this.visual = false,
    this.hearing = false,
    this.cognitive = false,
    this.avoidStairs = false,
    this.preferRamps = false,
    this.screenReader = false,
    this.highContrast = false,
    this.voiceGuidance = false,
    this.visualAlerts = false,
    this.simplifiedInterface = false,
    this.textScale = 1.0,
  });

  AccessibilityProfile copyWith({
    bool? mobility, bool? visual, bool? hearing, bool? cognitive,
    bool? avoidStairs, bool? preferRamps, bool? screenReader,
    bool? highContrast, bool? voiceGuidance, bool? visualAlerts,
    bool? simplifiedInterface, double? textScale,
  }) => AccessibilityProfile(
    mobility: mobility ?? this.mobility,
    visual: visual ?? this.visual,
    hearing: hearing ?? this.hearing,
    cognitive: cognitive ?? this.cognitive,
    avoidStairs: avoidStairs ?? this.avoidStairs,
    preferRamps: preferRamps ?? this.preferRamps,
    screenReader: screenReader ?? this.screenReader,
    highContrast: highContrast ?? this.highContrast,
    voiceGuidance: voiceGuidance ?? this.voiceGuidance,
    visualAlerts: visualAlerts ?? this.visualAlerts,
    simplifiedInterface: simplifiedInterface ?? this.simplifiedInterface,
    textScale: textScale ?? this.textScale,
  );

  Map<String, dynamic> toJson() => {
    'mobility': mobility, 'visual': visual, 'hearing': hearing,
    'cognitive': cognitive, 'avoidStairs': avoidStairs,
    'preferRamps': preferRamps, 'screenReader': screenReader,
    'highContrast': highContrast, 'voiceGuidance': voiceGuidance,
    'visualAlerts': visualAlerts, 'simplifiedInterface': simplifiedInterface,
    'textScale': textScale,
  };

  factory AccessibilityProfile.fromJson(Map<String, dynamic> json) =>
      AccessibilityProfile(
        mobility: json['mobility'] ?? false,
        visual: json['visual'] ?? false,
        hearing: json['hearing'] ?? false,
        cognitive: json['cognitive'] ?? false,
        avoidStairs: json['avoidStairs'] ?? false,
        preferRamps: json['preferRamps'] ?? false,
        screenReader: json['screenReader'] ?? false,
        highContrast: json['highContrast'] ?? false,
        voiceGuidance: json['voiceGuidance'] ?? false,
        visualAlerts: json['visualAlerts'] ?? false,
        simplifiedInterface: json['simplifiedInterface'] ?? false,
        textScale: (json['textScale'] as num?)?.toDouble() ?? 1.0,
      );
}
