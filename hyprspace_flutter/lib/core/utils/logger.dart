import 'package:logger/logger.dart';

/// Application-wide structured logger.
///
/// Wraps the `logger` package and provides static helper methods so that
/// callers do not need to obtain a [Logger] instance directly.
class AppLogger {
  static Logger _logger = Logger(level: Level.off);

  /// Initialises the logger. Must be called once in [main].
  static void init({Level level = Level.debug}) {
    _logger = Logger(
      level: level,
      printer: PrettyPrinter(
        methodCount: 1,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
    );
  }

  static void debug(String message, [Object? error, StackTrace? stackTrace]) =>
      _logger.d(message, error: error, stackTrace: stackTrace);

  static void info(String message, [Object? error, StackTrace? stackTrace]) =>
      _logger.i(message, error: error, stackTrace: stackTrace);

  static void warning(String message, [Object? error, StackTrace? stackTrace]) =>
      _logger.w(message, error: error, stackTrace: stackTrace);

  static void error(String message, Object? error, StackTrace? stackTrace) =>
      _logger.e(message, error: error, stackTrace: stackTrace);

  static void wtf(String message, [Object? error, StackTrace? stackTrace]) =>
      _logger.f(message, error: error, stackTrace: stackTrace);
}
