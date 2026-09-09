enum ErrorType { emptyField, tooShort, duplicate, invalidFormat }
enum ErrorSeverity { high, medium, low }

class TechnicalError {
  final int row;
  final String column;
  final ErrorType type;
  final ErrorSeverity severity;
  final String message;

  TechnicalError({
    required this.row,
    required this.column,
    required this.type,
    required this.severity,
    required this.message,
  });
}
