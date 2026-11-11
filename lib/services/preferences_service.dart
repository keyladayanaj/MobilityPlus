import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/accessibility_profile.dart';

class PreferencesService {
  static const _onboardingKey = 'onboarding_completed';
  static const _profileKey = 'accessibility_profile';

  Future<bool> hasCompletedOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  Future<void> saveProfile(AccessibilityProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, jsonEncode(profile.toJson()));
  }

  Future<AccessibilityProfile> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_profileKey);
    if (raw == null) return const AccessibilityProfile();
    try {
      return AccessibilityProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return const AccessibilityProfile();
    }
  }
}
