class HistoryItem {
  final String id;
  final String expression;
  final String result;
  final String timestamp;

  HistoryItem({
    required this.id,
    required this.expression,
    required this.result,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'expression': expression,
      'result': result,
      'timestamp': timestamp,
    };
  }

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'] as String? ?? '',
      expression: json['expression'] as String? ?? '',
      result: json['result'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? '',
    );
  }
}
