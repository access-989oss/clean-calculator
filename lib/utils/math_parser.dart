import 'dart:math' as math;

enum AngleUnit { degrees, radians }

class MathParser {
  /// Evaluates a mathematical expression string and returns the result, or null if invalid.
  static double? evaluate(String expr, {AngleUnit angleUnit = AngleUnit.degrees}) {
    if (expr.trim().isEmpty) return null;

    try {
      String sanitized = expr
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('−', '-')
          .replaceAll('√', 'sqrt');

      // Replace constants
      sanitized = sanitized.replaceAll('π', math.pi.toString());
      sanitized = sanitized.replaceAll('e', math.e.toString());

      // Handle simple percentage additions/subtractions: e.g., 200 + 10%
      sanitized = _preprocessPercentages(sanitized);

      final tokens = _tokenize(sanitized);
      if (tokens.isEmpty) return null;

      final parser = _Parser(tokens, angleUnit);
      final result = parser.parse();

      if (result.isNaN || result.isInfinite) return null;
      return result;
    } catch (_) {
      return null;
    }
  }

  static String _preprocessPercentages(String expr) {
    // Replace: number % -> (number / 100)
    final regExp = RegExp(r'(\d+(\.\d+)?)%');
    return expr.replaceAllMapped(regExp, (m) => '(${m[1]} / 100)');
  }

  static List<String> _tokenize(String expr) {
    final List<String> tokens = [];
    int i = 0;
    while (i < expr.length) {
      final c = expr[i];

      if (c == ' ') {
        i++;
        continue;
      }

      if ('+-*/^()'.contains(c)) {
        tokens.add(c);
        i++;
      } else if (_isDigit(c) || c == '.') {
        final buffer = StringBuffer();
        while (i < expr.length && (_isDigit(expr[i]) || expr[i] == '.')) {
          buffer.write(expr[i]);
          i++;
        }
        tokens.add(buffer.toString());
      } else if (_isAlpha(c)) {
        final buffer = StringBuffer();
        while (i < expr.length && _isAlpha(expr[i])) {
          buffer.write(expr[i]);
          i++;
        }
        tokens.add(buffer.toString().toLowerCase());
      } else {
        i++;
      }
    }
    return tokens;
  }

  static bool _isDigit(String s) => s.codeUnitAt(0) >= 48 && s.codeUnitAt(0) <= 57;
  static bool _isAlpha(String s) {
    final code = s.codeUnitAt(0);
    return (code >= 65 && code <= 90) || (code >= 97 && code <= 122);
  }

  /// Formats double cleanly: removes trailing .0 and trims precision issues
  static String formatResult(double value) {
    if (value == value.roundToDouble() && value.abs() < 1e12) {
      return value.toInt().toString();
    }
    String str = value.toStringAsPrecision(10);
    // Remove unnecessary trailing zeroes
    if (str.contains('.')) {
      str = str.replaceAll(RegExp(r'0+$'), '');
      str = str.replaceAll(RegExp(r'\.$'), '');
    }
    return str;
  }
}

class _Parser {
  final List<String> tokens;
  final AngleUnit angleUnit;
  int pos = 0;

  _Parser(this.tokens, this.angleUnit);

  String? get current => pos < tokens.length ? tokens[pos] : null;

  void consume(String expected) {
    if (current == expected) {
      pos++;
    } else {
      throw FormatException("Expected $expected but found $current");
    }
  }

  double parse() {
    final result = _parseAdditionSubtraction();
    if (pos < tokens.length) {
      throw const FormatException("Unexpected tokens remaining");
    }
    return result;
  }

  double _parseAdditionSubtraction() {
    double value = _parseMultiplicationDivision();
    while (current == '+' || current == '-') {
      final op = current;
      pos++;
      final right = _parseMultiplicationDivision();
      if (op == '+') {
        value += right;
      } else {
        value -= right;
      }
    }
    return value;
  }

  double _parseMultiplicationDivision() {
    double value = _parsePower();
    while (current == '*' || current == '/') {
      final op = current;
      pos++;
      final right = _parsePower();
      if (op == '*') {
        value *= right;
      } else {
        if (right == 0) throw const FormatException("Division by zero");
        value /= right;
      }
    }
    return value;
  }

  double _parsePower() {
    double value = _parseUnary();
    while (current == '^') {
      pos++;
      final right = _parseUnary();
      value = math.pow(value, right).toDouble();
    }
    return value;
  }

  double _parseUnary() {
    if (current == '+') {
      pos++;
      return _parseUnary();
    }
    if (current == '-') {
      pos++;
      return -_parseUnary();
    }
    return _parsePrimary();
  }

  double _parsePrimary() {
    final token = current;
    if (token == null) throw const FormatException("Unexpected end of expression");

    // Number
    final numVal = double.tryParse(token);
    if (numVal != null) {
      pos++;
      return numVal;
    }

    // Parentheses
    if (token == '(') {
      pos++;
      final val = _parseAdditionSubtraction();
      consume(')');
      return val;
    }

    // Functions
    if (['sin', 'cos', 'tan', 'sqrt', 'log', 'ln', 'abs'].contains(token)) {
      pos++;
      consume('(');
      final arg = _parseAdditionSubtraction();
      consume(')');

      switch (token) {
        case 'sin':
          return angleUnit == AngleUnit.degrees
              ? math.sin(arg * math.pi / 180)
              : math.sin(arg);
        case 'cos':
          return angleUnit == AngleUnit.degrees
              ? math.cos(arg * math.pi / 180)
              : math.cos(arg);
        case 'tan':
          return angleUnit == AngleUnit.degrees
              ? math.tan(arg * math.pi / 180)
              : math.tan(arg);
        case 'sqrt':
          if (arg < 0) throw const FormatException("Square root of negative number");
          return math.sqrt(arg);
        case 'log':
          if (arg <= 0) throw const FormatException("Log of non-positive number");
          return math.log(arg) / math.ln10;
        case 'ln':
          if (arg <= 0) throw const FormatException("Ln of non-positive number");
          return math.log(arg);
        case 'abs':
          return arg.abs();
      }
    }

    throw FormatException("Unknown token: $token");
  }
}
