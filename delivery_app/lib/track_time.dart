import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

/// A service to track the agent's daily active time using SharedPreferences.
class TimeTrackerService {
  // Singleton setup for a single instance throughout the app
  TimeTrackerService._privateConstructor();
  static final TimeTrackerService _instance = TimeTrackerService._privateConstructor();
  factory TimeTrackerService() {
    return _instance;
  }

  // Keys for storing data in SharedPreferences
  static const String _activeTimeKey = 'daily_active_time_seconds';
  static const String _lastUpdateDateKey = 'last_update_date';
  static const String _sessionStartTimeKey = 'session_start_time';

  /// Checks if the date has changed since the last update and resets the timer if so.
  Future<void> _resetIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final lastUpdate = prefs.getString(_lastUpdateDateKey);

    if (lastUpdate != today) {
      await prefs.setInt(_activeTimeKey, 0); // Reset daily time
      await prefs.setString(_lastUpdateDateKey, today);
      await prefs.remove(_sessionStartTimeKey); // Clear any old session
    }
  }

  /// Records the start time of a new session when the agent goes online.
  Future<void> startSession() async {
    await _resetIfNeeded();
    final prefs = await SharedPreferences.getInstance();
    // Only start a new session if one isn't already running
    if (prefs.getString(_sessionStartTimeKey) == null) {
      await prefs.setString(_sessionStartTimeKey, DateTime.now().toIso8601String());
    }
  }

  /// Calculates the duration of the last session and adds it to the daily total.
  Future<void> endSession() async {
    await _resetIfNeeded();
    final prefs = await SharedPreferences.getInstance();
    final startTimeString = prefs.getString(_sessionStartTimeKey);

    if (startTimeString != null) {
      final startTime = DateTime.parse(startTimeString);
      final sessionDuration = DateTime.now().difference(startTime);

      final currentTotalSeconds = prefs.getInt(_activeTimeKey) ?? 0;
      final newTotalSeconds = currentTotalSeconds + sessionDuration.inSeconds;

      await prefs.setInt(_activeTimeKey, newTotalSeconds);
      // Session has ended, so remove its start time
      await prefs.remove(_sessionStartTimeKey);
    }
  }

  /// Retrieves the total stored active time for today.
  Future<Duration> getStoredActiveTime() async {
    await _resetIfNeeded();
    final prefs = await SharedPreferences.getInstance();
    final totalSeconds = prefs.getInt(_activeTimeKey) ?? 0;
    return Duration(seconds: totalSeconds);
  }

  /// Retrieves the start time of the current active session, if one exists.
  Future<DateTime?> getSessionStartTime() async {
    await _resetIfNeeded();
    final prefs = await SharedPreferences.getInstance();
    final startTimeString = prefs.getString(_sessionStartTimeKey);
    if (startTimeString != null) {
      return DateTime.parse(startTimeString);
    }
    return null;
  }
}