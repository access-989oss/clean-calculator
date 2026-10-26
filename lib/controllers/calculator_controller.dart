import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/history_item.dart';
import '../utils/math_parser.dart';

class CalculatorController extends ChangeNotifier {
  String _expression = '0';
  String _previousExpression = '';
  String _previewResult = '';
  AngleUnit _angleUnit = AngleUnit.degrees;
  bool _isScientific = false;
  bool _isDarkMode = true;
  List<HistoryItem> _history = [];

  CalculatorController() {
    _loadPreferences();
  }

  // Getters
  String get expression => _expression;
  String get previousExpression => _previousExpression;
  String get previewResult => _previewResult;
  AngleUnit get angleUnit => _angleUnit;
  bool get isScientific => _isScientific;
  bool get isDarkMode => _isDarkMode;
  List<HistoryItem> get history => List.unmodifiable(_history);

  // --- ACTIONS ---

  void inputDigit(String digit) {
    _triggerHaptic();
    if (_expression == '0' || _expression == 'Error') {
      _expression = digit;
    } else {
      _expression += digit;
    }
    _updatePreview();
    notifyListeners();
  }

  void inputDot() {
    _triggerHaptic();
    if (_expression == 'Error') _expression = '0';

    final parts = _expression.split(RegExp(r'[+\−\-×÷^]'));
    final lastPart = parts.isNotEmpty ? parts.last : '';
    if (!lastPart.contains('.')) {
      _expression += '.';
      _updatePreview();
      notifyListeners();
    }
  }

  void inputOperator(String op) {
    _triggerHaptic();
    if (_expression == 'Error') _expression = '0';

    const operators = ['+', '-', '−', '×', '÷', '^'];
    final lastChar = _expression.isNotEmpty ? _expression[_expression.length - 1] : '';

    if (operators.contains(lastChar)) {
      _expression = _expression.substring(0, _expression.length - 1) + op;
    } else {
      _expression += op;
    }
    _updatePreview();
    notifyListeners();
  }

  void inputPercent() {
    _triggerHaptic();
    if (_expression == '0' || _expression == 'Error') return;
    final lastChar = _expression[_expression.length - 1];
    if (RegExp(r'[0-9]').hasMatch(lastChar)) {
      _expression += '%';
      _updatePreview();
      notifyListeners();
    }
  }

  void toggleSign() {
    _triggerHaptic();
    if (_expression == '0' || _expression == 'Error') return;

    final regExp = RegExp(r'([+\-−×÷^])?([0-9.]+)$');
    final match = regExp.firstMatch(_expression);

    if (match != null) {
      final fullMatch = match.group(0)!;
      final op = match.group(1);
      final num = match.group(2)!;

      String replacement;
      if (op == '-') {
        replacement = '+$num';
      } else if (op == '+') {
        replacement = '-$num';
      } else if (op == null) {
        replacement = '(-$num)';
      } else {
        replacement = '$op(-$num)';
      }

      _expression = _expression.substring(0, _expression.length - fullMatch.length) + replacement;
      _updatePreview();
      notifyListeners();
    }
  }

  void inputFunction(String funcName) {
    _triggerHaptic();
    if (_expression == '0' || _expression == 'Error') {
      _expression = '$funcName(';
    } else {
      final lastChar = _expression[_expression.length - 1];
      if (RegExp(r'[0-9)]').hasMatch(lastChar)) {
        _expression += '×$funcName(';
      } else {
        _expression += '$funcName(';
      }
    }
    _updatePreview();
    notifyListeners();
  }

  void insertSymbol(String symbol) {
    _triggerHaptic();
    if (_expression == '0' && symbol != '(') {
      _expression = symbol;
    } else if (_expression == 'Error') {
      _expression = symbol;
    } else {
      final lastChar = _expression[_expression.length - 1];
      if ((symbol == 'π' || symbol == 'e') && RegExp(r'[0-9)]').hasMatch(lastChar)) {
        _expression += '×$symbol';
      } else {
        _expression += symbol;
      }
    }
    _updatePreview();
    notifyListeners();
  }

  void applyUnary(String type) {
    _triggerHaptic();
    final res = MathParser.evaluate(_expression, angleUnit: _angleUnit);
    if (res == null) return;

    double calculated;
    String desc;
    if (type == 'sqr') {
      calculated = res * res;
      desc = 'sqr($res)';
    } else if (type == 'inv') {
      if (res == 0) return;
      calculated = 1 / res;
      desc = '1/($res)';
    } else if (type == 'abs') {
      calculated = res.abs();
      desc = 'abs($res)';
    } else {
      return;
    }

    _previousExpression = desc;
    _expression = MathParser.formatResult(calculated);
    _saveToHistory(desc, _expression);
    _previewResult = '';
    notifyListeners();
  }

  void backspace() {
    _triggerHaptic();
    if (_expression == 'Error' || _expression.length <= 1) {
      _expression = '0';
    } else {
      final funcMatch = RegExp(r'(sin|cos|tan|log|ln|sqrt)\($').firstMatch(_expression);
      if (funcMatch != null) {
        _expression = _expression.substring(0, _expression.length - funcMatch.group(0)!.length);
        if (_expression.isEmpty) _expression = '0';
      } else {
        _expression = _expression.substring(0, _expression.length - 1);
      }
    }
    _updatePreview();
    notifyListeners();
  }

  void clear() {
    _triggerHaptic(HapticFeedback.mediumImpact);
    _expression = '0';
    _previewResult = '';
    notifyListeners();
  }

  void calculate() {
    _triggerHaptic(HapticFeedback.mediumImpact);
    if (_expression == 'Error') return;

    // Auto close missing parentheses
    final openCount = '('.allMatches(_expression).length;
    final closeCount = ')'.allMatches(_expression).length;
    if (openCount > closeCount) {
      _expression += ')' * (openCount - closeCount);
    }

    final result = MathParser.evaluate(_expression, angleUnit: _angleUnit);
    if (result == null) {
      _expression = 'Error';
      _previewResult = '';
      notifyListeners();
      return;
    }

    final formatted = MathParser.formatResult(result);
    _previousExpression = '$_expression =';
    _saveToHistory(_expression, formatted);
    _expression = formatted;
    _previewResult = '';
    notifyListeners();
  }

  void toggleScientific() {
    _triggerHaptic();
    _isScientific = !_isScientific;
    notifyListeners();
  }

  void toggleAngleUnit() {
    _triggerHaptic();
    _angleUnit = _angleUnit == AngleUnit.degrees ? AngleUnit.radians : AngleUnit.degrees;
    _updatePreview();
    notifyListeners();
  }

  void toggleTheme() {
    _triggerHaptic();
    _isDarkMode = !_isDarkMode;
    _saveTheme();
    notifyListeners();
  }

  void loadFromHistory(HistoryItem item) {
    _triggerHaptic();
    _previousExpression = item.expression;
    _expression = item.result;
    _previewResult = '';
    notifyListeners();
  }

  void clearHistory() {
    _triggerHaptic();
    _history.clear();
    _saveHistory();
    notifyListeners();
  }

  // --- INTERNAL HELPERS ---

  void _updatePreview() {
    final trimmed = _expression.trim();
    if (!RegExp(r'[+\−\-×÷^%]').hasMatch(trimmed) && !trimmed.contains('(')) {
      _previewResult = '';
      return;
    }

    final res = MathParser.evaluate(trimmed, angleUnit: _angleUnit);
    if (res != null) {
      final formatted = MathParser.formatResult(res);
      if (formatted != trimmed) {
        _previewResult = '= $formatted';
        return;
      }
    }
    _previewResult = '';
  }

  void _triggerHaptic([Function? customFeedback]) {
    try {
      if (customFeedback != null) {
        customFeedback();
      } else {
        HapticFeedback.lightImpact();
      }
    } catch (_) {}
  }

  void _saveToHistory(String expr, String res) {
    final now = DateTime.now();
    final item = HistoryItem(
      id: now.millisecondsSinceEpoch.toString(),
      expression: expr,
      result: res,
      timestamp: DateFormat('hh:mm a').format(now),
    );
    _history.insert(0, item);
    if (_history.length > 50) _history.removeLast();
    _saveHistory();
  }

  Future<void> _saveHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = _history.map((e) => jsonEncode(e.toJson())).toList();
      await prefs.setStringList('calc_history_v1', jsonList);
    } catch (_) {}
  }

  Future<void> _saveTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_dark_mode', _isDarkMode);
    } catch (_) {}
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool('is_dark_mode') ?? true;

      final historyJson = prefs.getStringList('calc_history_v1');
      if (historyJson != null) {
        _history = historyJson
            .map((item) => HistoryItem.fromJson(jsonDecode(item) as Map<String, dynamic>))
            .toList();
      }
      notifyListeners();
    } catch (_) {}
  }
}
